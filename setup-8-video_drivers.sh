#!/bin/bash

read -rp "do you still have Internet Connection ? [y/N] " a; [[ $a == [yY] ]] || exit 1

sudo sed -i '/^#\[multilib\]/,+1 s/^#//' /etc/pacman.conf
sudo pacman -Syu

sudo pacman -S --needed $(cat      \
  resources/package_list/9__amd    \
  resources/package_list/9__intel  \
  resources/package_list/9__nvidia \
)
