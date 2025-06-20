#!/bin/bash

wal -i ~/.config/walls/wall.jpg --cols16
cp -r /home/$USER/.cache/wal/colors-waybar.css /home/$USER/.config/waybar/colors.css
pywalfox update
