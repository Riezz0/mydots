#!/bin/bash

rm -rf /home/$USER/.config/kitty
rm -rf /home/$USER/.config/hypr 

ln -s /home/$USER/mydots/hypr /home/$USER/.config
ln -s /home/$USER/mydots/kitty /home/$USER/.config
ln -s /home/$USER/mydots/scripts /home/$USER/.config
ln -s /home/$USER/mydots/walls /home/$USER/.config
ln -s /home/$USER/mydots/.oh-my-zsh /home/$USER/
ln -s /home/$USER/mydots/.zshrc /home/$USER/
ln -s /home/$USER/mydots/.vim /home/$USER/
ln -s /home/$USER/mydots/.vimrc /home/$USER/
ln -s /home/$USER/mydots/.themes /home/$USER/
ln -s /home/$USER/mydots/.icons /home/$USER/
ln -s /home/$USER/mydots/gtk-3.0 /home/$USER/.config
ln -s /home/$USER/mydots/gtk-4.0 /home/$USER/.config
ln -s /home/$USER/mydots/oomox-qtstyleplugin /home/$USER/.config
ln -s /home/$USER/mydots/qt5ct /home/$USER/.config
ln -s /home/$USER/mydots/btop /home/$USER/.config
ln -s /home/$USER/mydots/qt6ct /home/$USER/.config
ln -s /home/$USER/mydots/waybar /home/$USER/.config
ln -s /home/$USER/mydots/rofi /home/$USER/.config

sudo ln -s /home/$USER/mydots/cursors/Future-dark-cursors /usr/share/icons/
sudo rm -rf /usr/share/icons/default
sudo ln -s /home/$USER/mydots/cursors/default /usr/share/icons/
