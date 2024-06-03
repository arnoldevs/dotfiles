#!/usr/bin/env bash

updates() {
  . $HOME/.dotfiles/bashrc.d/update.sh
  declare -a updates=(minegrub_u nerdfonts_u lazygit_u system_u flatpak_u colloid_u neovim_u starship_u node_u rust_u preexec_u python_u darkman_u)
  declare -a options=("$@")
  IFS=" " read -r -a options <<<"$@"

  info() {
    echo -e "Usage: updates [options]\n\nList of main commands:\n"
    for i in "${updates[@]}"; do
      echo "$i" | cut -d '_' -f 1
    done
    echo -e "\n all: Release all updates"
    echo " - h: Displays this help message"
  }

  if [[ ${#options[@]} -gt 0 ]]; then
    for o in "${options[@]}"; do
      case "$o" in
      all)
        echo "Running all updates..."
        for i in "${updates[@]}"; do
          echo "  - Executing: $i" | cut -d '_' -f 1
          $i
        done
        ;;
      minegrub)
        minegrub_u
        ;;
      flatpak)
        flatpak_u
        ;;
      neovim)
        neovim_u
        ;;
      node)
        node_u
        ;;
      rust)
        rust_u
        ;;
      nerdfonts)
        nerdfonts_u
        ;;
      system)
        system_u
        ;;
      lazygit)
        lazygit_u
        ;;
      colloid)
        colloid_u
        ;;
      darkman)
        darkman_u
        ;;
      starship)
        starship_u
        ;;
      preexec)
        preexec_u
        ;;
      python)
        python_u
        ;;
      *)
        if [[ "$o" != "-h" ]]; then
          echo "Invalid option: '$o'. Use 'updates -h' for help."
        fi
        ;;
      esac
    done
  else
    # No options provided, display help
    info
  fi

  while getopts ":h" opt; do
    case "$opt" in
    h)
      info
      ;;
    *) ;;
    esac
  done
}
