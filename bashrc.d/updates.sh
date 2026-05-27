#!/usr/bin/env bash

# --- Global Configuration ---
# User-specific paths and theme preferences
CUSTOM_DIR="$HOME/.custom"
scheme="gruvbox"
themeVariant="yellow"

# --- Gruvbox Color Palette ---
# UI Constants for consistent terminal feedback
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# --- Global Counters ---
# Initialized here but reset inside the main function scope
SUCCESS_COUNT=0
TOTAL_COUNT=0

# --- Internal Helpers ---

# Status Messengers
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() {
  echo -e "${GREEN}[SUCCESS]${NC} $1"
  ((SUCCESS_COUNT++))
}
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }
log_task() { echo -e "${PURPLE}  -> Executing:${NC} $1"; }

# Privilege and Context Validation
has_sudo() {
  [[ "$EUID" -eq 0 ]] && return 0
  sudo true 2>/dev/null
  return $?
}

smart_run() {
  if [[ "$EUID" -eq 0 ]]; then "$@"; else sudo "$@"; fi
}

check_and_cd() {
  if [[ ! -d "$1" ]]; then
    log_error "Path not found: $1"
    return 1
  fi
  cd "$1" || return 1
  log_info "Context: $1"
}

update_git_repo() {
  log_info "Syncing Git repository..."
  if git pull --rebase; then
    log_success "Repo synchronized."
    return 0
  else
    log_error "Git conflict in $(basename "$PWD")"
    return 1
  fi
}

# --- Non-Sudo Functions (User Scope) ---

nerdfonts_u() {
  log_info "Deploying JetBrainsMono Nerd Font..."
  local FONT_DIR="$HOME/.local/share/fonts/JetbrainsMono"
  local TEMP_FILE="JetBrainsMono.tar.xz"
  [[ -d "$FONT_DIR" ]] && rm -rf "$FONT_DIR"
  mkdir -p "$FONT_DIR"
  if curl -OL --silent --show-error "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${TEMP_FILE}"; then
    tar -xf "$TEMP_FILE" -C "$FONT_DIR/"
    fc-cache -f && rm -f "$TEMP_FILE"
    log_success "Fonts deployed."
    return 0
  else
    log_error "Font download failed."
    return 1
  fi
}

flatpak_u() {
  if command -v flatpak &>/dev/null; then
    log_info "Updating Flatpaks..."
    flatpak update -y && log_success "Flatpak updated." && return 0
    log_error "Flatpak failed."
    return 1
  else
    log_warn "Flatpak missing."
    return 0
  fi
}

neovim_u() {
  local INSTALL_PATH="$HOME/.local/bin/nvim"
  [[ ! -f "$INSTALL_PATH" ]] && {
    log_error "Nvim missing."
    return 1
  }
  local TEMP_DIR=$(mktemp -d)
  cd "$TEMP_DIR" || return 1
  if curl -LJO --silent --show-error "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage"; then
    chmod u+x nvim-linux-x86_64.appimage
    if [[ $(stat -c%s "$INSTALL_PATH") -ne $(stat -c%s "nvim-linux-x86_64.appimage") ]]; then
      mv "nvim-linux-x86_64.appimage" "$INSTALL_PATH"
      log_success "Neovim binary updated."
    else
      log_info "Neovim is already at the latest version."
      ((SUCCESS_COUNT++))
    fi
    rm -rf "$TEMP_DIR" && cd ~ && return 0
  else
    log_error "Nvim download failed."
    rm -rf "$TEMP_DIR"
    cd ~
    return 1
  fi
}

rust_u() {
  if [[ -d "$HOME/.cargo" ]]; then
    log_info "Updating Rust toolchain..."
    rustup update || {
      log_error "Rustup failed."
      return 1
    }

    # --- Static Completions Generation ---
    # This matches the directory we defined in the 'env' file
    local COMP_PATH="$HOME/.local/share/bash-completion/completions"
    log_info "Regenerating static Bash completions..."
    mkdir -p "$COMP_PATH"
    rustup completions bash >"$COMP_PATH/rustup"
    rustup completions bash cargo >"$COMP_PATH/cargo"
    # -------------------------------------

    local bins=$(cargo install --list | awk 'NR % 2 != 0 {print $1}')
    echo -e "${CYAN}Current Binaries:${NC}\n$bins"
    read -p "Update Rust binaries? (y/n) -> " opt
    if [[ "${opt,,}" == "y" ]]; then
      for bin in $bins; do cargo install "$bin" --force; done
      log_success "Rust binaries and completions updated."
    else
      log_info "Rust binaries skipped by user."
      log_success "Rust completions updated." # Still count as success for the completions
    fi
    return 0
  else
    log_warn "Rust environment not found."
    return 0
  fi
}

