#!/bin/bash

source /k4rch/config


sed '0,/#Color/{s/#Color/Color/}' -i /etc/pacman.conf
sed '0,/#ParallelDownloads = 5/{s/#ParallelDownloads = 5/ParallelDownloads = 8/}' -i /etc/pacman.conf

ln -sf /usr/share/zoneinfo/Europe/Warsaw /etc/localtime

hwclock --systohc

echo -e "${LOCALE}" >> /etc/locale.gen

locale-gen

echo "LANG=${LOCALE_MAIN}" >> /etc/locale.conf
echo "LC_COLLATE=C"       >> /etc/locale.conf
echo "KEYMAP=${KEYMAP}"  >  /etc/vconsole.conf

./k4rch/delay_step 2 "root & user"

passwd <<EOF
$[PASSWORD]
$[PASSWORD]

EOF

useradd -G wheel -m $USERNAME

passwd $USERNAME <<EOF
$[PASSWORD]
$[PASSWORD]

EOF

mv /k4rch /home/$USERNAME

sed '0,/# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/{s/# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/}' -i /etc/sudoers

echo "$HOSTNAME" > /etc/hostname

echo "127.0.0.1    localhost
::1          localhost
127.0.1.1    ${HOSTNAME}.localdomain ${HOSTNAME}" > /etc/hosts

clear

echo "[user & sudo]"
tree -L 2 /home
cat /etc/sudoers | grep %wheel

sleep 1

# possible fixes for specific motherboards
# sed '0,/#GRUB_DISABLE_OS_PROBER=false/{s/#GRUB_DISABLE_OS_PROBER=false/GRUB_DISABLE_OS_PROBER=false/}' -i /etc/default/grub
# sed '0,/LINUX_DEFAULT="/{s/LINUX_DEFAULT="/LINUX_DEFAULT="nomodeset /}' -i /etc/default/grub

lsblk | grep boot/efi

./home/$USERNAME/k4rch/delay_step 2 "installing bootloader"

grub-install --removable --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=grub
grub-mkconfig -o /boot/grub/grub.cfg


cat ./home/$USERNAME/k4rch/resources/tux

sleep 1

./home/$USERNAME/k4rch/delay_step 1 "Leaving Chroot"

exit 1
