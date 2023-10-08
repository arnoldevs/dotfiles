#!/usr/bin/env bash

## Add and uncomment the following line to bashrc or zshrc as appropriate if it does not exist
# if [ -d ~/.bashrc.d ]; then
# 	for rc in ~/.bashrc.d/*; do
# 		if [ -f "$rc" ]; then
# 			. "$rc"
# 		fi
# 	done
# fi
## And run the following line in terminal emulator
# ln -s ~/.dotfiles/bashrc.d/ ~/.bashrc.d

if [[ $(
  which javac &>/dev/null
  echo $?
) -eq 0 ]]; then
  export JAVA_HOME="/usr/lib/jvm/java-openjdk"
  export PATH="$JAVA_HOME/bin:$PATH"
fi

# if [[ $(
#   which nvim &>/dev/null
#   echo $?
# ) -eq 0 ]]; then
#   export EDITOR="$(which nvim)"
#   export VISUAL="$(which nvim)"
# fi

if [[ -d "$HOME/.nvm" ]]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   ##This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" ## This loads nvm bash_completion
fi

if [[ -d "$HOME/.cargo" ]]; then
  . "$HOME/.cargo/env"
  for file in ~/.bash_completion.d/*.bash_completion; do
    . "$file"
  done
fi

if [ "$(readlink /proc/$$/exe)" = "/usr/bin/bash" ]; then
  [[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh
  [[ $(
    which atuin &>/dev/null
    echo $?
  ) -eq 0 ]] && eval "$(atuin init bash)"
  [[ $(
    which fzf &>/dev/null
    echo $?
  ) -eq 0 ]] && source /usr/share/fzf/shell/key-bindings.bash
  bind 'set completion-ignore-case on'
  [[ $(
    which starship &>/dev/null
    echo $?
  ) -eq 0 ]] && eval "$(starship init bash)"
  [[ $(
    which zoxide &>/dev/null
    echo $?
  ) -eq 0 ]] && eval "$(zoxide init bash)"
fi

# [[ $(
#   which qt5ct &>/dev/null
#   echo $?
# ) -eq 0 ]] && export QT_QPA_PLATFORMTHEME='qt5ct'
