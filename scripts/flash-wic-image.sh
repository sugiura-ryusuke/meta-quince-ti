#!/bin/sh


# Confirm Linux environment
if [ `uname -s` != "Linux" ]; then
	echo "This script must be executed in Linux."
	exit 1
fi


ROOT_DRIVE_NAME=`mount | grep 'on / type' | awk '{print $1}' | sed -e 's|[0-9]*$||' | sed -e 's|\([a-z/]*[0-9]*\).*|\1|' | sed -e 's|^/dev/||'`
SD_DRIVE=`cat /proc/partitions | grep '[0-9]' | grep -v ${ROOT_DRIVE_NAME} | awk '{print $4}' | grep '[a-zA-Z]$' | grep -m1 '^sd.'`
SCRIPT_DIR=$(dirname `readlink -f "$0"`)
MNT_BOOT=mnt_boot
MNT_ROOTFS=mnt_rootfs


# Confirm SD card
if [ "${SD_DRIVE}" = "" ]; then
	echo "Cannot find SD card."
	exit 1
fi


cd ${SCRIPT_DIR}


# Confirm .wic.xz/.wic.bmap files
if [ ! -e *.wic.xz ]; then
	echo "Not found .wic.xz file."
	exit 1
fi
if [ ! -e *.wic.bmap ]; then
	echo "Not found .wic.bmap file."
	exit 1
fi


echo "Flash a Wic image onto the SD card. (/dev/${SD_DRIVE})"
sudo fdisk -l /dev/${SD_DRIVE} | grep "Disk "

USER_CHOICE_CORRECT=0
while [ ${USER_CHOICE_CORRECT} -ne 1 ]
do
	read -p "Would you like to format /dev/${SD_DRIVE} ? [y/n] : " USER_CHOICE
	USER_CHOICE_CORRECT=1
	case ${USER_CHOICE} in
	"y") ;;
	"n") exit 0;;
	*)  echo "Please enter y or n";USER_CHOICE_CORRECT=0;;
	esac
done


echo "Write to SD card..."
WIC_FILE=`find *.wic.xz`
sudo bmaptool copy ${WIC_FILE} /dev/${SD_DRIVE}
sync
sync
sync


echo "Done."

