#!/usr/bin/env bash

# Sway and VSCode don't get along very well at the moment and it doesn't detect the automatic switching of day/night mode

# Normal Mode
sed -i 's/Gruvbox Dark Medium/Gruvbox Light Medium/' ~/.config/Code/User/settings.json

# High Contrast Mode
sed -i 's/Gruvbox Dark Hard/Gruvbox Light Hard/' ~/.config/Code/User/settings.json

# Automatic day/night mode switching for Neovim without complicated settings
sed -i 's/theme = .*/theme = "gruvbox_light",/' ~/.config/nvim/lua/custom/chadrc.lua

sed -i 's/theme_toggle = .*/theme_toggle = { "gruvbox_light", "gruvbox" },/' ~/.config/nvim/lua/custom/chadrc.lua
