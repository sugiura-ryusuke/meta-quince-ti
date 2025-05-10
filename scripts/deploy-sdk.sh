#!/bin/sh

# This script is only called from do_populate_sdk:append() of image recipes


# Confirm Linux environment
if [ `uname -s` != "Linux" ]; then
	echo "This script must be executed in Linux."
	exit 1
fi

# Confirm the number of arguments
if [ $# -ne 3 ]; then
	echo "This script must be executed in Linux."
	exit 1
fi


# example
#   QUINCE_SDK_DEPLOY_DIR  : sdk-quince-image-minimal-am335x-evm
#   SDKDEPLOYDIR           : tmp/work/am335x-evm-quince-linux/quince-image-minimal/1.0/x86_64-deploy-quince-image-minimal-populate-sdk
#   TOOLCHAIN_OUTPUTNAME   : sdk-quince-image-minimal-am335x-evm-toolchain-5.0.8

SCRIPT_DIR=$(dirname `readlink -f "$0"`)
QUINCE_SDK_DEPLOY_DIR=$1
SDKDEPLOYDIR=$2
TOOLCHAIN_OUTPUTNAME=$3


rm -rf ${QUINCE_SDK_DEPLOY_DIR}


mkdir -p ${QUINCE_SDK_DEPLOY_DIR}
cp ${SDKDEPLOYDIR}/${TOOLCHAIN_OUTPUTNAME}.host.manifest ${QUINCE_SDK_DEPLOY_DIR}
cp ${SDKDEPLOYDIR}/${TOOLCHAIN_OUTPUTNAME}.sh ${QUINCE_SDK_DEPLOY_DIR}
cp ${SDKDEPLOYDIR}/${TOOLCHAIN_OUTPUTNAME}.target.manifest ${QUINCE_SDK_DEPLOY_DIR}
cp ${SDKDEPLOYDIR}/${TOOLCHAIN_OUTPUTNAME}.testdata.json ${QUINCE_SDK_DEPLOY_DIR}

