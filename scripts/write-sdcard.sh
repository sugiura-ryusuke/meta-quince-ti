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


# Confirm boot/rootfs directories
if [ ! -d boot ]; then
	echo "Not found boot directory."
	exit 1
fi
if [ ! -d rootfs ]; then
	echo "Not found rootfs directory."
	exit 1
fi


echo "Create SD card for booting Quince system. (/dev/${SD_DRIVE})"
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


sudo dd if=/dev/zero of=/dev/${SD_DRIVE} bs=1024 count=1024

echo "making 2 partitions..."
cat << EOM | sudo fdisk /dev/${SD_DRIVE}
o
n
p
1

+64M
n
p
2


t
1
c
a
1
w
EOM

echo "Format boot partition..."
sudo mkfs.vfat -F 32 -n "boot" /dev/${SD_DRIVE}1
echo "Format rootfs partition..."
sudo mkfs.ext4 -L "rootfs" /dev/${SD_DRIVE}2


echo "Mount SD card..."
sudo mkdir -p ${MNT_BOOT}
sudo mkdir -p ${MNT_ROOTFS}
sudo mount /dev/${SD_DRIVE}1 ${MNT_BOOT}
sudo mount /dev/${SD_DRIVE}2 ${MNT_ROOTFS}

echo "Copy files to boot partition..."
sudo cp -RT boot ${MNT_BOOT}
echo "Copy files to rootfs partition..."
sudo cp -RT rootfs ${MNT_ROOTFS}
echo "Syncing..."
sync
sync
sync

echo "Unmount SD card..."
sudo umount ${MNT_BOOT}
sudo umount ${MNT_ROOTFS}
sudo rm -rf ${MNT_BOOT}
sudo rm -rf ${MNT_ROOTFS}


echo "Done."

