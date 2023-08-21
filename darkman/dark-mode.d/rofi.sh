#!/usr/bin/env bash

cat <<'EOF' > ~/.config/rofi/config.rasi
@theme "/usr/share/rofi/themes/Arc-Dark.rasi"

configuration {
  icon-theme: "Papirus-Dark";
}

window {
    border-radius:  10;
    padding: 10px;
}
EOF
