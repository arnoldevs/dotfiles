#!/usr/bin/env bash

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
  for rc in ~/.bashrc.d/*; do
    if [ -f "$rc" ]; then
      . "$rc"
    fi
  done
fi
unset rc

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

if type -P javac >/dev/null; then
  export JAVA_HOME="/usr/lib/jvm/default-java"
  export PATH="$JAVA_HOME/bin:$PATH"
fi

[[ -d "/opt/nvim-linux64" ]] && export PATH="$PATH:/opt/nvim-linux64/bin"

if [[ -d "$HOME/.cargo" ]]; then
  . "$HOME/.cargo/env"
  source <(rustup completions bash)       # for rustup
  source <(rustup completions bash cargo) # for cargo
fi

[[ "$(readlink /proc/$$/exe)" = "/usr/bin/bash" ]] && bind 'set completion-ignore-case on'

if type -P starship >/dev/null; then eval "$(starship init bash)"; fi

if type -P zoxide >/dev/null; then eval "$(zoxide init bash)"; fi

if type -P atuin >/dev/null; then eval "$(atuin init bash)"; fi

[[ -f "$HOME/.bash-preexec.sh" ]] && source "$HOME/.bash-preexec.sh"

if type -P fzf >/dev/null; then source /usr/share/doc/fzf/examples/key-bindings.bash; fi

if type -P go >/dev/null; then
  [[ -d /usr/local/go ]] && export PATH=$PATH:/usr/local/go/bin
  export GOPATH=$HOME/.go
  export GOBIN=$GOPATH/bin
  export PATH=$PATH:$GOBIN
fi

[[ -d "$HOME/.dotfiles" ]] && . "$HOME/.dotfiles/bashrc.d/mu.sh"