beekeeper_u() {
  local INSTALL_PATH="$HOME/.local/bin/beekeeper-studio"
  [[ ! -f "$INSTALL_PATH" ]] && {
    log_error "Beekeeper missing."
    return 1
  }
  local API_URL="https://api.github.com/repos/beekeeper-studio/beekeeper-studio/releases/latest"
  local RELEASE_DATA=$(curl -s "$API_URL")
  local LATEST_TAG=$(echo "$RELEASE_DATA" | grep '"tag_name":' | head -n 1 | cut -d '"' -f 4)
  local FILE_NAME=$(echo "$RELEASE_DATA" | grep -oP '"name": "\KBeekeeper-Studio-.*\.AppImage"' | grep -v 'arm64' | head -n 1 | tr -d '"')
  local TEMP_DIR=$(mktemp -d)
  cd "$TEMP_DIR" || return 1
  if curl -L --silent -o "beekeeper.AppImage" "https://github.com/beekeeper-studio/beekeeper-studio/releases/download/${LATEST_TAG}/${FILE_NAME}"; then
    if [[ $(stat -c%s "$INSTALL_PATH") -ne $(stat -c%s "beekeeper.AppImage") ]]; then
      chmod u+x "beekeeper.AppImage"
      mv "beekeeper.AppImage" "$INSTALL_PATH"
      log_success "Beekeeper updated to $LATEST_TAG."
    else
      log_info "Beekeeper is already at the latest version."
      ((SUCCESS_COUNT++))
    fi
    rm -rf "$TEMP_DIR" && cd ~ && return 0
  else
    log_error "Beekeeper download failed."
    rm -rf "$TEMP_DIR"
    cd ~
    return 1
  fi
}

python_u() {
  if command -v python3 &>/dev/null; then
    log_info "Updating user-scope Python packages (PEP 668 bypass)..."
    python3 -m pip freeze --user | awk -F "==" '{print $1}' | xargs -n1 python3 -m pip install --user --upgrade --break-system-packages 2>/dev/null
    log_success "Python environment updated."
    return 0
  else
    log_warn "Python3 missing."
    return 0
  fi
}

colloid_u() {
  if [[ -d "$CUSTOM_DIR/Colloid-gtk-theme" ]]; then
    log_info "Updating UI themes and assets..."
    for DIR in "$CUSTOM_DIR"/Colloid-* "$CUSTOM_DIR"/Tela-icon-theme; do
      [[ ! -d "$DIR" ]] && continue
      local name=$(basename "$DIR")
      case "$name" in
      "Colloid-gtk-theme") check_and_cd "$DIR" && update_git_repo && ./install.sh --theme "$themeVariant" --color dark --libadwaita --tweaks "$scheme" float ;;
      "Colloid-icon-theme") check_and_cd "$DIR" && update_git_repo && mkdir -p "$HOME/.local/share/icons" && cd cursors/ && ./install.sh ;;
      "Tela-icon-theme") check_and_cd "$DIR" && update_git_repo && mkdir -p "$HOME/.local/share/icons" && ./install.sh "$themeVariant" ;;
      esac
      cd ~
    done
    log_success "UI themes updated."
    return 0
  else
    log_warn "Theme source directories not found. Skipping."
    ((SUCCESS_COUNT++)) # Count as processed skip
    return 0
  fi
}

node_u() {
  if [[ -d "$HOME/.nvm" ]]; then
    log_info "Updating Node.js LTS via NVM..."

    # --- INTERNAL BYPASS ---
    # Manually source NVM logic to override shell placeholders
    # within the current script execution context.
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    # Verify NVM was sourced correctly before proceeding
    if ! command -v nvm &>/dev/null; then
      log_error "NVM core could not be sourced."
      return 1
    fi

    # Execute update and package migration
    if nvm install --lts --reinstall-packages-from=current; then
      log_success "Node.js update cycle complete."
      return 0
    else
      log_error "Node.js installation failed."
      return 1
    fi
  else
    log_warn "NVM directory not found. Skipping."
    return 0
  fi
}

kind_u() {
  if command -v go >/dev/null; then
    log_info "Updating kind (Kubernetes in Docker)..."
    go install sigs.k8s.io/kind@latest && log_success "kind updated." && return 0
    log_error "kind update failed."
    return 1
  else
    log_warn "Go toolchain missing."
    return 0
  fi
}

# --- Sudo Functions (System Scope) ---

