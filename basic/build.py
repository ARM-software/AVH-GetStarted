#!/usr/bin/python3

import logging
import re
import shutil

from datetime import datetime
from enum import Enum
from glob import iglob, glob
from io import StringIO
from zipfile import ZipFile

from junit_xml import TestSuite, TestCase, to_xml_report_string
from os import environ
from pathlib import Path
from typing import Tuple

from matrix_runner import main, matrix_axis, matrix_action, matrix_command, ConsoleReport, CropReport, ReportFilter

# Colors for the Unittest result badge
UNITTEST_BADGE_COLOR = {
    True: 'green',      # stable: all tests passing
    False: 'yellow',    # unstable: not all tests passing
    None: 'red'         # error: no test results generated
}


class UnityReport(ReportFilter):
    class Result(ReportFilter.Result, ReportFilter.Summary):
        @staticmethod
        def common_fix(s1, s2):
            steps = range(min(len(s1), len(s2)) - 1, -1, -1)
            return next((s2[:n] for n in steps if s1[-n:] == s2[:n]), '')

        @property
        def stream(self) -> StringIO:
            if not self._stream:
                try:
                    self._stream = StringIO()
                    input = self._other.stream
                    input.seek(0)
                    tcs = []
                    cwd = Path.cwd()
                    for line in input:
                        m = re.match('(.*):(\d+):(\w+):(PASS|FAIL)(:(.*))?', line)
                        if m:
                            file = Path(m.group(1))
                            try:
                                file = file.relative_to(cwd)
                            except ValueError as e:
                                if "is not in the subpath" in e.args[0]:
                                    logging.info(e)
                                    lookup = glob(str(Path.cwd().joinpath("**").joinpath(file.name)), recursive=True)
                                    if len(lookup) != 1:
                                        raise e
                                    logging.info("Found similar named file at '%s'.", str(lookup[0]))
                                    file = Path(lookup[0]).relative_to(Path.cwd())
                                    if m.group(1).endswith(str(file)):
                                        cwd = Path(m.group(1)[0:-len(str(file))])
                                        logging.info("Deduced working directory is '%s'.", str(cwd))

                            tc = TestCase(m.group(3), file=file, line=m.group(2))
                            if m.group(4) == "FAIL":
                                tc.add_failure_info(message=m.group(6).strip())
                            tcs += [tc]
                    self.ts = TestSuite("Cloud-CI basic tests", tcs)
                    self._stream.write(to_xml_report_string([self.ts]))
                except Exception as e:
                    self._stream = e
            if isinstance(self._stream, Exception):
                raise RuntimeError from self._stream
            else:
                return self._stream

        @property
        def summary(self) -> Tuple[int, int]:
            passed = len([tc for tc in self.ts.test_cases if not (tc.is_failure() or tc.is_error() or tc.is_skipped())])
            executed = len(self.ts.test_cases)
            return passed, executed

    def __init__(self, *args):
        super(UnityReport, self).__init__()
        self.args = args


def timestamp(t: datetime = datetime.now()):
    return t.strftime("%Y%m%d%H%M%S")


@matrix_axis("target", "t", "The project target(s) to build")
class TargetAxis(Enum):
    debug = ('debug')


@matrix_action
def build(config, results):
    """Build the config(s) with CMSIS-Build"""
    yield run_cbuild(config)
    if not results[0].success:
        return

    file = f"basic-{timestamp()}.zip"
    logging.info(f"Archiving build output to {file}...")
    with ZipFile(file, "w") as archive:
        archive.write(f"Objects/basic.axf")
        archive.write(f"Objects/basic.axf.map")
        archive.write(f"Objects/basic.{config.target}.clog")


@matrix_action
def run(config, results):
    """Run the config(s) with fast model"""
    yield run_vht(config)
    ts = timestamp()
    if not results[0].success:
        print(f"::set-output name=badge::Unittest-failed-{UNITTEST_BADGE_COLOR[None]}")
    else:
        results[0].test_report.write(f"basic-{ts}.xunit")
        passed, executed = results[0].test_report.summary
        print(f"::set-output name=badge::Unittest-{passed}%20of%20{executed}%20passed-{UNITTEST_BADGE_COLOR[passed == executed]}")


@matrix_command(needs_shell=False)
def run_cbuild(config):
    return ["bash", "-c", f"cbuild.sh --quiet basic.{config.target}.cprj"]


@matrix_command(test_report=ConsoleReport()|CropReport("---\[ UNITY BEGIN \]---", '---\[ UNITY END \]---')|UnityReport())
def run_vht(config):
    return ["VHT_Corstone_SSE-300_Ethos-U55", "-q", "--stat", "--simlimit", "1", "-f", "vht_config.txt", "Objects/basic.axf"]


if __name__ == "__main__":
    main()
