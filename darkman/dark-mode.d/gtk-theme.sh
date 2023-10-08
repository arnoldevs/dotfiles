#!/usr/bin/env bash

gsettings set org.gnome.desktop.interface gtk-theme 'Colloid-Dark-Gruvbox'
gsettings set org.gnome.desktop.wm.preferences theme 'Colloid-Dark-Gruvbox'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
gsettings set org.gnome.desktop.interface cursor-theme 'Colloid-dark-cursors'

gsettings set org.gnome.desktop.interface document-font-name "JetBrainsMono Nerd Font Regular 11"
gsettings set org.gnome.desktop.interface font-name "JetBrainsMono Nerd Font Regular 11"
gsettings set org.gnome.desktop.interface monospace-font-name "JetBrainsMono Nerd Font Regular 10"

mkdir -p ~/.config/gtk-3.0
mkdir -p ~/.config/gtk-4.0

cat <<'EOF' > ~/.gtkrc-2.0
[Settings]
gtk-theme-name="Colloid-Dark-Gruvbox"
gtk-icon-theme-name="Papirus-Dark"
gtk-cursor-theme-name="Colloid-dark-cursors"
gtk-font-name="JetBrainsMono Nerd Font 11"
gtk-button-images=0
gtk-menu-images=0
EOF

cat <<'EOF' > ~/.config/gtk-3.0/settings.ini
[Settings]
gtk-theme-name=Colloid-Dark-Gruvbox
gtk-icon-theme-name=Papirus-Dark
gtk-cursor-theme-name=Colloid-dark-cursors
gtk-font-name=JetBrainsMono Nerd Font 11
gtk-application-prefer-dark-theme=1
EOF

ln -sf ~/.themes/Colloid-Dark-Gruvbox/gtk-4.0/* ~/.config/gtk-4.0/

dconf write /org/gnome/shell/extensions/user-theme/name "'Colloid-Dark-Gruvbox'"
