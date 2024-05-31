#!/usr/bin/env bash

gsettings set org.gnome.desktop.interface gtk-theme 'Colloid-Light-Gruvbox'
gsettings set org.gnome.desktop.wm.preferences theme 'Colloid-Light-Gruvbox'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Light'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
gsettings set org.gnome.desktop.interface cursor-theme 'Colloid-cursors'

gsettings set org.gnome.desktop.interface document-font-name "JetBrainsMono Nerd Font Regular 11"
gsettings set org.gnome.desktop.interface font-name "JetBrainsMono Nerd Font Regular 11"
gsettings set org.gnome.desktop.interface monospace-font-name "JetBrainsMono Nerd Font Regular 11"

gsettings set org.gnome.desktop.background picture-uri "file://$HOME/Pictures/Wallpapers/cornered-stairs-day.svg"

mkdir -p ~/.config/gtk-3.0
mkdir -p ~/.config/gtk-4.0

cat <<'EOF' >~/.gtkrc-2.0
[Settings]
gtk-theme-name="Colloid-Light-Gruvbox"
gtk-icon-theme-name="Papirus-Light"
gtk-cursor-theme-name="Colloid-cursors"
gtk-font-name="JetBrainsMono Nerd Font 11"
gtk-button-images=0
gtk-menu-images=0
EOF

cat <<'EOF' >~/.config/gtk-3.0/settings.ini
[Settings]
gtk-theme-name=Colloid-Light-Gruvbox
gtk-icon-theme-name=Papirus-Light
gtk-cursor-theme-name=Colloid-cursors
gtk-font-name=JetBrainsMono Nerd Font 11
gtk-application-prefer-dark-theme=0
EOF

ln -sf ~/.themes/Colloid-Light-Gruvbox/gtk-4.0/* ~/.config/gtk-4.0/

dconf write /org/gnome/shell/extensions/user-theme/name "'Colloid-Light-Gruvbox'"
