#!/usr/bin/env bash

cat <<'EOF' > ~/.config/rofi/config.rasi
@theme "/usr/share/rofi/themes/Arc.rasi"

configuration {
  icon-theme: "Papirus-Light";
}

window {
    border-radius:  10;
    padding: 10px;
}
EOF
