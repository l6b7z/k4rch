#!/bin/bash

source setup-5-postreboot.sh

source setup-6-root-dir-files.sh

source setup-7-aur-package_manger.sh

source setup-8-video_drivers.sh

./delay_step 6 "PC will reboot in 6 seconds"
reboot
