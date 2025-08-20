#!/usr/bin/env bash

if [ "$(
  which lsd &>/dev/null
  echo $?
)" -eq 0 ]; then
  alias ls='lsd --group-dirs=first'
  alias ll='ls -lh'
  alias la='ls -a'
  alias l='lsd'
  alias lla='ls -lha'
  alias lt='ls --tree'
else
  alias ll='ls -lh'
  alias la='ls -A'
  alias l='ls -CF'
  alias lla='ls -lah'
  alias lt='ls --tree'
fi

if [ "$(
  which kitty &>/dev/null
  echo $?
)" -eq 0 ]; then
  alias icat="kitty +kitten icat"
  alias kitty-diff="kitty +kitten diff"
fi

if [ "$(
  which wezterm &>/dev/null
  echo $?
)" -eq 0 ]; then
  alias icat="wezterm imgcat"
fi

## The binary can be called bat or batcat depending on the distribution
if [ "$(
  which bat &>/dev/null
  echo $?
)" -eq 0 ]; then
  alias cat='bat'
  alias catp='/usr/bin/cat'
  alias catpn='bat --paging=never'
fi

if [ "$(
  which rusty-rain &>/dev/null
  echo $?
)" -eq 0 ]; then
  alias rain='rusty-rain -C 251,73,52 -sc jap'
  # alias rain='rusty-rain -C 152,151,26 -sc jap'
fi
