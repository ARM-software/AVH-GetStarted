[![Virtual Hardware Target](https://raw.githubusercontent.com/ARM-software/VHT-GetStarted/badges/.github/badges/basic.yml.vht.svg)](https://github.com/ARM-software/VHT-GetStarted/actions/workflows/basic.yml)
![Unittest Results](https://raw.githubusercontent.com/ARM-software/VHT-GetStarted/badges/.github/badges/basic.yml.unittest.svg)

# VHT Basic Example

This project demonstrates how to setup a development workflow with cloud-based
Continuous Integration (CI) for testing an embedded application.

The embedded program implements a set of simple unit tests for execution on
Arm Virtual Hardware Target (VHT). Code development and debug can be done
locally, for example with [CMSIS-Build](https://arm-software.github.io/CMSIS_5/develop/Build/html/index.html) and [Keil MDK](https://developer.arm.com/tools-and-software/embedded/keil-mdk) tools.

Automated test execution is managed with GitHub Actions and gets triggered on
every code change in the repository. The program gets built and run on [Arm
Virtual Hardware (AVH)](https://www.arm.com/products/development-tools/simulation/virtual-hardware) cloud infrastructure in AWS and the test results can
be then observed in repository's [GitHub Actions](https://github.com/ARM-software/VHT-GetStarted/actions).

## Repository Structure

Folder or File in the Repository | Description
:--------------------------------|:--------------------
`./basic/`                       | Folder with the Basic embedded application example
`.basic/RTE/Device/SSE-300-MPS3/`| Folder with target-specific configurable files provided by software components used in the project. Includes system startup files, linker scatter file, CMSIS-Driver configurations and others. See [Components in Project](https://www.keil.com/support/man/docs/uv4/uv4_ca_compinproj.htm) in µVision documentation.
`./basic/main.c`  <br /> `./basic/retarget_stdio.c`        | Application code files
`./basic/basic.debug.uvprojx` <br /> `./basic/basic.debug.uvoptx` | Keil MDK project files
`./basic/basic.debug.cprj`       | Project file in [.cprj format](https://arm-software.github.io/CMSIS_5/Build/html/cprjFormat_pg.html)
`./basic/packlist`               | File with web-locations of software packs used in the .cprj project. The file is provided as an argument for [`cpinstall.sh` command](https://arm-software.github.io/CMSIS_5/Build/html/cp_install.html) called in the CI workflow via `vht.yml`
`./basic/vht_config.txt`         | Configuration file for running the VHT model
`./basic/build.py`               | Python script for project build, execution and analysis of test results
`./basic/vht.yml`                | File with instructions for [VHT-AMI GitHub Action](https://github.com/ARM-software/VHT-AMI)
`./.github/workflows/basic.yml`  | GitHub Actions workflow script
`./requirements.txt`             | File with the list of python packages required for execution of `./basic/build.py`

## Prerequisites

The sections below list the installation and configuration requirements for
both supported use cases:

- execute the tests manually on a local machine
- run tests automatically in the AWS cloud

### Local environment setup

For building, running and debugging on the local machine one needs to install
the following tools.

#### Embedded Toolchain

- IDE for local build and debug (Windows only):
  - [Keil MDK](https://developer.arm.com/tools-and-software/embedded/keil-mdk), Professional Edition
- alternatively, for command-line build without debug (Linux, Windows):
  - [Arm Compiler 6 for Embedded](https://developer.arm.com/tools-and-software/embedded/arm-compiler)
    (also available with [Keil MDK](https://developer.arm.com/tools-and-software/embedded/keil-mdk)
    (Windows) or [Arm DS](https://developer.arm.com/tools-and-software/embedded/arm-development-studio)
    (Linux, Windows))
  - [CMSIS-Build](https://github.com/ARM-software/CMSIS_5/releases/download/5.8.0/cbuild_install.0.10.3.sh)
    command-line building tools provided with the [CMSIS_5 release](https://github.com/ARM-software/CMSIS_5/releases).
    Additionally requires for its operation:
    - [Bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell)) environment.
    - [CMake](https://arm-software.github.io/CMSIS_5/Build/html/cmake.html)
      3.15 or above, and support for its build system (default is Ninja).
  - [Python 3.9](https://www.python.org/downloads/) (*optional*, needed only when using `build.py`)
    - with packages defined in `./requirements.txt`, that shall be installed with:\
      `pip install -r requirements.txt`

#### Target Models

- Virtual Hardware Target (VHT) model of Corstone-300

Note that CMSIS software packs used in the project will be requested and
installed automatically when using Keil MDK or CMSIS-Build.

### Cloud environment setup

Following setup is required for building and running the example program in the cloud as part of a
CI workflow.

- **Amazon Web Service (AWS) account** with:
  - Amazon EC2 (elastic cloud) access
  - Amazon S3 (storage) access
  - Registration to access AVH Amazon Machine Image [AVH AMI](https://aws.amazon.com/marketplace/search/results?searchTerms=Arm+Virtual+Hardware)
  - User role setup for scripted API access
- **GitHub**:
  - Fork of this repository with at least _Write_ access rights
  - Following AWS configuration values stored as
    [GitHub Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets)
    of the forked repository
      Secret Name                    | Description
      :------------------------------|:--------------------
      **AWS_IAM_PROFILE**            | The [IAM Role](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use.html) to be used for AWS access. The value shall be preceded with `Name=` prior to the actual profile name. For example `Name=myAVHRole`.
      **AWS_ACCESS_KEY_ID**<br>**AWS_ACCESS_KEY_SECRET**      | [Access key pair](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html) for the AWS account (as IAM user) that shall be used by the CI workflow for AWS access.
      **AWS_S3_BUCKET**              | The name of the S3 storage bucket to be used for data exchange between GitHub and AWS AMI.
      **AWS_DEFAULT_REGION**         | The data center region the AVH AMI will be run on. For example `eu-west-1`.
      **AWS_AMI_ID**                 | The id of the AVH AMI to be used. Shall correspond to the value provided in _AWS_DEFAULT_REGION_. For example `ami-0c5eeabe11f3a2685`.
      **AWS_SECURITY_GROUP_ID**      | The id of the [VPC security group](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html) to add the EC2 instance to. Shall have format `sg-xxxxxxxx`.
      **AWS_SUBNET_ID**              | The id of the [VPC subnet](https://docs.aws.amazon.com/vpc/latest/userguide/working-with-vpcs.html#view-subnet) to connect the EC2 instance to. Shall have format `subnet-xxxxxxxx`.

## Local build and debug

For developing the tests on the local machine one needs to clone this
repository into a local workspace.

### Building on command line

Open a command prompt in the local workspace. The following instructions assume
Python is installed. If one don't want to go the Python way one can issue the
individual command, manually.

```text
~/VHT-GetStarted $ cd basic
~/VHT-GetStarted/basic $ ./build.py -t debug cbuild
[debug](cbuild:run_cbuild) bash -c 'source $(dirname $(which cbuild.sh))/../etc/setup; cbuild.sh basic.debug.cprj'
[debug](cbuild:run_cbuild) basic.debug.cprj validates
[debug](cbuild:run_cbuild) bash succeeded with exit code 0

Matrix Summary
==============

target    cbuild    cpinstall    report    vht
--------  --------  -----------  --------  ------
debug     success   (skip)       (skip)    (skip)

~/VHT-GetStarted/basic $ ls -lah Objects/basic.axf

-rw-r--r-- 1 **** 4096 64K Nov 25 10:59 Objects/basic.axf
```

### Execute on command line

Open a command prompt in the local workspace. The following instructions assume
Python is installed. If one don't want to go the Python way one can issue the
individual command, manually.

```text
~/VHT-GetStarted $ cd basic
~/VHT-GetStarted/basic $ ./build.py -t debug vht
[debug](vht:run_vht) VHT-Corstone-300 -q --cyclelimit 100000000 -f vht_config.txt Objects/basic.axf
[debug](vht:run_vht) VHT-Corstone-300 succeeded with exit code 0

Matrix Summary
==============

target    cbuild    cpinstall    report    vht
--------  --------  -----------  --------  -----
debug     (skip)    (skip)       (skip)    3/4
```

The summary lists out the number of test cases passed and totally executed.
This example intentionally has one failing test case. Inspect the log to figure
out which test case failed.

```text
~/VHT-GetStarted/basic $ cat vht-20211125151037.log
Fast Models [11.16.24 (Nov  4 2021)]
Copyright 2000-2021 ARM Limited.
All Rights Reserved.
telnetterminal0: Listening for serial connection on port 5000
telnetterminal1: Listening for serial connection on port 5001
telnetterminal2: Listening for serial connection on port 5002
telnetterminal5: Listening for serial connection on port 5003
    Ethos-U rev afc78a99 --- Aug 31 2021 22:41:33
    (C) COPYRIGHT 2019-2021 Arm Limited
    ALL RIGHTS RESERVED
---[ UNITY BEGIN ]---
C:/Users/jonant01/git/VHT-GetStarted/basic/main.c:44:test_my_sum_pos:PASS
C:/Users/jonant01/git/VHT-GetStarted/basic/main.c:45:test_my_sum_neg:PASS
C:/Users/jonant01/git/VHT-GetStarted/basic/main.c:38:test_my_sum_fail:FAIL: Expected 2 Was 0
C:/Users/jonant01/git/VHT-GetStarted/basic/main.c:47:test_my_sum_zero:PASS
-----------------------
4 Tests 1 Failures 0 Ignored
FAIL
---[ UNITY END ]---
Info: Simulation is stopping. Reason: Cycle limit has been exceeded.
Info: /OSCI/SystemC: Simulation stopped by user.
```

This reveals that the test assertion in `main.c` line 38 failed.

### Build and debug in MDK

Open (or import) the `basic.debug.cprj` with MDK. If required the image can
be rebuilt from within MDK. But in general the existing image can be directly
used for debug.

Before launching the debug session one needs to configure the debugger
connection. Bring up the _Options for target..._ dialog from the tool bar.
Navigate to the _Debug_ pane and select _Use: Models ARMv8-M Debugger_. Next
click on the _Settings_ button to bring up the _Models ARMv8-M Target Driver
Setup_ dialog. Select the model executable `VHT-Corstone-300` as the _Command_.
Set `cpu_core.cpu0` as the _Target_. Browse for the _Configuration File_ and
select `vht_config.txt`.

Now start the debug session and the model executable should pop up. By default
MDK stops execution when reaching `main`. Set a breakpoint to line 37 and
continue execution. Hitting the breakpoint one can single step the code under
test to figure out the issue. In this case the issue is obvious:
`1 + (-1) != 2`.

## Running tests in GitHub Actions CI

The repository defines a workflow to build and run the tests using
GitHub Actions on every change i.e., *push* and *pull_request* triggers.

To make this work the repository needs to be configured, see Prerequisites
above.

On every change, the workflow is kicked off executing the following steps.

- Create new EC2 instance\
  A new EC2 instance of the VHT AMI is created on demand using the `aws`
  command line interface. Creating (and terminating) the instance on demand
  saves costs as AWS charges per use. The instance is not accessed directly
  so it doesn't need a public IP address.
- Execute build and test inside the EC2 instance\
  The custom `Arm-Software/VHT-AMI` action is used to
  - upload the workspace to the EC2 instance using a S3 storage bucket;
  - run the command line build;
  - execute the test image using the VHT model; and
  - download the output into the workspace.
- Extract and post-process test output, including
  - conversion of the log file into XUnit format.
- Terminate the EC2 instance
- Archive build/test output\
  The image, log file and XUnit report are attached as a build artifact for
  later analysis.
- Publish test results
