#!/usr/bin/env bash

mkdir -p ~/.bashrc.d

cat <<'EOF' >~/.bashrc.d/btm.sh
alias btm='btm --color gruvbox'
EOF

[[ ! -x ~/.bashrc.d/btm.sh ]] && chmod u+x ~/.bashrc.d/btm.sh

source ~/.bashrc
