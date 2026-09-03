#!/bin/bash

source config

sync

printf '%s\n' "1" > stop_install

export dName=/dev/DRIVE_NAME

clear ; lsblk

echo -e "\n[select /dev/*DRIVE* you want to reintall linux on]"


#the only weakness of my scripts
read driveName

if [[ $driveName =~ "nvme" ]]; then
  dName="/dev/${driveName}p"
else
  dName=/dev/$driveName
fi

clear ; lsblk

echo -e "\n--------------------------------------\n"

lsblk | grep $driveName

echo ""


read -p "[!] Are you sure? -> /dev/${driveName} [!]" -n 1 -r -s

if [[ ! "$REPLY" =~ ^(y|Y|)$ ]]; then 
   touch stop_install 
   exit 1
fi

clear

wipefs -af /dev/$driveName*

./delay_step 3 "Wipping  ${driveName}  in 3 seconds"

sync

sleep 0.5

fdisk --wipe auto --wipe-partitions auto "/dev/$driveName" <<EOF
g
n
1

+$[BOOT_PARTITION_SIZE_MB]M

n
2


t
1
1
w

EOF

umount -Rl /mnt

./delay_step 2 "mounting"

mkfs.fat -F32 "${dName}1"

mkfs.ext4 "${dName}2"

mount "${dName}2" /mnt

mkdir -p /mnt/boot/efi

mount "${dName}1" /mnt/boot/efi

clear

echo -e "[Drives Mounted]\n"

lsblk

rm stop_install
