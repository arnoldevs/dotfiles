#!/usr/bin/env bash

mkdir -p ~/.bashrc.d

cat <<'EOF' >~/.bashrc.d/fzf.sh
export FZF_DEFAULT_OPTS='--color fg:#ebdbb2,bg:#282828,hl:#fabd2f,fg+:#ebdbb2,bg+:#504945,hl+:#fabd2f --color info:#83a598,prompt:#bdae93,spinner:#fabd2f,pointer:#83a598,marker:#fe8019,header:#665c54'
EOF

[[ ! -x ~/.bashrc.d/fzf.sh ]] && chmod u+x ~/.bashrc.d/fzf.sh

source ~/.bashrc
