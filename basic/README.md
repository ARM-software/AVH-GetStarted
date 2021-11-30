[![Virtual Hardware Target](https://img.shields.io/github/workflow/status/ARM-software/VHT-GetStarted/Arm%20Virtual%20Hardware%20basic%20example%20-%20github%20hosted%20-%20remote%20AWS%20via%20GH%20plugin/main?event=push&style=flat-square&label=Virtual%20Hardware&logo=data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiPz4NCjwhLS0gR2VuZXJhdG9yOiBBZG9iZSBJbGx1c3RyYXRvciAyNS40LjEsIFNWRyBFeHBvcnQgUGx1Zy1JbiAuIFNWRyBWZXJzaW9uOiA2LjAwIEJ1aWxkIDApICAtLT4NCjxzdmcgdmVyc2lvbj0iMS4xIiBpZD0iTGF5ZXJfMSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayIgeD0iMHB4IiB5PSIwcHgiDQoJIHZpZXdCb3g9IjAgMCA0NyAxNCIgc3R5bGU9ImVuYWJsZS1iYWNrZ3JvdW5kOm5ldyAwIDAgNDcgMTQ7IiB4bWw6c3BhY2U9InByZXNlcnZlIj4NCjxzdHlsZSB0eXBlPSJ0ZXh0L2NzcyI+DQoJLnN0MHtmaWxsOiNGRkZGRkY7fQ0KPC9zdHlsZT4NCjxwYXRoIGNsYXNzPSJzdDAiIGQ9Ik00LjcsN2MwLDIuMiwxLjQsNC4xLDMuNSw0LjFjMS44LDAsMy42LTEuNCwzLjYtNC4xYzAtMi44LTEuNy00LjItMy42LTQuMkM2LjIsMi45LDQuNyw0LjcsNC43LDcgTTExLjYsMC41DQoJaDIuOXYxM2gtMi45di0xLjNjLTAuOSwxLjEtMi4zLDEuNy0zLjcsMS43QzQsMTMuOSwxLjgsMTAuNiwxLjgsN2MwLTQuMywyLjctNi45LDYuMS02LjljMS41LDAsMi44LDAuNywzLjcsMS45VjAuNXoiLz4NCjxwYXRoIGNsYXNzPSJzdDAiIGQ9Ik0xOCwwLjVIMjF2MS4yYzAuMy0wLjQsMC43LTAuOCwxLjItMS4xYzAuNS0wLjMsMS4yLTAuNCwxLjctMC40YzAuOCwwLDEuNiwwLjIsMi4zLDAuNmwtMS4yLDIuOA0KCWMtMC40LTAuMy0xLTAuNC0xLjUtMC40Yy0wLjctMC4xLTEuMywwLjItMS44LDAuN0MyMSw0LjYsMjEsNS45LDIxLDYuOHY2LjdIMThWMC41eiIvPg0KPHBhdGggY2xhc3M9InN0MCIgZD0iTTI4LjIsMC41aDIuOXYxLjJjMC43LTAuOSwxLjktMS42LDMuMS0xLjZjMS4zLDAsMi42LDAuNywzLjIsMS45YzAuOS0xLjIsMi4yLTEuOSwzLjctMS45DQoJQzQyLjcsMCw0NCwwLjksNDQuNywyLjJjMC4yLDAuNCwwLjcsMS40LDAuNywzLjN2OC4xaC0yLjlWNi4zYzAtMS41LTAuMi0yLjEtMC4yLTIuM2MtMC4yLTAuNy0wLjktMS4yLTEuNy0xLjENCgljLTAuNywwLTEuMywwLjMtMS43LDAuOWMtMC41LDAuOC0wLjYsMS45LTAuNiwyLjl2Ni43aC0yLjlWNi4zYzAtMS41LTAuMi0yLjEtMC4yLTIuM2MtMC4yLTAuNy0wLjktMS4yLTEuNy0xLjENCgljLTAuNywwLTEuMywwLjMtMS43LDAuOWMtMC41LDAuOC0wLjYsMS45LTAuNiwyLjl2Ni43aC0yLjlMMjguMiwwLjV6Ii8+DQo8L3N2Zz4NCg==&logoWidth=47)](https://github.com/ARM-software/VHT-GetStarted/actions/workflows/basic.yml)

# VHT Basic Example

This project demonstrates how to setup a development workflow with cloud-based Continuous Integration (CI) for testing an embedded application.

The embedded program implements a set of simple unit tests for execution on an Arm Virtual Hardware Target (VHT). Code development and debug can be done locally, for example with CMSIS-Build and Keil MDK tools. 

Automated test execution is managed with GitHub Actions and gets triggered on every code change in the repository. The program gets built and run on Arm Virtual Hardware (AVH) cloud infrastructure in AWS and the test results can be then observed in GitHub Actions.

## Repository Structure

Folder or File in the Repository | Description
:--------------------------------|:--------------------
`./basic/`                       | Folder with the Basic embedded application example
`./basic/main.c`                 | Application code file
`./basic/basic.debug.uvprojx` <br /> `./basic/basic.debug.uvoptx` | Keil MDK project files
`./basic/basic.debug.cprj`       | Project file in [.cprj format](https://arm-software.github.io/CMSIS_5/Build/html/cprjFormat_pg.html)
`./basic/packlist`               | File with web-locations of external software components used by the .cprj project
`./basic/build.py`               | Python script for automated project build and unit test execution
`./basic/vht_config.txt` <br /> `./basic/fvp_config.txt`  | Configuration files for target models
`./.github/workflows/basic.yml`  | GitHub Actions workflow script
`./requirements.txt`             | File with the list of python packages required for execution of `./basic/build.py`

## Prerequisites

The sections below list the installation and configuration requirements for both supported use cases:
- execute the tests manually on a local machine
- run tests automatically in the AWS cloud 

### Local environment setup

For building, running and debugging on the local machine one needs to install the following tools.

**Embedded Toolchain**
- IDE for local build and debug (Windows only):
  - [Keil MDK](https://developer.arm.com/tools-and-software/embedded/keil-mdk), Professional Edition
- alternatively, for command-line build without debug (Linux, Windows):
  - [Arm Compiler 6 for Embedded](https://developer.arm.com/tools-and-software/embedded/arm-compiler) (also available with [Keil MDK]((https://developer.arm.com/tools-and-software/embedded/keil-mdk)) (Windows) or [Arm DS](https://developer.arm.com/tools-and-software/embedded/arm-development-studio) (Linux, Windows))
  - [CMSIS-Build](https://github.com/ARM-software/CMSIS_5/releases/download/5.8.0/cbuild_install.0.10.3.sh) command-line building tools provided with the [CMSIS_5 release](https://github.com/ARM-software/CMSIS_5/releases). Additionally requires for its operation:
     - [Bash](https://en.wikipedia.org/wiki/Bash_(Unix_shell)) environment.
     - [CMake](https://arm-software.github.io/CMSIS_5/Build/html/cmake.html) 3.15 or above, and support for its build system (default is Ninja).
  - [Python 3.9](https://www.python.org/downloads/) (*optional*, needed only when using `build.py`)
    - with packages defined in `./requirements.txt`, that shall be installed with:\
      `pip install -r requirements.txt`

**Target Models**
  - Virtual Hardware Target (VHT) model of Corstone-300 (*primary*)
  - [Ecosystem Fixed Virtual Platform (FVP) for Corstone-300 MPS3](https://developer.arm.com/tools-and-software/open-source-software/arm-platforms-software/arm-ecosystem-fvps) (*alternative*)

Note that CMSIS software packs used in the project will be requested and installed automatically when using Keil MDK or CMSIS-Build.

### Cloud environment setup

For building and running the example program in the cloud, as part of a Continuous Integration (CI) workflow one needs the following setup.

- Amazon Web Service (AWS) account with:
  - Amazon EC2 (elastic cloud) access
  - Amazon S3 (storage) access
  - Registration to access [Arm VHT AMI](https://aws.amazon.com/marketplace/search/results?searchTerms=Arm+Virtual+Hardware)
  - User role setup for scripted API access
- GitHub:
  - Fork of this repository with at least _Write_ access rights
  - Following AWS configuration values stored as [GitHub Secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets) of the forked repository
      Secret Name                    | Description
      :------------------------------|:--------------------
      **AWS_ACCESS_KEY_ID**          | The id of the access key
      **AWS_ACCESS_KEY_SECRET**      | The access key secret
      **AWS_DEFAULT_REGION**         | The data center region to be used
      **AWS_S3_BUCKET**              | The id of the S3 storage bucket to be used to data exchange
      **AWS_AMI_ID**                 | The id of the Amazon Machine Image (AMI) to be used
      **AWS_IAM_PROFILE**            | The IAM profile to be used
      **AWS_SECURITY_GROUP_ID**      | The id of the security group to add the EC2 instance to
      **AWS_SUBNET_ID**              | The id of the network subnet to connect the EC2 instance to

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

target    cbuild    cpinstall    fvp     report    vht
--------  --------  -----------  ------  --------  ------
debug     success   (skip)       (skip)  (skip)    (skip)

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

target    cbuild    cpinstall    fvp     report    vht
--------  --------  -----------  ------  --------  -----
debug     (skip)    (skip)       (skip)  (skip)    3/4
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
Setup_ dialog. Select the model executable `VHT-Corstone-300`[^1] as the _Command_.
Set `cpu_core.cpu0` as the _Target_. Browse for the _Configuration File_ and
select `vht_config.txt`.

Now start the debug session and the model executable should pop up. By default
MDK stops execution when reaching `main`. Set a breakpoint to line 37 and
continue execution. Hitting the breakpoint one can single step the code under
test to figure out the issue. In this case the issue is obvious:
`1 + (-1) != 2`.

[^1]: Alternatively one can use the model executable
`FVP_Corstone_SSE-300_Ethos-U55` with target `cpu0` and config file
`fvp_config.txt`.

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
