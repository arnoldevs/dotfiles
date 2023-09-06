#!/usr/bin/env bash

cat <<'EOF' > ~/.bashrc.d/colors.sh
alias btm="btm --color gruvbox-light"

export FZF_DEFAULT_OPTS='--color fg:#3c3836,bg:#fbf1c7,hl:#b57614,fg+:#3c3836,bg+:#d5c4a1,hl+:#b57614 --color info:#076678,prompt:#665c54,spinner:#b57614,pointer:#076678,marker:#af3a03,header:#bdae93'
EOF

[[ ! -x ~/.bashrc.d/colors.sh ]] && chmod +x ~/.bashrc.d/colors.sh

source ~/.bashrc
