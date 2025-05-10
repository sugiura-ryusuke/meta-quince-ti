FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
    file://reserved-memory-phram-arm.dtsi \
    file://reserved-memory-phram-arm64.dtsi \
"

# Enable MTD_PHRAM
enable_mtd_phram() {
	KERNEL_CONFIG="CONFIG_MTD CONFIG_MTD_BLOCK CONFIG_MTD_PHRAM"

	for cfg in ${KERNEL_CONFIG}; do
		if grep -q "${cfg}=" ${1}; then
			sed -e "s/${cfg}=./${cfg}=y/" -i ${1}
		else
			echo "${cfg}=y" >> ${1}
		fi
	done
}

# Enable GPIO_SYSFS
enable_gpio_sysfs() {
	KERNEL_CONFIG="CONFIG_SYSFS CONFIG_EXPERT CONFIG_GPIO_SYSFS"

	for cfg in ${KERNEL_CONFIG}; do
		if grep -q "${cfg}=" ${1}; then
			sed -e "s/${cfg}=./${cfg}=y/" -i ${1}
		else
			echo "${cfg}=y" >> ${1}
		fi
	done
}

# Allocate "reserved-memory" region for PHRAM (32-bit address space)
allocate_phram_area_32bit() {
	export MEMORY_ADDR=`echo "${QUINCE_PHRAM_ADDR}" | sed 's/^0x//'`

	sed -e "s/@@QUINCE_PHRAM_ADDR@@/${QUINCE_PHRAM_ADDR}/" \
        -e "s/@@QUINCE_PHRAM_SIZE@@/${QUINCE_PHRAM_SIZE}/" \
        -e "s/@@MEMORY_ADDR@@/${MEMORY_ADDR}/" \
        "${WORKDIR}/reserved-memory-phram-arm.dtsi" >> "$1"
}

# Allocate "reserved-memory" region for PHRAM (64-bit address space)
allocate_phram_area_64bit() {
	export MEMORY_ADDR=`echo "${QUINCE_PHRAM_ADDR}" | sed 's/^0x//'`

	sed -e "s/@@QUINCE_PHRAM_ADDR@@/${QUINCE_PHRAM_ADDR}/" \
        -e "s/@@QUINCE_PHRAM_SIZE@@/${QUINCE_PHRAM_SIZE}/" \
        -e "s/@@MEMORY_ADDR@@/${MEMORY_ADDR}/" \
        "${WORKDIR}/reserved-memory-phram-arm64.dtsi" >> "$1"
}

do_configure:prepend() {
	CONFIG_FILE=`cat ${WORKDIR}/defconfig | grep use-kernel-config | cut -d= -f2`

	echo "Customize ${S}/arch/${ARCH}/configs/${CONFIG_FILE}"
	enable_mtd_phram ${S}/arch/${ARCH}/configs/${CONFIG_FILE}
	enable_gpio_sysfs ${S}/arch/${ARCH}/configs/${CONFIG_FILE}

	for dtb in ${KERNEL_DEVICETREE}; do
		DTS=`echo "${dtb}" | sed 's/dtb$/dts/'`
		echo "Revert ${S}/arch/${ARCH}/boot/dts/${DTS}"
		git --git-dir=${S}/.git --work-tree=${S} checkout arch/${ARCH}/boot/dts/${DTS}
		if [ "${QUINCE_PHRAM}" != "0" ]; then
			echo "Customize ${S}/arch/${ARCH}/boot/dts/${DTS}"
			if [ "${QUINCE_BITS_OF_ADDRESS_SPACE}" == "64" ]; then
				allocate_phram_area_64bit ${S}/arch/${ARCH}/boot/dts/${DTS}
			else
				allocate_phram_area_32bit ${S}/arch/${ARCH}/boot/dts/${DTS}
			fi
		fi
	done
}

KERNEL_MODULE_AUTOLOAD += "${KERNEL_MODULES}"

