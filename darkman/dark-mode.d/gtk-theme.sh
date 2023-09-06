#!/usr/bin/env bash

gsettings set org.gnome.desktop.interface gtk-theme 'Colloid-Dark-Gruvbox'
gsettings set org.gnome.desktop.wm.preferences theme 'Colloid-Dark-Gruvbox'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface cursor-theme 'Colloid-dark-cursors'

mkdir -p ~/.config/gtk-4.0

ln -sf ~/.themes/Colloid-Dark-Gruvbox/gtk-4.0/* ~/.config/gtk-4.0/

dconf write /org/gnome/shell/extensions/user-theme/name "'Colloid-Dark-Gruvbox'"
