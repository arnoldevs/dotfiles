#!/usr/bin/env bash

## ALIASES, FUNCTIONS, AUTOCOMPLETE AND ENVIRONMENT VARIABLES ####

# Source custom configuration files from the ~/.dotfiles directory.
# Uncomment lines to enable; comment to disable.

# if [ -d ~/.dotfiles/bashrc.d ]; then
#   for rc in ~/.dotfiles/bashrc.d/*; do
#     if [ -f "$rc" ]; then
#       . "$rc"
#     fi
#   done
# fi
# unset rc

# In Fedora only run
# ln -s ~/.dotfiles/bashrc.d ~/.bashrc.d

#### LOCAL BINARIES ####
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"

#### CARGO RUST ####
if [[ -d "$HOME/.cargo" ]]; then
  . "$HOME/.cargo/env"
  source <(rustup completions bash)
  source <(rustup completions bash cargo)
fi

#### NVM ####
if [[ -d "$HOME/.nvm" ]]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

#### BASH COMPLETION ####
[[ "$(readlink /proc/$$/exe)" = "/usr/bin/bash" ]] && bind 'set completion-ignore-case on'
#### STARSHIP RS ####
if type -P starship >/dev/null; then eval "$(starship init bash)"; fi

#### ZOXIDE ####
if type -P zoxide >/dev/null; then eval "$(zoxide init bash)"; fi

#### FUZZY FINDER ####
if type -P fzf >/dev/null; then eval "$(fzf --bash)"; fi

#### JAVA ####
if type -P dnf &>/dev/null; then
  if type -P javac >/dev/null; then
  for jdk_dir in /usr/lib/jvm/*; do
    if [[ -d "$jdk_dir" && "$jdk_dir" == *temurin* ]]; then
      JAVA_HOME="$jdk_dir"
      break
    elif [[ -d "$jdk_dir" && "$jdk_dir" == java-openjdk ]]; then
      JAVA_HOME="$jdk_dir"
      break
    fi
  done
  export PATH="$JAVA_HOME/bin:$PATH"
fi
elif type -P apt &>/dev/null; then
  if type -P javac >/dev/null; then
    JAVA_HOME="/usr/lib/jvm/default-java"
    export PATH="$JAVA_HOME/bin:$PATH"
  fi
else
  exit 1
fi

#### NEOVIM ####
[[ -d "/opt/nvim-linux-x86_64" ]] && export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

#### GOLANG ####
if type -P go >/dev/null; then
  [[ -d /usr/local/go ]] && export PATH=$PATH:/usr/local/go/bin
fi