minegrub_u() {
  if [[ -d "$CUSTOM_DIR/minegrub-theme" ]]; then
    log_info "Updating MineGrub assets..."
    check_and_cd "$CUSTOM_DIR/minegrub-theme" && update_git_repo
    smart_run cp -ruv ./minegrub /boot/grub/themes/
    smart_run grub-mkconfig -o /boot/grub/grub.cfg
    log_success "GRUB theme refreshed."
    return 0
  else
    log_warn "MineGrub directory missing."
    return 0
  fi
}

system_u() {
  log_info "Initializing system maintenance..."
  command -v fwupdmgr >/dev/null && smart_run fwupdmgr update
  if command -v nala >/dev/null; then
    smart_run nala update && smart_run nala upgrade -y
  else
    smart_run apt update && smart_run apt upgrade -y && smart_run apt autoremove -y
  fi
  [[ -d /snap ]] && smart_run snap refresh
  log_success "System packages updated."
  return 0
}

darkman_u() {
  if [[ -d "$CUSTOM_DIR/darkman" ]]; then
    log_info "Rebuilding Darkman service..."
    check_and_cd "$CUSTOM_DIR/darkman" && update_git_repo
    make && smart_run make install PREFIX=/usr
    systemctl --user enable --now darkman.service
    log_success "Darkman service updated."
    return 0
  else
    log_warn "Darkman source missing."
    return 0
  fi
}

syft_u() {
  log_info "Updating Syft SBOM tool..."
  if curl -sSfL https://raw.githubusercontent.com/anchore/syft/main/install.sh | smart_run sh -s -- -b /usr/local/bin; then
    log_success "Syft updated."
    return 0
  else
    log_error "Syft installation failed."
    return 1
  fi
}

# --- Main logic ---

updates() {
  # Reset counters on every call to prevent accumulation in the same session
  SUCCESS_COUNT=0
  TOTAL_COUNT=0

  declare -a updates_user=(beekeeper_u nerdfonts_u flatpak_u colloid_u neovim_u node_u rust_u python_u kind_u)
  declare -a updates_sudo=(minegrub_u system_u darkman_u syft_u)

  info() {
    echo -e "${CYAN}Available Commands:${NC}"
    echo -e "  -u, --user  Run user-space updates\n  -s, --sudo  Run system-space updates\n  -a, --all   Full maintenance cycle"
    echo -e "\n${YELLOW}Atomic Modules:${NC}"
    for i in "${updates_user[@]}" "${updates_sudo[@]}"; do echo "  ${i%_u}"; done
  }

  run_updates() {
    local type="$1"
    local list_var="updates_$type[@]"
    local list=("${!list_var}")

    if [[ "$type" == "user" && "$EUID" -eq 0 ]]; then
      log_error "Safety: Do not run user tasks as Root."
      return 1
    fi
    if [[ "$type" == "sudo" && "$EUID" -ne 0 ]] && ! has_sudo; then
      log_error "Privilege Escalation Required."
      return 1
    fi

    echo -e "${PURPLE}=== Launching $type Sequence ===${NC}"
    for func in "${list[@]}"; do
      ((TOTAL_COUNT++))
      log_task "${func%_u}"
      "$func" || log_error "Module '${func%_u}' returned an error."
    done
  }

  [[ "$#" -eq 0 ]] && {
    info
    return 0
  }

  case "$1" in
  -u | --user) run_updates "user" ;;
  -s | --sudo) run_updates "sudo" ;;
  -a | --all)
    if [[ "$EUID" -eq 0 ]]; then
      run_updates "sudo"
    else
      run_updates "user"
      has_sudo && run_updates "sudo" || log_warn "Sudo sequence skipped."
    fi
    ;;
  -h | --help)
    info
    return 0
    ;;
  *)
    # Single task manual execution
    for arg in "$@"; do
      local func="${arg}_u"
      if declare -f "$func" >/dev/null; then
        if [[ " ${updates_sudo[*]} " =~ " $func " ]] && [[ "$EUID" -ne 0 ]] && ! has_sudo; then
          log_error "Task '$arg' requires sudo privileges."
        else
          ((TOTAL_COUNT++))
          "$func" || log_error "Manual task '$arg' failed."
        fi
      else
        log_error "Unknown task: $arg"
        return 1
      fi
    done
    ;;
  esac

  # Final summary with clean counters
  echo -e "\n${CYAN}Update Cycle Finished${NC}"
  echo -e "Tasks attempted: $TOTAL_COUNT | Successful modules: $SUCCESS_COUNT"
}

# --- Entry point ---
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  updates "$@"
fi
