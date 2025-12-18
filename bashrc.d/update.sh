#!/usr/bin/env bash

CUSTOM_DIR="$HOME/.custom"
scheme="gruvbox"
themeVariant="yellow"

# NON-SUDO FUNCTIONS
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
  # Exit immediately if a command exits with a non-zero status.
  set -e

  APPIMAGE_URL="https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage"
  INSTALL_PATH="$HOME/.local/bin/nvim"
  TEMP_DIR=$(mktemp -d)

  # Check if an existing version is installed. If not, exit gracefully.
  if [[ ! -f "$INSTALL_PATH" ]]; then
    echo "Neovim is not installed at $INSTALL_PATH. This script is only for updating."
    return 1
  fi

  echo "Existing Neovim version detected. Checking for updates..."

  # Navigate to the temporary directory. The script will stop if this fails.
  cd "$TEMP_DIR"

  # Download the file. The script will stop if this fails.
  curl -LJO --silent --show-error "$APPIMAGE_URL"

  # Make the downloaded file executable. The script will stop if this fails.
  chmod u+x nvim-linux-x86_64.appimage

  # Compare the file sizes to check for a new version
  EXISTING_SIZE=$(stat -c%s "$INSTALL_PATH")
  DOWNLOADED_SIZE=$(stat -c%s "nvim-linux-x86_64.appimage")

  if [[ "$EXISTING_SIZE" -ne "$DOWNLOADED_SIZE" ]]; then
    echo "A new version of NeoVim is available. Updating..."
    mv "nvim-linux-x86_64.appimage" "$INSTALL_PATH"
    echo "NeoVim updated successfully."
  else
    echo "Neovim is already up to date. No action required."
    # Remove the downloaded file since it's not needed.
    rm "nvim-linux-x86_64.appimage"
  fi

  # Final cleanup
  echo "Cleaning up temporary files..."
  rm -rf "$TEMP_DIR"

  cd ~ || return 1

  # Unset the strict mode at the end of the function to avoid affecting other functions.
  set +e
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

