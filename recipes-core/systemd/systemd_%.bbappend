FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"

SRC_URI:append = " \
    file://10-eth.network \
    file://15-eth.network \
"

do_install:append() {
    install -d ${D}${sysconfdir}/systemd/network/

	if ${@bb.utils.contains('QUINCE_DISABLE_LAN_STARTUP', '1', 'true', 'false', d)}; then
		;
	elif ${@bb.utils.contains('MACHINE', 'am335x-evm', 'true', 'false', d)}; then
		install -m 0644 ${WORKDIR}/10-eth.network ${D}${sysconfdir}/systemd/network/10-eth.network
	else
		install -m 0644 ${WORKDIR}/10-eth.network ${D}${sysconfdir}/systemd/network/10-eth.network
	fi

	if [ "${QUINCE_ETH0_ADDRESS}" != "" ]; then
		if [ "${QUINCE_ETH0_NETMASK}" == "255.255.255.255" ]; then
			QUINCE_ETH0_SETTING="Address=${QUINCE_ETH0_ADDRESS}/32"
		elif [ "${QUINCE_ETH0_NETMASK}" == "255.255.255.254" ]; then
			QUINCE_ETH0_SETTING="Address=${QUINCE_ETH0_ADDRESS}/31"
		elif [ "${QUINCE_ETH0_NETMASK}" == "255.255.255.252" ]; then
			QUINCE_ETH0_SETTING="Address=${QUINCE_ETH0_ADDRESS}/30"
		elif [ "${QUINCE_ETH0_NETMASK}" == "255.255.255.248" ]; then
			QUINCE_ETH0_SETTING="Address=${QUINCE_ETH0_ADDRESS}/29"
		elif [ "${QUINCE_ETH0_NETMASK}" == "255.255.255.240" ]; then
			QUINCE_ETH0_SETTING="Address=${QUINCE_ETH0_ADDRESS}/28"
		elif [ "${QUINCE_ETH0_NETMASK}" == "255.255.255.224" ]; then
			QUINCE_ETH0_SETTING="Address=${QUINCE_ETH0_ADDRESS}/27"
		elif [ "${QUINCE_ETH0_NETMASK}" == "255.255.255.192" ]; then
			QUINCE_ETH0_SETTING="Address=${QUINCE_ETH0_ADDRESS}/26"
		elif [ "${QUINCE_ETH0_NETMASK}" == "255.255.255.128" ]; then
			QUINCE_ETH0_SETTING="Address=${QUINCE_ETH0_ADDRESS}/25"
		elif [ "${QUINCE_ETH0_NETMASK}" == "255.255.255.0" ]; then
			QUINCE_ETH0_SETTING="Address=${QUINCE_ETH0_ADDRESS}/24"
		elif [ "${QUINCE_ETH0_NETMASK}" == "255.255.254.0" ]; then
			QUINCE_ETH0_SETTING="Address=${QUINCE_ETH0_ADDRESS}/23"
		elif [ "${QUINCE_ETH0_NETMASK}" == "255.255.252.0" ]; then
			QUINCE_ETH0_SETTING="Address=${QUINCE_ETH0_ADDRESS}/22"
		elif [ "${QUINCE_ETH0_NETMASK}" == "255.255.248.0" ]; then
			QUINCE_ETH0_SETTING="Address=${QUINCE_ETH0_ADDRESS}/21"
		elif [ "${QUINCE_ETH0_NETMASK}" == "255.255.240.0" ]; then
			QUINCE_ETH0_SETTING="Address=${QUINCE_ETH0_ADDRESS}/20"
		elif [ "${QUINCE_ETH0_NETMASK}" == "255.255.224.0" ]; then
			QUINCE_ETH0_SETTING="Address=${QUINCE_ETH0_ADDRESS}/19"
		elif [ "${QUINCE_ETH0_NETMASK}" == "255.255.192.0" ]; then
			QUINCE_ETH0_SETTING="Address=${QUINCE_ETH0_ADDRESS}/18"
		elif [ "${QUINCE_ETH0_NETMASK}" == "255.255.128.0" ]; then
			QUINCE_ETH0_SETTING="Address=${QUINCE_ETH0_ADDRESS}/17"
		elif [ "${QUINCE_ETH0_NETMASK}" == "255.255.0.0" ]; then
			QUINCE_ETH0_SETTING="Address=${QUINCE_ETH0_ADDRESS}/16"
		elif [ "${QUINCE_ETH0_NETMASK}" == "255.254.0.0" ]; then
			QUINCE_ETH0_SETTING="Address=${QUINCE_ETH0_ADDRESS}/15"
		elif [ "${QUINCE_ETH0_NETMASK}" == "255.252.0.0" ]; then
			QUINCE_ETH0_SETTING="Address=${QUINCE_ETH0_ADDRESS}/14"
		elif [ "${QUINCE_ETH0_NETMASK}" == "255.248.0.0" ]; then
			QUINCE_ETH0_SETTING="Address=${QUINCE_ETH0_ADDRESS}/13"
		elif [ "${QUINCE_ETH0_NETMASK}" == "255.240.0.0" ]; then
			QUINCE_ETH0_SETTING="Address=${QUINCE_ETH0_ADDRESS}/12"
		elif [ "${QUINCE_ETH0_NETMASK}" == "255.224.0.0" ]; then
			QUINCE_ETH0_SETTING="Address=${QUINCE_ETH0_ADDRESS}/11"
		elif [ "${QUINCE_ETH0_NETMASK}" == "255.192.0.0" ]; then
			QUINCE_ETH0_SETTING="Address=${QUINCE_ETH0_ADDRESS}/10"
		elif [ "${QUINCE_ETH0_NETMASK}" == "255.128.0.0" ]; then
			QUINCE_ETH0_SETTING="Address=${QUINCE_ETH0_ADDRESS}/9"
		elif [ "${QUINCE_ETH0_NETMASK}" == "255.0.0.0" ]; then
			QUINCE_ETH0_SETTING="Address=${QUINCE_ETH0_ADDRESS}/8"
		elif [ "${QUINCE_ETH0_NETMASK}" == "254.0.0.0" ]; then
			QUINCE_ETH0_SETTING="Address=${QUINCE_ETH0_ADDRESS}/7"
		elif [ "${QUINCE_ETH0_NETMASK}" == "252.0.0.0" ]; then
			QUINCE_ETH0_SETTING="Address=${QUINCE_ETH0_ADDRESS}/6"
		elif [ "${QUINCE_ETH0_NETMASK}" == "248.0.0.0" ]; then
			QUINCE_ETH0_SETTING="Address=${QUINCE_ETH0_ADDRESS}/5"
		elif [ "${QUINCE_ETH0_NETMASK}" == "240.0.0.0" ]; then
			QUINCE_ETH0_SETTING="Address=${QUINCE_ETH0_ADDRESS}/4"
		elif [ "${QUINCE_ETH0_NETMASK}" == "224.0.0.0" ]; then
			QUINCE_ETH0_SETTING="Address=${QUINCE_ETH0_ADDRESS}/3"
		elif [ "${QUINCE_ETH0_NETMASK}" == "192.0.0.0" ]; then
			QUINCE_ETH0_SETTING="Address=${QUINCE_ETH0_ADDRESS}/2"
		elif [ "${QUINCE_ETH0_NETMASK}" == "128.0.0.0" ]; then
			QUINCE_ETH0_SETTING="Address=${QUINCE_ETH0_ADDRESS}/1"
		elif [ "${QUINCE_ETH0_NETMASK}" == "0.0.0.0" ]; then
			QUINCE_ETH0_SETTING="Address=${QUINCE_ETH0_ADDRESS}/0"
		else
			QUINCE_ETH0_SETTING="Address=${QUINCE_ETH0_ADDRESS}/16"
		fi

		if [ "${QUINCE_ETH0_GATEWAY}" != "" ]; then
			QUINCE_ETH0_SETTING="${QUINCE_ETH0_SETTING}\n\n[Route]\nGateway=${QUINCE_ETH0_GATEWAY}"
		fi

		if [ -f "${D}${sysconfdir}/systemd/network/10-eth.network" ] ; then
			sed -i -e "s|DHCP=yes|DHCP=no\n${QUINCE_ETH0_SETTING}|" ${D}${sysconfdir}/systemd/network/10-eth.network
		fi
	fi
}

