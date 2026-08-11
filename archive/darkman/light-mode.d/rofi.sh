#!/usr/bin/env bash

mkdir -p ~/.config/rofi

cat <<'EOF' >~/.config/rofi/config.rasi
@theme "/usr/share/rofi/themes/gruvbox-light.rasi"

configuration {
  icon-theme: "Papirus-Light";
}

window {
    border-radius:  10;
    padding: 10px;
}
EOF
