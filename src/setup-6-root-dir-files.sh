#!/bin/bash

source config

cp -rv resources/root-dir/\|local\|share\|applications ~/.local/share/applications
sudo cp -rv resources/root-dir/\|etc\|default\|grub /etc/default/grub
sudo cp -rv resources/root-dir/\|etc\|X11\|xorg.conf.d\|99-synaptics-overrides.conf /etc/X11/xorg.conf.d/99-synaptics-overrides.conf

cp resources/root-dir/skip-username_or_login/autologin.conf .

source  resources/root-dir/skip-username_or_login/skip-login_or_username

rm autologin.conf
