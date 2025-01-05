#!/usr/bin/env bash

# Add this lines to your .bashrc in the home directory
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

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

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
  # export JAVA_HOME="/usr/lib/jvm/java-openjdk" # apt option "/usr/lib/jvm/default-java"
  export PATH="$JAVA_HOME/bin:$PATH"
fi

[[ -d "/opt/nvim-linux64" ]] && export PATH="$PATH:/opt/nvim-linux64/bin"

if [[ -d "$HOME/.cargo" ]]; then
  . "$HOME/.cargo/env"
  source <(rustup completions bash)       # for rustup
  source <(rustup completions bash cargo) # for cargo
fi

[[ "$(readlink /proc/$$/exe)" = "/usr/bin/bash" ]] && bind 'set completion-ignore-case on'

# if type -P zellij >/dev/null; then eval "$(zellij setup --generate-auto-start bash)"; fi

if type -P starship >/dev/null; then eval "$(starship init bash)"; fi

if type -P zoxide >/dev/null; then eval "$(zoxide init bash)"; fi

if type -P atuin >/dev/null; then eval "$(atuin init bash)"; fi

[[ -f "$HOME/.bash-preexec.sh" ]] && source "$HOME/.bash-preexec.sh"

# apt fzf < 0.48.0 source /usr/share/doc/fzf/examples/key-bindings.bash; || > 0.48.0 eval "$(fzf --bash)";
if type -P fzf >/dev/null; then eval "$(fzf --bash)"; fi

if type -P go >/dev/null; then
  [[ -d /usr/local/go ]] && export PATH=$PATH:/usr/local/go/bin

  # Go versions less than 1.11
  # export GOPATH=$HOME/.go
  # export GOBIN=$GOPATH/bin
  # export PATH=$PATH:$GOBIN
fi
