#!/usr/bin/env bash

mkdir -p ~/.config/lsd

cat <<'EOF' >~/.config/lsd/config.yaml
color:
  when: always
EOF
