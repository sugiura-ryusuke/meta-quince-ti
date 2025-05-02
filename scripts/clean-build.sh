#!/bin/sh


# Confirm Linux environment
if [ `uname -s` != "Linux" ]; then
	echo "This script must be executed in Linux."
	exit 1
fi


SCRIPT_DIR=$(dirname `readlink -f "$0"`)


# Execute Environment Setup Script
cd ${SCRIPT_DIR}/..
PWD_LAST=`pwd | awk -F/ '{ print $NF }'`
if [ "${PWD_LAST}" != "build" ]; then
	echo "This directory is not build directory."
	exit 1
fi


rm -rf buildhistory
rm -rf cache
rm -rf deploy-ti
rm -rf sstate-cache
rm -rf tmp*
rm -f bitbake-cookerdaemon.log

