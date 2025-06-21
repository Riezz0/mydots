#!/bin/bash

#-----YAY-----#
if ! command -v yay &> /dev/null; then
    echo "Installing yay..."
    sudo pacman -S --needed git base-devel --noconfirm
    git clone https://aur.archlinux.org/yay.git
    cd yay && makepkg -si --noconfirm && cd ..
    rm -rf yay
    echo "yay installed successfully!"
fi

#-----Dependencies-----#
echo "Installing Dependencies"
yay -S --noconfirm --needed \
hyprland \
hyprpaper \
hyprpicker \
hypridle \
hyprlock \
hyprshot \
xdg-desktop-portal-hyprland \
wl-clipboard \
waybar \
cmatrix \
rofi-wayland \
git \
gnuplot \
pamixer \
nemo \
firefox \
xfce-polkit \
nwg-look \
python-pywal16 \
python-pywalfox \
otf-hermit-nerd \
coolercontrol \
ly \
ttf-font-awesome \
ttf-font-awesome-4 \
ttf-font-awesome-5 \
fastfetch \
pavucontrol \
python-gobject \
gtk3 \
xfce4-settings \
arch-gaming-meta \
dvkx-bin \
python-virtualenv \
python-pip \
echo "Hyprland installed with essential dependencies"

#-----Clone Dotfiles-----#
echo "Cloning Dotfiles"
sleep 3
mkdir /home/$USER/.dotfiles
git clone git@github.com:Riezz0/mydots.git /home/$USER/.dotfiles
cd /home/$USER/.dotfiles


#-----Remove Existing Folders
echo "Cleaning old configs..."
rm -rf /home/$USER/.config/{hypr,kitty,waybar,scripts,walls,gtk-3.0,gtk-4.0,oomox-qtstyleplugin,qt5ct,qt6ct,rofi,btop}
rm -f /home/$USER/{.vim,.vimrc,.themes,.icons}
sudo rm -rf /usr/share/icons/default

#-----Sym Links-----#
# Home directory symlinks
ln -sf /home/$USER/.dotfiles/.vim /home/$USER/
ln -sf /home/$USER/.dotfiles/.vimrc /home/$USER/
ln -sf /home/$USER/.dotfiles/.themes /home/$USER/
ln -sf /home/$USER/.dotfiles/.icons /home/$USER/

# .config symlinks
mkdir -p /home/$USER/.config
ln -sf /home/$USER/.dotfiles/hypr /home/$USER/.config/
ln -sf /home/$USER/.dotfiles/kitty /home/$USER/.config/
ln -sf /home/$USER/.dotfiles/waybar /home/$USER/.config/
ln -sf /home/$USER/.dotfiles/scripts /home/$USER/.config/
ln -sf /home/$USER/.dotfiles/walls /home/$USER/.config/
ln -sf /home/$USER/.dotfiles/gtk-3.0 /home/$USER/.config/
ln -sf /home/$USER/.dotfiles/gtk-4.0 /home/$USER/.config/
ln -sf /home/$USER/.dotfiles/oomox-qtstyleplugin /home/$USER/.config/
ln -sf /home/$USER/.dotfiles/qt5ct /home/$USER/.config/
ln -sf /home/$USER/.dotfiles/qt6ct /home/$USER/.config/
ln -sf /home/$USER/.dotfiles/rofi /home/$USER/.config/
ln -sf /home/$USER/.dotfiles/btop /home/$USER/.config/

# System-wide cursor symlinks
sudo mkdir -p /usr/share/icons
sudo ln -sf /home/$USER/.dotfiles/cursors/Future-dark-cursors /usr/share/icons/
sudo ln -sf /home/$USER/.dotfiles/cursors/default /usr/share/icons/

#-----Set permissions-----#
echo "Setting permissions..."
chmod -R 755 /home/$USER/.dotfiles
find /home/$USER/.dotfiles -type f -exec chmod 644 {} \;

#-----Apply Theme-----#
echo "Applying Theme"
sleep 3 
gsettings set org.gnome.desktop.interface cursor-theme Future-dark-cursors
gsettings set org.gnome.desktop.interface gtk-theme oomox-riezzo-red
gsettings set org.gnome.desktop.interface icon-theme oomox-riezzo-red


#-----Enable Ly-----#
echo "Enabling Ly"
sleep 3 
sudo systemctl enable ly
sudo systemctl start ly
