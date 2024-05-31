#!/usr/bin/env bash

mkdir -p ~/.config/rofi

cat <<'EOF' >~/.config/rofi/config.rasi
@theme "/usr/share/rofi/themes/gruvbox-dark.rasi"

configuration {
  icon-theme: "Papirus-Dark";
}

window {
    border-radius:  10;
    padding: 10px;
}
EOF
