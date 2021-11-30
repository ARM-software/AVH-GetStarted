[![Virtual Hardware Target](https://img.shields.io/github/workflow/status/ARM-software/VHT-GetStarted/Arm%20Virtual%20Hardware%20basic%20example%20-%20github%20hosted%20-%20remote%20AWS%20via%20GH%20plugin/main?event=push&style=flat-square&label=Virtual%20Hardware&logo=data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiPz4NCjwhLS0gR2VuZXJhdG9yOiBBZG9iZSBJbGx1c3RyYXRvciAyNS40LjEsIFNWRyBFeHBvcnQgUGx1Zy1JbiAuIFNWRyBWZXJzaW9uOiA2LjAwIEJ1aWxkIDApICAtLT4NCjxzdmcgdmVyc2lvbj0iMS4xIiBpZD0iTGF5ZXJfMSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayIgeD0iMHB4IiB5PSIwcHgiDQoJIHZpZXdCb3g9IjAgMCA0NyAxNCIgc3R5bGU9ImVuYWJsZS1iYWNrZ3JvdW5kOm5ldyAwIDAgNDcgMTQ7IiB4bWw6c3BhY2U9InByZXNlcnZlIj4NCjxzdHlsZSB0eXBlPSJ0ZXh0L2NzcyI+DQoJLnN0MHtmaWxsOiNGRkZGRkY7fQ0KPC9zdHlsZT4NCjxwYXRoIGNsYXNzPSJzdDAiIGQ9Ik00LjcsN2MwLDIuMiwxLjQsNC4xLDMuNSw0LjFjMS44LDAsMy42LTEuNCwzLjYtNC4xYzAtMi44LTEuNy00LjItMy42LTQuMkM2LjIsMi45LDQuNyw0LjcsNC43LDcgTTExLjYsMC41DQoJaDIuOXYxM2gtMi45di0xLjNjLTAuOSwxLjEtMi4zLDEuNy0zLjcsMS43QzQsMTMuOSwxLjgsMTAuNiwxLjgsN2MwLTQuMywyLjctNi45LDYuMS02LjljMS41LDAsMi44LDAuNywzLjcsMS45VjAuNXoiLz4NCjxwYXRoIGNsYXNzPSJzdDAiIGQ9Ik0xOCwwLjVIMjF2MS4yYzAuMy0wLjQsMC43LTAuOCwxLjItMS4xYzAuNS0wLjMsMS4yLTAuNCwxLjctMC40YzAuOCwwLDEuNiwwLjIsMi4zLDAuNmwtMS4yLDIuOA0KCWMtMC40LTAuMy0xLTAuNC0xLjUtMC40Yy0wLjctMC4xLTEuMywwLjItMS44LDAuN0MyMSw0LjYsMjEsNS45LDIxLDYuOHY2LjdIMThWMC41eiIvPg0KPHBhdGggY2xhc3M9InN0MCIgZD0iTTI4LjIsMC41aDIuOXYxLjJjMC43LTAuOSwxLjktMS42LDMuMS0xLjZjMS4zLDAsMi42LDAuNywzLjIsMS45YzAuOS0xLjIsMi4yLTEuOSwzLjctMS45DQoJQzQyLjcsMCw0NCwwLjksNDQuNywyLjJjMC4yLDAuNCwwLjcsMS40LDAuNywzLjN2OC4xaC0yLjlWNi4zYzAtMS41LTAuMi0yLjEtMC4yLTIuM2MtMC4yLTAuNy0wLjktMS4yLTEuNy0xLjENCgljLTAuNywwLTEuMywwLjMtMS43LDAuOWMtMC41LDAuOC0wLjYsMS45LTAuNiwyLjl2Ni43aC0yLjlWNi4zYzAtMS41LTAuMi0yLjEtMC4yLTIuM2MtMC4yLTAuNy0wLjktMS4yLTEuNy0xLjENCgljLTAuNywwLTEuMywwLjMtMS43LDAuOWMtMC41LDAuOC0wLjYsMS45LTAuNiwyLjl2Ni43aC0yLjlMMjguMiwwLjV6Ii8+DQo8L3N2Zz4NCg==&logoWidth=47)](https://github.com/ARM-software/VHT-GetStarted/actions/workflows/basic.yml)

# VHT Basic Example

This example contains a very basic unit test to show the usage of Arm Virtual
Hardware Target (VHT) for test development and execution.

## Prerequisites

In order to build, run and debug the example one needs to fulfill the following
prerequisites. The tests can be built and run either on the local machine or
using the provided Amazon Machine Image (AMI) running on Amazon EC2.

### Local environment

For building, running and debugging on the local machine one needs to install
the following tools.

- CMSIS-Build
- Arm Compiler 6
- Fast Models
  - Virtual Hardware Target (VHT) model of Corstone-300 (*primary*)
  - Fixed Virtual Platform (FVP) model of Corstone-300 (*alternative*)
- MDK (*optional* for debugging)
- Python 3.8 or later (*optional* for using build.py)
  - packages from requirements.txt\
    `pip install -r requirements.txt`

### Cloud environment

For building and running the tests in the cloud i.e., as part of a Continuous Integration (CI) workflow one needs the following cloud setup.

- Amazon Web Service (AWS) subscription with access to
  - Amazon EC2 (elastic cloud)
  - Amazon S3 (storage)
- Registration to access Arm VHT AMI
- User role setup for scripted API access
- Environment configuration values stored to GitHub secrets
  - **AWS_ACCESS_KEY_ID**\
    The id of the access key.
  - **AWS_ACCESS_KEY_SECRET**\
    The access key secret.
  - **AWS_DEFAULT_REGION**\
    The data center region to be used.
  - **AWS_S3_BUCKET**\
    The id of the S3 storage bucket to be used to data exchange.
  - **AWS_AMI_ID**\
    The id of the Amazon Machine Image (AMI) to be used.
  - **AWS_IAM_PROFILE**\
    The IAM profile to be used.
  - **AWS_SECURITY_GROUP_ID**\
    The id of the security group to add the EC2 instance to.
  - **AWS_SUBNET_ID**\
    The id of the network subnet to connect the EC2 instance to.

## Developing tests

For developing the tests on the local machine one need to clone this
repository into a local workspace. This example makes use of the [Unity
Framework](http://www.throwtheswitch.org/unity) but any other framework
can be used.

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

Not start the debug session and the model executable should pop up. By default
MDK stops execution when reaching `main`. Set a breakpoint to line 37 and
continue execution. Hitting the breakpoint one can single step the code under
test to figure out the issue. In this case the issue is obvious:
`1 + (-1) != 2`.

[^1]: Alternatively one can use the model executable
`FVP_Corstone_SSE-300_Ethos-U55` with target `cpu0` and config file
`fvp_config.txt`.

## Running tests in GitHub Actions CI

The repository contains a workflow definition to build and run the tests using
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
