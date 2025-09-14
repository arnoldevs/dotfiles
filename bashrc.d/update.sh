#!/usr/bin/env bash

CUSTOM_DIR="$HOME/.customization"
scheme="gruvbox"
themeVariant="red"
# Function to check directory existence and change directory
check_and_cd() {
  if [[ ! -d "$1" ]]; then
    echo "Directory not found: $1"
    return 1
  fi
  cd "$1" || return 1
  echo "Successfully changed directory to '$1'."
}

# Function to update git repository
update_git_repo() {
  echo "Updating Git repository..."
  git pull --rebase
  if [[ $? -ne 0 ]]; then
    echo "  Error: Git pull failed. Checking for specific errors..."
    # You can add more specific error checking here using 'git status' or the exit code
    git status
    echo "  Please address any errors and try again."
    return 1
  fi
  echo "  Git repository updated successfully."
}

minegrub_u() {
  if [[ -d "$CUSTOM_DIR/minegrub-theme" ]]; then
    echo "Found MineGrub theme directory at $CUSTOM_DIR/minegrub-theme"
    cd "$CUSTOM_DIR/minegrub-theme" || return 1
    update_git_repo
    echo "Copying MineGrub theme files..."
    sudo cp -ruv ./minegrub /boot/grub/themes/ || {
      echo "Error: Failed to copy MineGrub theme files. Please check permissions."
      return 1
    }
    # Check if GRUB_THEME is already set
    if ! grep -Fxq 'GRUB_THEME=/boot/grub/themes/minegrub/theme.txt' /etc/default/grub; then
      echo "GRUB_THEME not found in /etc/default/grub. Adding..."
      # Append GRUB_THEME setting to /etc/default/grub
      sudo tee -a /etc/default/grub <<EOF
GRUB_THEME=/boot/grub/themes/minegrub/theme.txt
EOF
    fi
    echo "Regenerating GRUB configuration..."
    sudo grub-mkconfig -o /boot/grub/grub.cfg
    cd || return 1
  fi
}

nerdfonts_u() {
  if [ "$(
    fc-list | grep JetBrainsMono &>/dev/null
    echo $?
  )" -eq 0 ]; then
    echo "Installing JetBrainsMono Nerd Font..."
    curl -OL https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz
    mkdir -p "$HOME/.local/share/fonts/JetbrainsMono"
    echo "Extracting downloaded font..."
    tar -xf ./JetBrainsMono.tar.xz -C "$HOME/.local/share/fonts/JetbrainsMono/"
    echo "Updating font cache..."
    fc-cache
    echo "Cleaning up..."
    rm JetBrainsMono.tar.xz
  fi
}

system_u() {
  # Identify package manager and perform updates
  if type -P fwupdmgr >/dev/null; then
    echo "Updating system with fwupdmgr..."
    sudo fwupdmgr update
  fi
  if type -P apt >/dev/null; then
    echo "Updating system with apt..."
    sudo apt update && sudo apt upgrade
    echo "Removing unused packages..."
    sudo apt autoremove
  fi
  if [ "$(
    which nala &>/dev/null
    echo $?
  )" -eq 0 ]; then
    echo "Updating system with nala frontend..."
    sudo nala update && sudo nala upgrade
  fi
  if [[ -d /snap ]]; then
    echo "Updating Snaps..."
    sudo snap refresh
  fi
  if [ "$(
    which dnf &>/dev/null
    echo $?
  )" -eq 0 ]; then
    echo "Updating system with dnf (minimal upgrade)..."
    sudo dnf upgrade-minimal
    echo "Removing unused packages..."
    sudo dnf autoremove
  fi
  echo "System updates complete."
}

flatpak_u() {
  if [ "$(
    which flatpak &>/dev/null
    echo $?
  )" -eq 0 ]; then
    echo "Checking for Flatpak updates..."
    flatpak update
    # Provide feedback on the update process
    if [[ $? -eq 0 ]]; then
      echo "Flatpak packages updated successfully."
    else
      echo "Error: Failed to update Flatpak packages."
    fi
  else
    echo "Flatpak is not installed. Please install it before running this script."
  fi
}

