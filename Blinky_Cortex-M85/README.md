# Arm Virtual Hardware - Blinky Example for Arm Cortex-M85

The **Blinky** project is a simple example that can be used to verify the
basic tool setup for the Arm Cortex-M85.

It is compliant to the Cortex Microcontroller Software Interface Standard (CMSIS)
and uses the CMSIS-RTOS2 API interface for RTOS functionality. The CMSIS-RTOS2 API
is available with various real-time operating systems, for example RTX5 or FreeRTOS.

Code development and debug can be done
locally, for example with [CMSIS-Build](https://arm-software.github.io/CMSIS_5/develop/Build/html/index.html) and [Keil MDK](https://developer.arm.com/tools-and-software/embedded/keil-mdk) tools.

Automated test execution is managed with GitHub Actions and gets triggered on
every code change in the repository. The program gets built and run on [Arm
Virtual Hardware](https://www.arm.com/products/development-tools/simulation/virtual-hardware) cloud infrastructure in AWS and the test results can
be then observed in repository's [GitHub Actions](https://github.com/ARM-software/AVH-GetStarted/actions).

## Example Structure

Folder or Files in the example   | Description
:--------------------------------|:--------------------
`./`                             | Folder with the Basic embedded application example
`./RTE/Device/ARMCM85/`     | Folder with target-specific configurable files provided by software components used in the project. Includes system startup files, linker scatter file, CMSIS-Driver configurations and others. See [Components in Project](https://www.keil.com/support/man/docs/uv4/uv4_ca_compinproj.htm) in µVision documentation.
`./main.c`                       | Application code
`./BLinky.Corstone-310.cprj`     | Project file in [.cprj format](https://arm-software.github.io/CMSIS_5/Build/html/cprjFormat_pg.html)
`./vht_config.txt`               | Configuration file for running the Virtual Hardware model from command line
`./avh.yml`                      | File with instructions for [AVH Client for Python](https://github.com/ARM-software/avhclient)

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

- Arm Virtual Hardware (AVH) model of Arm Corstone-310 sub-system.

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
      Secret Name                                    | Description
      :----------------------------------------------|:--------------------
      `AWS_ACCESS_KEY_ID`<br>`AWS_SECRET_ACCESS_KEY` | [Access key pair](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html) for the AWS account (as IAM user) that shall be used by the CI workflow for AWS access.
      `AWS_IAM_PROFILE`                              | The [IAM Role](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use.html) to be used for AWS access.
      `AWS_S3_BUCKET_NAME`                           | The name of the S3 storage bucket to be used for data exchange between GitHub and AWS AMI.
      `AWS_DEFAULT_REGION`                           | The data center region the AVH AMI will be run on. For example `eu-west-1`.
      `AWS_EC2_SECURITY_GROUP_ID`                    | The id of the [VPC security group](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html) to add the EC2 instance to. Shall have format `sg-xxxxxxxx`.
      `AWS_SUBNET_ID`                                | The id of the [VPC subnet](https://docs.aws.amazon.com/vpc/latest/userguide/working-with-vpcs.html#view-subnet) to connect the EC2 instance to. Shall have format `subnet-xxxxxxxx`.

## Local build and debug

For developing the tests on the local machine one needs to clone this
repository into a local workspace.

### Build and debug in MDK

[Run with MDK-Professional](https://arm-software.github.io/AVH/main/infrastructure/html/run_mdk_pro.html)
explains in details the tool setup and project configuration for running an
MDK project on Arm Virtual Hardware.

For this example, import the `Blinky.Corstone-310.cprj` in MDK. Before launching the debug session one needs to
verify the debugger configuration:

- Bring up the _Options for target..._ dialog from the tool bar.
- Navigate to the _Debug_ pane and select _Use: Models ARMv8-M Debugger_.
- Next, click on the _Settings_ button to bring up the _Models ARMv8-M Target Driver Setup_ dialog.
- Select in the as the _Command_ field the model executable for Corstone SSE-310
  (filename is: `VHT_Corstone_SSE-310.exe`
  in the location where Virtual Hardware models are installed).
- Set `cpu0` as the _Target_.
- Browse for the _Configuration File_ and select `vht_config.txt`.

Now, start the debug session and the model executable should pop up. By default,
MDK stops execution when reaching `main`. Run the project to see the virtual LEDs
switching.

## Running tests in GitHub Actions CI

The repository defines a workflow to build and run the tests using
GitHub Actions on every change i.e., *push* and *pull_request* triggers.

To make this work the repository needs to be configured, see Prerequisites
above.

On every change, the workflow is kicked off executing the following steps.

- Execute build and test inside an EC2 instance\
  The [AVH Client for Python](https://github.com/ARM-software/avhclient) is used to
  - create new EC2 instance
  - upload the workspace to the EC2 instance using a S3 storage bucket;
  - run the command line build;
  - execute the test image using the AVH model
  - download the output into the workspace.
  - terminate the EC2 instance 
- Archive build/test output\
  The image and log file are attached as a build artifact for
  later analysis.
- Publish test results
