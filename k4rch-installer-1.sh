#!/bin/bash

# __INSTALLATION__

echo "Dependencies:"
echo "arch-install-scritps"
echo "dosfstools"
echo "nvim"

sleep 2

nvim config
nvim resources/config/zsh/env-vars

clear

./delay_step 3 "installation"

source setup-1-drive-layout.sh

if [[ ! -f stop_install ]]; then
  source setup-2-pacstrap-minimal.sh
else
  echo "Installation Failed at Step $(cat stop_install)" ; exit
fi

if [[ ! -f stop_install ]]; then
  source setup-3-post-pacstrap.sh
  #setup-4-inside-chroot.sh <- run from setup-3
else
  echo "Installation Failed at Step $(cat stop_install)" ; exit
fi

if [[ ! -f stop_install ]]; then
  ./delay_step 6 "PC will reboot in 6 seconds"
  reboot
else
  echo "Installation Failed at Step $(cat stop_install)" ; exit
fi

rm stop_install
