#!bin/bash

#-----YAY-----#
echo "Installing YAY" && sleep 3
sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -si


#-----Packages-----#
echo "Installing Packges" && sleep 3

yay -S --noconfirm -- needed \
hyprland \
hyprpaper \
hyprpicker \
hypridle \
hyprlock \
hyprshot \
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
qemu-full \
libvirt \
virt-install \
virt-manager \
virt-viewer \
edk2-ovmf \
dnsmasq \
bridge-utils \
bluez \
bluez-utils \
pulseaudio-bluetooth \
blueman \
nct6687d-dkms-git \
base-devel \

#-----Clone Dotfiles-----#
sleep 3 && echo "Cloning Dotfiles"
sleep 3
mkdir /home/$USER/Documents/dotfiles
git clone git@github.com:Riezz0/mydots.git /home/$USER/Documents/dotfiles
cd /home/$USER/Documents/dotfiles

#-----Sym Links-----#
sleep 3 && echo "Symlinking Dotfiles"
sleep 3
rm -rf /home/$USER/.config/hypr 
ln -s /home/$USER/Documents/dotfiles/hypr /home/$USER/.config
rm -rf /home/$USER/.config/kitty
ln -s /home/$USER/Documents/dotfiles/kitty /home/$USER/.config
ln -s /home/$USER/Documents/dotfiles/scripts /home/$USER/.config
ln -s /home/$USER/Documents/dotfiles/walls /home/$USER/.config
ln -s /home/$USER/Documents/dotfiles/.vim /home/$USER/
ln -s /home/$USER/Documents/dotfiles/.vimrc /home/$USER/
ln -s /home/$USER/Documents/dotfiles/.themes /home/$USER/
ln -s /home/$USER/Documents/dotfiles/.icons /home/$USER/
ln -s /home/$USER/Documents/dotfiles/gtk-3.0 /home/$USER/.config
ln -s /home/$USER/Documents/dotfiles/gtk-4.0 /home/$USER/.config
ln -s /home/$USER/Documents/dotfiles/oomox-qtstyleplugin /home/$USER/.config
ln -s /home/$USER/Documents/dotfiles/qt5ct /home/$USER/.config
ln -s /home/$USER/Documents/dotfiles/btop /home/$USER/.config
ln -s /home/$USER/Documents/dotfiles/qt6ct /home/$USER/.config
ln -s /home/$USER/Documents/dotfiles/waybar /home/$USER/.config
ln -s /home/$USER/Documents/dotfiles/rofi /home/$USER/.config
sudo ln -s /home/$USER/mydots/cursors/Future-dark-cursors /usr/share/icons/
sudo rm -rf /usr/share/icons/default
sudo ln -s /home/$USER/mydots/cursors/default /usr/share/icons/

gsettings set org.gnome.desktop.interface cursor-theme Future-dark-cursors
gsettings set org.gnome.desktop.interface gtk-theme oomox-riezzo-red
gsettings set org.gnome.desktop.interface icon-theme oomox-riezzo-red


#-----Enable Ly-----#
sudo systemctl enable ly
sudo systemctl start ly
