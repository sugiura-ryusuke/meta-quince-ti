FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"

SRC_URI:append = " \
    file://interfaces \
    file://interfaces_lo \
    file://interfaces_lo_eth0 \
    file://interfaces_lo_eth0_eth1 \
    file://pre-networking.sh \
"

do_install:append() {
	if ${@bb.utils.contains('QUINCE_DISABLE_LAN_STARTUP', '0', 'true', 'false', d)}; then
		install -m 0644 ${WORKDIR}/interfaces_lo ${D}${sysconfdir}/network/interfaces
	elif ${@bb.utils.contains('MACHINE', 'am335x-evm', 'true', 'false', d)}; then
		install -m 0644 ${WORKDIR}/interfaces_lo_eth0 ${D}${sysconfdir}/network/interfaces
	else
		install -m 0644 ${WORKDIR}/interfaces_lo_eth0 ${D}${sysconfdir}/network/interfaces
	fi

	if [ "${QUINCE_ETH0_ADDRESS}" != "" ]; then
		QUINCE_ETH0_SETTING="iface eth0 inet static\naddress ${QUINCE_ETH0_ADDRESS}"

		if [ "${QUINCE_ETH0_NETMASK}" != "" ]; then
			QUINCE_ETH0_SETTING="${QUINCE_ETH0_SETTING}\nnetmask ${QUINCE_ETH0_NETMASK}"
		fi

		if [ "${QUINCE_ETH0_GATEWAY}" != "" ]; then
			QUINCE_ETH0_SETTING="${QUINCE_ETH0_SETTING}\ngateway ${QUINCE_ETH0_GATEWAY}"
		fi

		sed -i -e "s|iface eth0 inet dhcp|${QUINCE_ETH0_SETTING}|" ${D}${sysconfdir}/network/interfaces
	fi

	if ${@bb.utils.contains('VIRTUAL-RUNTIME_init_manager', 'busybox', 'true', 'false', d)}; then
		install -d ${D}${sysconfdir}/init.d
		install -d ${D}${sysconfdir}/rcS.d
		install -m 0755 ${WORKDIR}/pre-networking.sh ${D}${sysconfdir}/init.d/pre-networking.sh
		ln -s ../init.d/pre-networking.sh ${D}${sysconfdir}/rcS.d/S30pre-networking
		ln -s ../init.d/networking ${D}${sysconfdir}/rcS.d/S31networking
	fi
}

