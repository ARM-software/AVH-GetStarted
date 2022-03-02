#!/usr/bin/python3

import logging
import re
import shutil

from datetime import datetime
from enum import Enum
from glob import iglob
from io import StringIO
from junit_xml import TestSuite, TestCase, to_xml_report_string
from os import environ
from pathlib import Path
from tempfile import NamedTemporaryFile
from typing import AnyStr, Tuple

from matrix_runner import main, matrix_axis, matrix_action, matrix_command, ConsoleReport, CropReport, ReportFilter

# Colors for the Unittest result badge
UNITTEST_BADGE_COLOR = {
    True: 'green',      # stable: all tests passing
    False: 'yellow',    # unstable: not all tests passing
    None: 'red'         # error: no test results generated
}

class UnityReport(ReportFilter):
    class Result(ReportFilter.Result, ReportFilter.Summary):
        @property
        def stream(self) -> StringIO:
            if not self._stream:
                try:
                    self._stream = StringIO()
                    input = self._other.stream
                    input.seek(0)
                    tcs = []
                    for line in input:
                        m = re.match('(.*):(\d+):(\w+):(PASS|FAIL)(:(.*))?', line)
                        if m:
                            tc = TestCase(m.group(3), file=Path(m.group(1)).relative_to(Path.cwd()), line=m.group(2))
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

@matrix_axis("target", "t", "The project target(s) to build")
class TargetAxis(Enum):
    debug = ('debug')


@matrix_action
def cbuild(config):
    """Build the config(s) with CMSIS-Build"""
    yield run_cbuild(config)

@matrix_action
def vht(config, results):
    """Run the config(s) with fast model"""
    yield run_vht(config)
    ts = timestamp()
    results[0].test_report.write(f"basic-{ts}.xunit")
    with open(f"vht-{ts}.log", "w") as file:
        results[0].output.seek(0)
        shutil.copyfileobj(results[0].output, file)

@matrix_action
def report(config, results):
    """Convert latest test log to XUnit report"""
    log = max(iglob("vht-*.log"), default=None)
    if not log:
        logging.error("No vht-*.log file found!")
        if 'GITHUB_WORKFLOW' in environ:
            print(f"::set-output name=badge::Unittest-failed-{UNITTEST_BADGE_COLOR[None]}")
        return
    yield cat_log(log)
    ts = re.match("vht-(\d+)\\.log", log).group(1)
    results[0].test_report.write(f"basic-{ts}.xunit")
    passed, executed = results[0].test_report.summary
    if 'GITHUB_WORKFLOW' in environ:
        print(f"::set-output name=badge::Unittest-{passed}%20of%20{executed}%20passed-{UNITTEST_BADGE_COLOR[passed == executed]}")

@matrix_command(needs_shell=False)
def run_cbuild(config):
    return ["cbuild.sh", f"basic.{config.target}.cprj"]

@matrix_command(test_report=ConsoleReport()|CropReport("---\[ UNITY BEGIN \]---", '---\[ UNITY END \]---')|UnityReport())
def run_vht(config):
    return ["VHT_Corstone_SSE-300_Ethos-U55", "-q", "--stat", "--simlimit", "1", "-f", "vht_config.txt", "Objects/basic.axf"]

@matrix_command(needs_shell=True, test_report=ConsoleReport()|CropReport("---\[ UNITY BEGIN \]---", '---\[ UNITY END \]---')|UnityReport())
def cat_log(log):
    cwd = Path.cwd().as_posix().replace('/','\\/')
    return ["bash", "-c", f"\"cat {log} | sed 's/\\/home\\/ubuntu\\/vhtwork/{cwd}/'\""]

def timestamp(t: datetime = datetime.now()):
    return t.strftime("%Y%m%d%H%M%S")

if __name__ == "__main__":
    main()
