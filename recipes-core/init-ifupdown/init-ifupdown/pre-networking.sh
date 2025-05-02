#!/bin/sh

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

IFACES=`grep "^auto" /etc/network/interfaces | cut -d ' ' -f 2`

for if in ${IFACES}; do
	for k in `seq 1 50`; do
		if [ -d /sys/class/net/${if} ]; then
			printf "Detected iface ${if}.\n"
			break;
		fi
		if [ ${k} -eq 1 ]; then
			printf "Waiting for iface ${if}...\n"
		fi
		if [ ${k} -eq 50 ]; then
			printf "Cannot find iface ${if}.\n"
		fi
		usleep 200000
	done
done

