#!/bin/sh

DEFAULT_MACHINE=am335x-evm
SDK_TARGET_ARCH=x86_64
TIMESTAMP_ROOTFS=1735657200


# Confirm Linux environment
if [ `uname -s` != "Linux" ]; then
	echo "This script must be executed in Linux."
	exit 1
fi


SCRIPT_DIR=$(dirname `readlink -f "$0"`)
CPU_CORE_NUM=`cat /proc/cpuinfo | grep "^processor" | wc -l`


# Execute Environment Setup Script
cd ${SCRIPT_DIR}/../../..
if [ ! -e layers/openembedded-core/oe-init-build-env ]; then
	echo "Not found layers/openembedded-core/oe-init-build-env."
	exit 1
fi
source layers/openembedded-core/oe-init-build-env


# Configuring build/conf/local.conf
if [ -e conf/.quince_conf_setup ]; then
	echo "conf/local.conf setup is already done. skip."
else
	touch conf/.quince_conf_setup

	sed -e "s/^MACHINE.*$/MACHINE ?= \"${DEFAULT_MACHINE}\"/" \
        -e "s/^#SDKMACHINE.*$/SDKMACHINE ?= \"${SDK_TARGET_ARCH}\"/" \
        -i conf/local.conf

	cat << EOS >> conf/local.conf

# records a history of build output metadata
INHERIT += "buildhistory"
BUILDHISTORY_DIR ?= "\${TOPDIR}/buildhistory"

# The maximum number of tasks BitBake should run in parallel at any one time
BB_NUMBER_THREADS ?= "${CPU_CORE_NUM}"
PARALLEL_MAKE ?= "-j ${CPU_CORE_NUM}"

# rootfs image timestamp
REPRODUCIBLE_TIMESTAMP_ROOTFS = "${TIMESTAMP_ROOTFS}"

# Override hostname
#hostname:pn-base-files = "myhostname"

# Package names in the /opt directory (This system calls /opt/\${QUINCE_OPT_PACKAGE_NAME}/etc/rc.local at startup)
#QUINCE_OPT_PACKAGE_NAME ?= "quince"

# Disable LAN connection at startup
#QUINCE_DISABLE_LAN_STARTUP ?= "0"

# eth0 IP address
#QUINCE_ETH0_ADDRESS = "192.168.1.100"

# eth0 subnet mask (only valid if QUINCE_ETH0_ADDRESS is defined)
#QUINCE_ETH0_NETMASK = "255.255.255.0"

# eth0 default gateway (only valid if QUINCE_ETH0_ADDRESS is defined)
#QUINCE_ETH0_GATEWAY = "192.168.1.1"

# use PHRAM (for Booting Linux Kernel with rootfs in PHRAM)
#QUINCE_PHRAM = "1"

# rootfs image file name
#QUINCE_ROOTFS_IMG_FILE = "rootfs.img"

# opt image file name
#QUINCE_OPT_IMG_FILE = "opt.img"

EOS

fi


# Copy scripts
mkdir -p scripts
cp ${SCRIPT_DIR}/bitbake-minimal-am335x-evm.sh scripts
cp ${SCRIPT_DIR}/clean-build.sh scripts
cp ${SCRIPT_DIR}/deploy.sh scripts
cp ${SCRIPT_DIR}/flash-wic-image.sh scripts
cp ${SCRIPT_DIR}/write-sdcard.sh scripts


# Add layers for building Quince Distribution
bitbake-layers add-layer ../layers/meta-openembedded/meta-oe
bitbake-layers add-layer ../layers/meta-openembedded/meta-python
bitbake-layers add-layer ../layers/meta-openembedded/meta-networking
bitbake-layers add-layer ../layers/meta-openembedded/meta-filesystems
bitbake-layers add-layer ../layers/meta-arm/meta-arm-toolchain
bitbake-layers add-layer ../layers/meta-arm/meta-arm
bitbake-layers add-layer ../layers/meta-ti/meta-ti-bsp
bitbake-layers add-layer ../layers/meta-quince
bitbake-layers add-layer ../layers/meta-quince-ti


# Show layers
bitbake-layers show-layers

