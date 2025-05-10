#!/bin/sh

TARGET=quince-image-basic
MACHINE=am335x-evm


# Confirm Linux environment
if [ `uname -s` != "Linux" ]; then
	echo "This script must be executed in Linux."
	exit 1
fi


SCRIPT_DIR=$(dirname `readlink -f "$0"`)


# Execute Environment Setup Script
cd ${SCRIPT_DIR}/../..
if [ ! -e layers/openembedded-core/oe-init-build-env ]; then
	echo "Not found layers/openembedded-core/oe-init-build-env."
	exit 1
fi
source layers/openembedded-core/oe-init-build-env


ulimit -n 4096
MACHINE=${MACHINE} bitbake ${TARGET}

