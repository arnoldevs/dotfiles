#!/usr/bin/env bash

gsettings set org.gnome.desktop.interface gtk-theme 'Colloid-Light-Gruvbox'
gsettings set org.gnome.desktop.wm.preferences theme 'Colloid-Light-Gruvbox'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Light'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
gsettings set org.gnome.desktop.interface cursor-theme 'Colloid-cursors'

mkdir -p ~/.config/gtk-4.0

ln -sf ~/.themes/Colloid-Light-Gruvbox/gtk-4.0/* ~/.config/gtk-4.0/

dconf write /org/gnome/shell/extensions/user-theme/name "'Colloid-Light-Gruvbox'"
