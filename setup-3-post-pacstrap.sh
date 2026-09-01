#!/bin/bash

printf '%s\n' "3" > stop_install

lsblk

./delay_step 3 "fstab"

genfstab -U /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab

if [ -f "$(pwd)/setup-3-post-pacstrap.sh" ]; then
  cp -r $(pwd) /mnt/k4rch
else
  echo "run this script from the proper directory"
  exit 
fi

lsblk

./delay_step 2 "Changing Root"

arch-chroot /mnt /bin/bash <<END
./k4rch/setup-4-inside-chroot.sh
END

clear

lsblk

umount -Rl /mnt

sync

./delay_step 2 "Unmounting drives"

rm stop_install
