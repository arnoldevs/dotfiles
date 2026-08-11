# =====================================================================
# File: ~/.bashrc.d/env.sh
# Description: Environment Variables, Runtimes, and Path Management
# =====================================================================

# ---------------------------------------------------------------------
# Environment Helpers
# ---------------------------------------------------------------------
# Safely prepend directories to $PATH only if they exist and are not 
# already present. This prevents $PATH pollution and duplicate entries
# upon reloading the shell.
safe_path_add() {
    [[ -d "$1" ]] && [[ ":$PATH:" != *":$1:"* ]] && export PATH="$1:$PATH"
}

# ---------------------------------------------------------------------
# Core Paths & Default Editor
# ---------------------------------------------------------------------
# User-local binaries (e.g., pip/cargo installations or custom scripts)
safe_path_add "$HOME/.local/bin"

# Nix package manager profiles (system-wide and user-specific)
safe_path_add "/nix/var/nix/profiles/default/bin"
safe_path_add "$HOME/.nix-profile/bin"

# Set Neovim as the default text editor for system utilities (visudo, git, etc.)
export EDITOR="nvim"
export VISUAL="nvim"

# ---------------------------------------------------------------------
# Telemetry & Privacy
# ---------------------------------------------------------------------
# Opt-out of Determinate Systems (Nix installer) telemetry and crash reporting.
# Enforces privacy and prevents unauthorized outbound network requests.
export DETSYS_IDS_TELEMETRY=disabled
export NIX_SENTRY_ENDPOINT=""

# ---------------------------------------------------------------------
# Shell Aesthetics & Colors
# ---------------------------------------------------------------------
# Initialize file coloring for ls/tree commands. 
# Loads custom ~/.dircolors database if it exists, otherwise falls back 
# to the system default configuration.
if command -v dircolors &>/dev/null; then
    if test -r "$HOME/.dircolors"; then
        eval "$(dircolors -b "$HOME/.dircolors")"
    else
        eval "$(dircolors -b)"
    fi
fi

# ---------------------------------------------------------------------
# Containerization (Rootless Podman Integration)
# ---------------------------------------------------------------------
if command -v podman &>/dev/null; then
    # Expose the Podman UNIX socket as the default Docker host.
    # This allows Docker-dependent ecosystem tools (like docker-compose) 
    # to communicate seamlessly with rootless Podman.
    export DOCKER_HOST="unix://${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/podman/podman.sock"
    
    # Instruct Kubernetes IN Docker (kind) to use Podman as its runtime engine.
    if command -v kind &>/dev/null; then
        export KIND_EXPERIMENTAL_PROVIDER=podman
    fi
fi

# ---------------------------------------------------------------------
# Interactive Utilities & Prompts
# ---------------------------------------------------------------------
# Defensive check: Only initialize these tools if running interactively 
# AND explicitly running within Bash. This prevents syntax errors or 
# prompt breakage if this file is accidentally sourced by Zsh or similar.
if [[ -n "$PS1" ]] && [[ -n "$BASH_VERSION" ]]; then
    # Enable case-insensitive tab completion for paths and commands.
    # Note: 'bind' is a Bash-builtin; it will fail in other shells.
    bind 'set completion-ignore-case on'

    # Initialize modern Rust-based CLI tools with Bash-specific hooks
    command -v starship &>/dev/null && eval "$(starship init bash)"
    command -v zoxide &>/dev/null && eval "$(zoxide init bash)"
    command -v fzf &>/dev/null && eval "$(fzf --bash)"
    command -v direnv &>/dev/null && eval "$(direnv hook bash)"
fi

# ---------------------------------------------------------------------
# Cleanup
# ---------------------------------------------------------------------
# Unset the helper function to prevent polluting the global shell namespace.
unset -f safe_path_add
