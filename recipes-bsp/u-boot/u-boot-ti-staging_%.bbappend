FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
    file://enable_legacy_image_format.cfg \
    file://boot.cmd.in \
"

DEPENDS += "u-boot-mkimage-native"

inherit deploy

do_compile:append() {
	sed -e "s/@@QUINCE_PHRAM_ADDR@@/${QUINCE_PHRAM_ADDR}/" \
        -e "s/@@QUINCE_PHRAM_SIZE@@/${QUINCE_PHRAM_SIZE}/" \
        -e "s/@@QUINCE_ROOTFS_IMG_FILE@@/${QUINCE_ROOTFS_IMG_FILE}/" \
        -e "s/@@QUINCE_OPT_IMG_FILE@@/${QUINCE_OPT_IMG_FILE}/" \
        "${WORKDIR}/boot.cmd.in" > "${WORKDIR}/boot.cmd"
	mkimage -A ${UBOOT_ARCH} -T script -C none -n "Boot script" -d "${WORKDIR}/boot.cmd" ${B}/boot.scr
}

do_deploy:append() {
	install -d ${DEPLOYDIR}
	install -m 0644 ${B}/boot.scr ${DEPLOYDIR}
}

