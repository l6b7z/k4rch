#!/bin/bash

source src/setup-5-postreboot.sh

source src/setup-6-root-dir-files.sh

source src/setup-7-aur-package_manger.sh

source src/setup-8-video_drivers.sh

./src/delay_step 6 "PC will reboot in 6 seconds"
reboot