neovim_u() {
  if [[ -d "/opt/nvim-linux-x86_64" ]]; then
    echo "Existing NeoVim installation detected in /opt/nvim-linux-x86_64."
    echo "Downloading the latest NeoVim source..."
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    sudo rm -rf /opt/nvim
    echo "Extracting downloaded source..."
    sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
    echo "Cleaning up..."
    rm nvim-linux-x86_64.tar.gz
  fi
  if [[ -f "/opt/nvim/nvim-linux-x86_64.appimage" ]]; then
    echo "Existing NeoVim AppImage detected in /opt/nvim/nvim-linux-x86_64.appimage."
    echo "Downloading and verifying the latest NeoVim AppImage integrity..."
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage

    existing_checksum=$(md5sum "/opt/nvim/nvim-linux-x86_64.appimage" | awk '{print $1}')
    downloaded_checksum=$(md5sum ./nvim-linux-x86_64.appimage | awk '{print $1}')
    if [ "$existing_checksum" != "$downloaded_checksum" ]; then
      echo "Checksums differ. Updating NeoVim AppImage..."
      chmod u+x nvim-linux-x86_64.appimage
      sudo rm /opt/nvim/nvim-linux-x86_64.appimage
      sudo mv ./nvim-linux-x86_64.appimage /opt/nvim/
      sudo ln -sf /opt/nvim/nvim-linux-x86_64.appimage /usr/local/bin/nvim
    else
      echo "Checksums match. Existing NeoVim AppImage is up-to-date."
    fi
    echo "Cleaning up..."
    rm nvim-linux-x86_64.appimage
  fi
  if type -P lvim >/dev/null; then lvim +LvimUpdate +q; fi
}

rust_u() {
  if [ -d "$HOME/.cargo" ]; then
    echo "Cargo directory found."
    # Update rustup
    echo "Updating rustup..."
    if ! rustup update; then
      echo "Error: Failed to update rustup"
      return 1
    fi

    echo "Getting list of installed binaries..."
    installed_bins=$(cargo install --list | awk 'NR % 2 != 0 {print $1}')
    echo "The following binaries are installed:"
    echo "$installed_bins"
    echo "" # Add an empty line for better readability

    # Ask for confirmation before updating binaries
    while true; do
      echo -ne "Update these binaries? (y/n) -> " && read -r opt
      if [[ "$(echo "$opt" | tr '[:upper:]' '[:lower:]')" == "y" ]]; then
        for bin in $installed_bins; do
          echo "Updating binary: $bin..."
          if ! cargo install "$bin" --force; then
            echo "Error: Failed to update binary: $bin"
          else
            echo "  Successfully updated binary: $bin"
          fi
        done
        break
      elif [[ "$(echo "$opt" | tr '[:upper:]' '[:lower:]')" == "n" ]]; then
        echo "Skipping binary updates."
        break
      fi
      echo "Invalid input. Please enter 'Y' or 'N'."
    done
    source ~/.bashrc
  else
    echo "Cargo directory not found at $HOME/.cargo. Rust may not be installed."
  fi
}

darkman_u() {
  if [[ -d "$CUSTOM_DIR/darkman" ]]; then
    echo "Found Darkman directory"
    cd "$CUSTOM_DIR/darkman" || return 1
    update_git_repo
    echo "Building Darkman..."
    make || {
      echo "Error: Failed to build Darkman. Please check the build output for details."
      return 1
    }
    echo "Installing Darkman (requires sudo)..."
    sudo make install PREFIX=/usr
    cd || return 1
    echo "Enabling and starting Darkman service for your user session..."
    systemctl --user enable --now darkman.service
  fi
}