beekeeper_u() {
  # Exit immediately if a command exits with a non-zero status.
  set -e

  INSTALL_PATH="$HOME/.local/bin/beekeeper-studio"
  TEMP_DIR=$(mktemp -d)
  MIN_SIZE_BYTES=1000000 # Minimum expected size for an AppImage (1 MB)

  # 1. Check if an existing version is installed. If not, exit.
  if [[ ! -f "$INSTALL_PATH" ]]; then
    echo "Beekeeper Studio is not installed at $INSTALL_PATH. This script is only for updating."
    return 1
  fi

  echo "Existing Beekeeper Studio version detected. Checking for updates..."

  # --- Dynamic URL and Filename Discovery ---
  GITHUB_API_URL="https://api.github.com/repos/beekeeper-studio/beekeeper-studio/releases/latest"

  # Fetch release data
  RELEASE_DATA=$(curl -s "$GITHUB_API_URL")

  # Extract the version tag (e.g., v5.4.9)
  LATEST_VERSION=$(echo "$RELEASE_DATA" | grep '"tag_name":' | head -n 1 | cut -d '"' -f 4)

  # Find the exact AppImage filename (for x86_64 architecture) from the assets list
  APPIMAGE_FILENAME=$(echo "$RELEASE_DATA" | grep -oP '"name": "\KBeekeeper-Studio-.*\.AppImage"' | grep -v 'arm64' | head -n 1 | tr -d '"')

  if [[ -z "$LATEST_VERSION" || -z "$APPIMAGE_FILENAME" ]]; then
    echo "Error: Could not determine the latest version or AppImage filename from GitHub API." >&2
    return 1
  fi

  # Construct the direct download URL
  APPIMAGE_URL="https://github.com/beekeeper-studio/beekeeper-studio/releases/download/${LATEST_VERSION}/${APPIMAGE_FILENAME}"
  # -----------------------------------------

  # Fixed filename to use in the temporary directory.
  DOWNLOADED_FILE="Beekeeper-Studio-latest.AppImage"

  # 2. Navigate to the temporary directory
  cd "$TEMP_DIR"

  echo "Downloading Beekeeper Studio AppImage from $APPIMAGE_URL..."

  # 3. Download the file
  # -L: Follows redirects
  # -o: Saves the output to the specified filename.
  curl -L --silent --show-error "$APPIMAGE_URL" -o "$DOWNLOADED_FILE"

  # 4. Verification check: Check if the downloaded file is a valid binary.
  if [[ ! -f "$DOWNLOADED_FILE" || $(stat -c%s "$DOWNLOADED_FILE") -lt "$MIN_SIZE_BYTES" ]]; then
    echo "Error: The downloaded file is too small or does not exist. Download failed." >&2
    # Clean up and return an error code (1)
    rm -rf "$TEMP_DIR"
    cd ~ || return 1
    set +e
    return 1
  fi

  echo "Download successful. File size: $(du -h "$DOWNLOADED_FILE" | awk '{print $1}')"

  # 5. Make the downloaded file executable
  chmod u+x "$DOWNLOADED_FILE"

  # 6. Compare the file sizes
  EXISTING_SIZE=$(stat -c%s "$INSTALL_PATH")
  DOWNLOADED_SIZE=$(stat -c%s "$DOWNLOADED_FILE")

  if [[ "$EXISTING_SIZE" -ne "$DOWNLOADED_SIZE" ]]; then
    echo "A new version of Beekeeper Studio ($LATEST_VERSION) is available. Updating..."
    # Move the new AppImage to the installation path, overwriting the old one
    mv "$DOWNLOADED_FILE" "$INSTALL_PATH"
    echo "Beekeeper Studio updated successfully."
  else
    echo "Beekeeper Studio is already up to date. No action required."
    # Delete the downloaded file since it's not needed
    rm "$DOWNLOADED_FILE"
  fi

  # 7. Final cleanup
  echo "Cleaning up temporary files..."
  rm -rf "$TEMP_DIR"

  cd ~ || return 1

  # Unset the strict mode at the end of the function.
  set +e
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
        # sudo flatpak override --filesystem=xdg-config/gtk-3.0 && sudo flatpak override --filesystem=xdg-config/gtk-4.0
        cd ~ || return 1
      fi
      if [[ "$(basename "$DIR")" == "Colloid-icon-theme" ]]; then
        echo "Updating Colloid icon theme..."
        cd "$DIR" || return 1
        update_git_repo
        mkdir -p "$HOME/.local/share/icons"
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

# SUDO FUNCTIONS
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

# MAIN FUNCTION TO HANDLE UPDATES
updates() {
  # Declares arrays for user and sudo updates
  declare -a updates_user=(beekeeper_u nerdfonts_u flatpak_u colloid_u neovim_u node_u rust_u python_u)
  declare -a updates_sudo=(minegrub_u system_u darkman_u)

  # Helper function to display help information
  info() {
    echo -e "Usage: updates [option | Individual_names]\n"
    echo -e "Options:"
    echo "  -u, --user  Run only user updates (without sudo)"
    echo "  -s, --sudo  Run only sudo updates"
    echo "  -a, --all   Run all updates (user first, then sudo)"
    echo "  -h, --help  Display this help message"
    echo -e "\nIndividual Updates:"
    # List all available functions from both arrays
    for i in "${updates_user[@]}"; do echo "  ${i%%_u}"; done
    for i in "${updates_sudo[@]}"; do echo "  ${i%%_u}"; done
  }

  # Helper function to run the updates
  run_updates() {
    local type="$1"
    local updates_list=()

    if [[ "$type" == "user" ]]; then
      updates_list=("${updates_user[@]}")
      echo "Starting user updates..."
    elif [[ "$type" == "sudo" ]]; then
      updates_list=("${updates_sudo[@]}")
      echo "Starting sudo updates..."
    fi

    for func_name in "${updates_list[@]}"; do
      echo "  -> Executing: ${func_name%%_u}"
      if [[ "$type" == "sudo" ]]; then
        sudo "$func_name"
      else
        "$func_name"
      fi
    done
  }

  # Main logic: Check for arguments and handle them
  if [[ "$#" -eq 0 ]]; then
    info
    return 0
  fi

  case "$1" in
  -u | --user)
    run_updates "user"
    ;;
  -s | --sudo)
    run_updates "sudo"
    ;;
  -a | --all)
    run_updates "user"
    run_updates "sudo"
    ;;
  -h | --help)
    info
    ;;
  *)
    # If the first argument is not a known flag, loop through all arguments
    local found=false
    for arg in "$@"; do
      local func_name="${arg}_u"
      if [[ " ${updates_user[@]} " =~ " ${func_name} " ]]; then
        "$func_name"
        found=true
      elif [[ " ${updates_sudo[@]} " =~ " ${func_name} " ]]; then
        sudo "$func_name"
        found=true
      else
        echo "Invalid function name or option: '$arg'. Use 'updates -h' for help." >&2
        return 1
      fi
    done
    ;;
  esac
}
