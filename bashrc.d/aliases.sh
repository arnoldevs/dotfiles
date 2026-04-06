#!/usr/bin/env bash

#### NAVIGATION & DIRECTORY SHORTCUTS ####

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .2='cd ../..'
alias .3='cd ../../..'

#### SAFETY & INTEGRITY (NON-INTRUSIVE) ####

# Interactive versions (Manual confirmation)
alias rmi='/usr/bin/rm -iv'
alias cpi='/usr/bin/cp -iv'
alias mvi='/usr/bin/mv -iv'
alias lni='/usr/bin/ln -iv'

# System-wide protection flags
# Prevents accidental recursive operations on the root directory.
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

#### ENHANCED STANDARD UTILITIES ####

# Always enable color support for grep
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# LS / LSD Logic
# Prefers 'lsd' for a modern look if installed.
if command -v lsd &>/dev/null; then
  alias ls='lsd --group-dirs=first'
  alias l='lsd'
else
  alias ls='ls --color=auto'
  alias l='ls -CF'
fi

# Shared LS variants
alias ll='ls -lh'
alias la='ls -A'
alias lla='ls -lah'
alias lt='ls --tree'

#### MODERN CLI TOOL WRAPPERS ####

# BAT (Better Cat) Logic
# Handles 'batcat' (Debian) vs 'bat' (Arch/Fedora/Cargo).
BAT_BIN=$(command -v batcat || command -v bat)
if [[ -n "$BAT_BIN" ]]; then
  alias cat="$BAT_BIN"
  alias catp='$(command -v cat)'        # Plain cat fallback
  alias catpn="$BAT_BIN --paging=never" # Bat without pager
fi

# Visual/Terminal Specifics
if command -v wezterm &>/dev/null; then
  alias icat="wezterm imgcat"
elif command -v kitty &>/dev/null; then
  alias icat="kitty +kitten icat"
  alias kitty-diff="kitty +kitten diff"
fi

# Rusty-rain (Matrix effect)
command -v rusty-rain &>/dev/null && alias rain='rusty-rain -C 251,73,52 -sc jap'

#### CONTAINERIZATION (PODMAN AS DOCKER) ####

if command -v podman &>/dev/null; then
  # alias docker='podman'
  alias dprune='podman system prune --volumes'

  # Podman-compose support
  command -v podman-compose &>/dev/null && alias docker-compose='podman-compose'
fi

#### DEVELOPMENT WORKFLOW ####

if command -v nvim &>/dev/null; then
  alias v='nvim'
  alias vi='nvim'
  alias vim='nvim'
fi