python_u() {
  if [[ $(pip freeze --user | awk -F "==" '{print $1}' | wc -l) -ge 1 ]]; then
    echo "Updating user-installed Python packages..."
    for package in $(pip freeze --user | awk -F "==" '{print $1}'); do
      echo "  Upgrading package: $package"
      pip install --user --upgrade "$package"
    done
  else
    echo "No user-installed Python packages found."
  fi
}

colloid_u() {
  if [[ -d "$CUSTOM_DIR/Colloid-gtk-theme" ]]; then
    echo "Found Colloid theme directories"
    for DIR in "$CUSTOM_DIR"/*; do
      if [[ "$(basename "$DIR")" == "Colloid-gtk-theme" ]]; then
        echo "Updating Colloid GTK theme..."
        cd "$DIR" || return 1
        update_git_repo
        echo "Reinstalling.."
        ./install.sh --theme $themeVariant --color dark --libadwaita --tweaks $scheme float
        # ./install.sh --theme $themeVariant --tweaks $scheme
        # themeCamelCase=$(echo "$themeVariant" | sed 's/\b./\U&/g')
        # schemeCamelCase=$(echo "$scheme" | sed 's/\b./\U&/g')
        # ln -sf ~/.themes/Colloid-${themeCamelCase}-Dark-${schemeCamelCase}/gtk-4.0/* ~/.config/gtk-4.0/
        echo "Fix for Flatpak..."
        sudo flatpak override --filesystem=xdg-config/gtk-3.0 && sudo flatpak override --filesystem=xdg-config/gtk-4.0
        cd ~ || return 1
      fi
      if [[ "$(basename "$DIR")" == "Colloid-icon-theme" ]]; then
        echo "Updating Colloid icon theme..."
        cd "$DIR" || return 1
        update_git_repo
        mkdir -p "$HOME/.local/share/icons"
        echo "Reinstalling..."
        ./install.sh --scheme $scheme --theme $themeVariant
        echo "Reinstalling Colloid cursors..."
        cd "$DIR/cursors/" || return 1
        ./install.sh
        cd ~ || return 1
      fi
      if [[ "$(basename "$DIR")" == "Tela-icon-theme" ]]; then
        echo "Updating Tela icon theme..."
        cd "$DIR" || return 1
        update_git_repo
        mkdir -p "$HOME/.local/share/icons"
        echo "Reinstalling..."
        ./install.sh $themeVariant
        cd ~ || return 1
      fi
    done
  else
    echo "Colloid theme directories not found"

  fi
}

node_u() {
  if [[ -d "$HOME/.nvm" ]]; then
    echo "NVM directory found"
    (
      cd "$NVM_DIR"
      git fetch --tags origin
      git checkout $(git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1))
    ) && \. "$NVM_DIR/nvm.sh"
    if [ ! "$(nvm ls-remote --lts --no-colors | tail -n1 | awk '{print $2}')" = "$(nvm current)" ]; then
      echo "  Current version is not the latest LTS."
      echo "  Reinstalling latest LTS version..."
      nvm install --reinstall-packages-from=current 'lts/*'
      # echo "  Installing latest npm version..."
      # nvm install-latest-npm
    else
      echo "  Currently using the latest LTS version."

    fi
    echo "Switching back to previous directory..."
    cd || return 1
  else
    echo "NVM directory not found at $HOME/.nvm. NVM might not be installed."

  fi
}

updates() {
  declare -a updates=(minegrub_u nerdfonts_u lazygit_u system_u flatpak_u colloid_u neovim_u node_u rust_u python_u darkman_u)
  declare -a options=("$@")
  IFS=" " read -r -a options <<<"$@"

  info() {
    echo -e "Usage: updates [options]\n\nList of main commands:\n"
    for i in "${updates[@]}"; do
      echo "$i" | cut -d '_' -f 1
    done
    echo -e "\n all: Release all updates"
    echo " -h: Displays this help message"
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
      colloid)
        colloid_u
        ;;
      darkman)
        darkman_u
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
