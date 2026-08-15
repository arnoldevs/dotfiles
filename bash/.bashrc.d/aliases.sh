# =====================================================================
# File: ~/.bashrc.d/aliases.sh
# Description: Shell Aliases and Command Abstractions
# =====================================================================

# ---------------------------------------------------------------------
# Navigation & Directory Shortcuts
# ---------------------------------------------------------------------
# Rapid directory traversal
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .2='cd ../..'
alias .3='cd ../../..'

# ---------------------------------------------------------------------
# Core Utilities Safety & Enhancements
# ---------------------------------------------------------------------
# Interactive and verbose file operations to prevent accidental data loss
alias rmi='rm -iv'
alias cpi='cp -iv'
alias mvi='mv -iv'
alias lni='ln -iv'

# Prevent recursive operations on the root directory (failsafe)
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

# Colorize grep output and resolve GNU grep deprecation warnings 
# (egrep and fgrep are deprecated in favor of grep -E and grep -F)
alias grep='grep --color=auto'
alias fgrep='grep -F --color=auto'
alias egrep='grep -E --color=auto'

# ---------------------------------------------------------------------
# Modern CLI Replacements
# ---------------------------------------------------------------------
# EZA: ls command with colors and icons
if command -v eza &>/dev/null; then
    alias ls='eza --group-directories-first --icons'
    alias l='eza --icons'
    alias ll='eza -l --group-directories-first --icons'
    alias la='eza -a --icons'
    alias lla='eza -la --group-directories-first --icons'
    alias lt='eza --tree --icons'
else
    # Fallback to standard GNU ls if eza is not installed
    alias ls='ls --color=auto'
    alias l='ls -CF'
    alias ll='ls -lh'
    alias la='ls -A'
    alias lla='ls -lah'
fi

# BAT: A cat clone with syntax highlighting and Git integration
# Note: In Debian-based systems, 'bat' is installed as 'batcat' 
# due to a naming collision with the bacula-console-qt package.
if command -v batcat &>/dev/null; then
    alias bat='batcat'
    alias cat='batcat'
    
    # Bypass batcat and use the original GNU cat when needed
    alias catp='command cat'
    
    # Use batcat strictly for syntax highlighting without the pager
    alias catpn='batcat --paging=never'
fi

# ---------------------------------------------------------------------
# Terminal-Specific Features
# ---------------------------------------------------------------------
# Native image rendering directly in the terminal emulator
if command -v wezterm &>/dev/null; then
    alias icat="wezterm imgcat"
fi

# ---------------------------------------------------------------------
# Editors & Development
# ---------------------------------------------------------------------
# Route traditional vi/vim commands to Neovim
if command -v nvim &>/dev/null; then
    alias v='nvim'
    alias vi='nvim'
    alias vim='nvim'
fi
