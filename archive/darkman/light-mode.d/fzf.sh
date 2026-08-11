#!/usr/bin/env bash

mkdir -p ~/.bashrc.d

cat <<'EOF' >~/.bashrc.d/fzf.sh
# export FZF_DEFAULT_OPTS='--color fg:#3c3836,bg:#fbf1c7,hl:#b57614,fg+:#3c3836,bg+:#d5c4a1,hl+:#b57614 --color info:#076678,prompt:#665c54,spinner:#b57614,pointer:#076678,marker:#af3a03,header:#bdae93'
EOF

[[ ! -x ~/.bashrc.d/fzf.sh ]] && chmod u+x ~/.bashrc.d/fzf.sh

source ~/.bashrc
