#!/usr/bin/env bash

cat <<'EOF' > ~/.bashrc.d/colors.sh
alias btm="btm --color gruvbox"

export FZF_DEFAULT_OPTS='--color fg:#ebdbb2,bg:#282828,hl:#fabd2f,fg+:#ebdbb2,bg+:#504945,hl+:#fabd2f --color info:#83a598,prompt:#bdae93,spinner:#fabd2f,pointer:#83a598,marker:#fe8019,header:#665c54'
EOF

[[ ! -x ~/.bashrc.d/colors.sh ]] && chmod +x ~/.bashrc.d/colors.sh

source ~/.bashrc
