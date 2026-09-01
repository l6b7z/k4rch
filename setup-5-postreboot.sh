#!/bin/bash

source config

sudo systemctl enable NetworkManager.service
sudo systemctl start NetworkManager.service

nmtui

sudo usermod -aG video $USER

sudo chown -R $USER $HOME/k4rch ; echo "chown ${USER} -> ${HOME}/k4rch"
sudo chgrp -R $USER $HOME/k4rch ; echo "chgrp ${USER} -> ${HOME}/k4rch"

sleep 1

clear

rm -vf ~/.bash*
rm -Rvf ~/.config

sleep 1

cp -r  ~/k4rch/resources/config ~/.config
cp -r  ~/k4rch/resources/icons ~/.icons
cp -r  ~/k4rch/resources/static ~/.static
cp -r  ~/k4rch/resources/themes ~/.themes
cp -r  ~/k4rch/resources/.zshenv ~/.zshenv

mkdir ~/main-dir    
mkdir ~/main-dir/media
mkdir ~/main-dir/downloads
 
ln -s ~/.config /home/l6b7/main-dir/.config
ln -s ~/.static /home/l6b7/main-dir/.static
ln -s ~/.local/share/Trash/files /home/l6b7/main-dir/.trash
ln -s /mnt /home/l6b7/main-dir/.mnt

sleep 1

sudo cp -v ~/.config/lf/lfrun /usr/bin/lfrun
sudo cp -v ~/.config/lf/lfroot /usr/bin/lfroot

sudo make -W  clean install -C /home/l6b7/.static/src/clipmenu -s
sudo make -W  clean install -C /home/l6b7/.static/src/dmenu -s
sudo make -W  clean install -C /home/l6b7/.static/src/dwm -s
sudo make -W  clean install -C /home/l6b7/.static/src/dwmblocks-async -s
sudo make -W  clean install -C /home/l6b7/.static/src/st -s

chsh -s $(which zsh)
