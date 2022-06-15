#!/bin/bash -e
set -e

##############################################################
# Helper script to install build tools into AVH EC2 instance #
# Helper script designed to be run inside AVH EC2 instance   #
#                                                            #
# Execution: sudo ./install_avh_build_tools.sh               #
# Be sure the script file is executable                      #
##############################################################

# variables
APT_PACKAGES="cmake ninja-build"

# https://github.com/Open-CMSIS-Pack/devtools/releases
CMSIS_TOOLBOX_VERSION=0.10.2
CMSIS_TOOLBOX_FILENAME=cmsis-toolbox-linux64
CMSIS_TOOLBOX_URL=https://github.com/Open-CMSIS-Pack/devtools/releases/download/tools%2Ftoolbox%2F${CMSIS_TOOLBOX_VERSION}/${CMSIS_TOOLBOX_FILENAME}.tar.gz
CMSIS_TOOLBOX_DEST_DIR=/opt/ctools

# install apt packages
sudo apt install ${APT_PACKAGES}

# install CMSIS-Toolbox
pushd /tmp
mkdir -p ${CMSIS_TOOLBOX_DEST_DIR}
wget ${CMSIS_TOOLBOX_URL}
tar -xvf ${CMSIS_TOOLBOX_FILENAME}.tar.gz
cd ${CMSIS_TOOLBOX_FILENAME}
sudo cp -r * ${CMSIS_TOOLBOX_DEST_DIR}/
sudo chmod 755 -R ${CMSIS_TOOLBOX_DEST_DIR}/bin/
popd
