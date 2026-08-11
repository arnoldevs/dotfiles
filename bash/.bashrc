# =====================================================================
# File: ~/.bashrc
# Description: Primary Interactive Shell Configuration
# OS: Debian GNU/Linux (Stable)
# Deployment: GNU Stow
# =====================================================================

# ---------------------------------------------------------------------
# Execution Guard
# ---------------------------------------------------------------------
# Exit immediately if the shell is not running interactively.
# This prevents output breakage during non-interactive sessions 
# (e.g., scp, rsync, or automated scripts).
case $- in
    *i*) ;;
      *) return;;
esac

# ---------------------------------------------------------------------
# Shell Options & Behavior
# ---------------------------------------------------------------------
# Update the values of LINES and COLUMNS after each command if the
# terminal window size has changed (vital for multiplexers or resizing).
shopt -s checkwinsize

# ---------------------------------------------------------------------
# History Configuration
# ---------------------------------------------------------------------
# ignoreboth: Equivalent to setting both 'ignorespace' (do not save 
# lines starting with a space) and 'ignoredups' (do not save duplicates).
HISTCONTROL=ignoreboth

# Append to the history file rather than overwriting it upon exit.
shopt -s histappend

# Expand history capacity (default is 1000).
HISTSIZE=10000
HISTFILESIZE=20000

# ---------------------------------------------------------------------
# Environment Context & Prompt (PS1)
# ---------------------------------------------------------------------
# Identify Debian chroot environments (useful for container/chroot prompt indicators).
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Fallback PS1 prompt in case external prompt frameworks fail to load.
# Format: [chroot] user@host:~/current_dir$ 
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

# ---------------------------------------------------------------------
# Auto-Completion
# ---------------------------------------------------------------------
# Enable programmable completion features (if not already enabled by 
# /etc/profile.d/bash_completion.sh in POSIX mode).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# ---------------------------------------------------------------------
# Modular Configuration Sourcing
# ---------------------------------------------------------------------
# Source all external shell script modules.
# Files must be placed in ~/.bashrc.d/ and end with the .sh extension.
if [ -d "$HOME/.bashrc.d" ]; then
    for file in "$HOME/.bashrc.d/"*.sh; do
        # Ensure the file is readable before attempting to source it
        [ -r "$file" ] && . "$file"
    done
    unset file
fi

# Source host-specific, untracked, or private configurations.
# NOTE: ~/.bashrc.local should be added to .gitignore in your dotfiles repo
# to prevent accidental leakage of API keys or private variables.
if [ -r "$HOME/.bashrc.local" ]; then
    . "$HOME/.bashrc.local"
fi
