#!/bin/bash

# __INSTALLATION__

echo "Dependencies:"
echo "arch-install-scritps"
echo "dosfstools"
echo "nvim"

sleep 2

nvim src/config
nvim resources/config/zsh/env-vars

clear

./src/delay_step 3 "installation"

source src/setup-1-drive-layout.sh

if [[ ! -f src/stop_install ]]; then
  source src/setup-2-pacstrap-minimal.sh
else
  echo "Installation Failed at Step $(cat src/stop_install)" ; exit
fi

if [[ ! -f src/stop_install ]]; then
  source src/setup-3-post-pacstrap.sh
  # src/setup-4-inside-chroot.sh <- run from setup-3
else
  echo "Installation Failed at Step $(cat src/stop_install)" ; exit
fi

if [[ ! -f src/stop_install ]]; then
  ./src/delay_step 6 "PC will reboot in 6 seconds"
  reboot
else
  echo "Installation Failed at Step $(cat src/stop_install)" ; exit
fi

rm src/stop_install
