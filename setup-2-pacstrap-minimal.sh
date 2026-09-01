#!/bin/bash

printf '%s\n' "2" > stop_install

source config

pacstrap -K /mnt $(cat \
  resources/package_list/1__minimal_arch     \
  resources/package_list/2__xorg             \
  resources/package_list/3__audio            \
  resources/package_list/4__fonts            \
  resources/package_list/5__personal         \
  resources/package_list/6__lf_file_manager  \
)                                            \
$PACMAN


rm stop_install
