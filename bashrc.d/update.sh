#!/usr/bin/env bash

update() {
  local greenColour="\e[0;32m\033[1m"
  local endColour="\033[0m\e[0m"
  local redColour="\e[0;31m\033[1m"
  local yellowColour="\e[0;33m\033[1m"
  local COLOR_SCHEME="gruvbox"

  declare -a updates=(node_js neovim rust system_updates flatpak_packages python_user starship_rs preexec_bash customization)
  declare -a options=("$@")
  # IFS=" " read -r -a options <<< "$@"

  info() {
    echo -e "Usage: update [options]\n\nList of main commands:\n"
    echo -e "customization\nflatpak\nneovim\nnodejs\npreexec\nrust\nstarship\nsystem\nall"
  }

  node_js() {
    local NODEJS_VERSION
    NODEJS_VERSION=$(node -v)
    (
      cd "$NVM_DIR"
      git fetch --tags origin
      git checkout $(git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1))
    ) && \. "$NVM_DIR/nvm.sh"
    echo -e "${greenColour}Checking for possible nodejs updates${endColour}"
    if [ ! "$(nvm ls-remote --no-colors | tail -n1 | awk '{print $2}')" = "$(nvm current)" ]; then
      echo -e "${yellowColour}Nodejs update found${endColour}"
      nvm install node
      nvm use node
      nvm reinstall-packages "$NODEJS_VERSION"
    fi
    cd || return 1
  }

  neovim() {
    if [[ $(which nvim) = "/usr/local/bin/nvim" ]]; then
      curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
      if [ ! "$(md5sum /opt/nvim.appimage | awk '{print $1}')" = "$(md5sum "$HOME/nvim.appimage" | awk '{print $1}')" ]; then
        echo -e "${yellowColour}Neovim update found!${endColour}"
        chmod u+x nvim.appimage
        sudo rm /opt/nvim.appimage
        sudo mv "$HOME/nvim.appimage" /opt/
      else
        echo "Nothing to do."
        rm nvim.appimage
      fi
    fi
    if type -P lvim > /dev/null; then lvim +LvimUpdate +q; fi
  }

  rust() {
    if [ -d "$HOME/.cargo" ]; then
      echo -e "${greenColour}Updating rust${endColour}"
      rustup update
      ## The construction process can take a long time dependColouring on the capacity of the machine.
      ## It is convenient to ask before doing this action.
      while true; do
        echo -ne "${yellowColour}Update installed binaries by cargo? (y/n) -> ${endColour}" && read -r opt
        if [ "$(echo "$opt" | awk '{print tolower($0)}')" = "y" ]; then
          for bin in $(cargo install --list | awk 'NR % 2 != 0 {print $1}'); do
            cargo install "$bin" --force
          done
          break
        elif [ "$(echo "$opt" | awk '{print tolower($0)}')" = "n" ]; then
          break
        fi
      done
    fi
  }

  system_updates() {
    sudo fwupdmgr update
    if [ "$(
      which nala &>/dev/null
      echo $?
    )" -eq 0 ]; then
      echo -e "${greenColour}Updating OS${endColour}"
      sudo nala update && sudo nala upgrade -y
      sudo nala autoremove -y
      echo -e "${greenColour}Updating snap packages${endColour}"
      [[ -d /snap ]] && sudo snap refresh
    elif [ "$(
      which dnf &>/dev/null
      echo $?
    )" -eq 0 ]; then
      echo -e "${greenColour}Updating OS${endColour}"
      sudo dnf upgrade-minimal
      sudo dnf autoremove
    fi
  }

  flatpak_packages() {
    if [ "$(
      which flatpak &>/dev/null
      echo $?
    )" -eq 0 ]; then
      echo -e "${greenColour}Updating flatpak packages${endColour}"
      flatpak update
    fi
  }

  python_user() {
    if [[ $(pip freeze --user | awk -F "==" '{print $1}' | wc -l) -ge 1 ]]; then
      echo -e "${greenColour}Python packages for user found, updating them${endColour}"
      for package in $(pip freeze --user | awk -F "==" '{print $1}'); do
        pip install --user --upgrade "$package"
      done
    fi
  }

  starship_rs() {
    if [[ $(which starship 2>/dev/null) = "/usr/local/bin/starship" ]]; then
      echo -e "${greenColour}Updating starship${endColour}"
      curl -sS https://starship.rs/install.sh | sudo sh
    fi
  }

  preexec_bash() {
    if [[ -f ~/.bash-preexec.sh ]]; then
      echo -e "${greenColour}Updating bash-preexec${endColour}"
      curl https://raw.githubusercontent.com/rcaloras/bash-preexec/master/bash-preexec.sh -o ~/.bash-preexec.sh
    fi
    if [[ -d ~/.ble.sh ]]; then
      cd ~/.ble.sh || return 1   # <-- enter the git repository you already have
      git pull
      git submodule update --recursive --remote
      make
      make INSDIR="$HOME/.local/share/blesh" install
      cd || return 1
    fi
  }

  customization() {
    local THEME="$HOME/.customization"
    if [[ -d $THEME ]]; then
      cd "$THEME" || return 1
      echo -e "${greenColour}Checking for customizations updates${endColour}"
      for DIR in *; do
        cd "$DIR" || return 1
        git pull --rebase
        [[ "$DIR" == "colloid-gtk-theme" ]] && ./install.sh --tweaks $COLOR_SCHEME
        [[ "$DIR" == "colloid-icon-theme" ]] && ./install.sh
        cd .. || return 1
      done
      cd || return 1
    fi
  }

  if [[ ${#options[@]} -gt 0 ]]; then
    for o in "${options[@]}"; do
      case "$o" in
      all)
        for i in "${updates[@]}"; do $i; done
        ;;
      nodejs)
        node_js
        ;;
      neovim)
        neovim
        ;;
      rust)
        rust
        ;;
      system)
        system_updates
        ;;
      flatpak)
        flatpak_packages
        ;;
      python)
        python_user
        ;;
      starship)
        starship_rs
        ;;
      preexec)
        preexec_bash
        ;;
      customization)
        customization
        ;;
      *)
        if [[ "$o" != "-h" ]]; then
          echo -e "${redColour}'$o'${endColour} invalid command, use ${greenColour}update -h${endColour} to see more information"
        fi
        ;;
      esac
    done
  else
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
