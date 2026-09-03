#!/bin/bash

source config

read -rp "do you have Internet Connection ? [y/N] " a; [[ $a == [yY] ]] || exit 1

git clone https://aur.archlinux.org/yay.git

sleep 0.5

cd yay && makepkg -sir --noconfirm PKGBUILD
cd ..
rm -Rvf yay

read -rp "Install yay packages ? [y/N] " a; [[ $a == [yY] ]] || exit 1

yay -S --noconfirm $(echo $YAY)
yay -S --noconfirm $(cat resources/package_list/8__yay)
