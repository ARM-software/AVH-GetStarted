#!/bin/bash -e
set -e

#################################################################################
# Helper script to update CMSIS-Toolbox into AVH EC2 instance                   #
# It considers:                                                                 #
#    Compilers are installed and they are on PATH                               #
#    Environment Variables are already set                                      #
#                                                                               #
# Helper script designed to be run inside AVH EC2 instance                      #
#                                                                               #
# Execution: ARM_CLANG_PATH=$(which armclang) sudo -E ./update_cmsis_toolbox.sh #
# Be sure the script file is executable                                         #
#################################################################################

# https://github.com/Open-CMSIS-Pack/devtools/releases
CMSIS_TOOLBOX_VERSION=0.10.2
CMSIS_TOOLBOX_FILENAME=cmsis-toolbox-linux64
CMSIS_TOOLBOX_URL=https://github.com/Open-CMSIS-Pack/devtools/releases/download/tools/toolbox/${CMSIS_TOOLBOX_VERSION}/${CMSIS_TOOLBOX_FILENAME}.tar.gz
CMSIS_TOOLBOX_DEST_DIR=/opt/ctools

# install CMSIS-Toolbox
pushd /tmp
rm -rf ${CMSIS_TOOLBOX_FILENAME}*
rm -rf ${CMSIS_TOOLBOX_DEST_DIR}
mkdir -p ${CMSIS_TOOLBOX_DEST_DIR}

wget ${CMSIS_TOOLBOX_URL}
tar -xvf ${CMSIS_TOOLBOX_FILENAME}.tar.gz

cd ${CMSIS_TOOLBOX_FILENAME}
cp -r * ${CMSIS_TOOLBOX_DEST_DIR}/
chmod 755 -R ${CMSIS_TOOLBOX_DEST_DIR}/bin/
popd

# update pack index file
cpackget index https://www.keil.com/pack/index.pidx -f

# update armclang location for for AC6.6.18.0.cmake
sed -i "s|/home/runner/ArmCompilerforEmbedded6.18/bin|$ARM_CLANG_PATH|g" "$CMSIS_TOOLBOX_DEST_DIR/etc/AC6.6.18.0.cmake"
