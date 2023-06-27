#!/usr/bin/env bash

## Add and uncomment the following line to bashrc or zshrc as appropriate
# [[ -d \"\$HOME/.dotfiles/shellrc\" ]] && . \"\$HOME/.dotfiles/shellrc/env\"
#
## Or run the following line in terminal emulator if the distribution used is Fedora
# ln -s ~/.dotfiles/shellrc ~/.bashrc.d

###RC_DIR="$HOME/.dotfiles/shellrc"
if [[ $(which java &>/dev/null ; echo $?) -eq 0 ]]; then
export JAVA_HOME="/usr/lib/jvm/java-openjdk"
export PATH="$JAVA_HOME/bin:$PATH"
fi

if [[ $(which nvim &>/dev/null ; echo $?) -eq 0 ]]; then
export EDITOR="$(which nvim)"
export VISUAL="$(which nvim)"
fi

if [[ -d "$HOME/.nvm" ]]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   ##This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" ## This loads nvm bash_completion
fi

[[ -d "$HOME/.cargo" ]] && . "$HOME/.cargo/env"

if [ "$(readlink /proc/$$/exe)" = "/usr/bin/bash" ]; then
  [[ -f ~/.bash-preexec.sh ]] && source ~/.bash-preexec.sh
  [[ $(which atuin &>/dev/null ; echo $?) -eq 0 ]] && eval "$(atuin init bash)"
  [[ $(which fzf &>/dev/null ; echo $?) -eq 0 ]] && source /usr/share/fzf/shell/key-bindings.bash
  bind 'set completion-ignore-case on'
  [[ $(which starship &>/dev/null ; echo $?) -eq 0 ]] && eval "$(starship init bash)"
  [[ $(which zoxide &>/dev/null ; echo $?) -eq 0 ]] && eval "$(zoxide init bash)"
elif [ "$(readlink /proc/$$/exe)" = "/usr/bin/zsh" ]; then
  source /usr/share/fzf/shell/key-bindings.bash
  ###source /usr/share/doc/fzf/examples/completion.zsh
  source ~/.powerlevel10k/powerlevel10k.zsh-theme
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  source ~/.ohmyzsh/plugins/git/git.plugin.zsh
  source ~/.ohmyzsh/plugins/sudo/sudo.plugin.zsh
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

export FZF_DEFAULT_OPTS='--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 --color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 --color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 --color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4'

###if [ "$(env | grep XDG_CURRENT_DESKTOP | awk 'BEGIN { FS = "=" } ; { print $2 }')" = "KDE" ] && [ "$(echo $(pgrep latte-dock &>/dev/null) $?)" -eq 1 ]; then
###(latte-dock &)
###fi

###source "$RC_DIR/alias"
###source "$RC_DIR/update"

[[ $(which qt5ct &>/dev/null ; echo $?) -eq 0 ]] && export QT_QPA_PLATFORMTHEME='qt5ct'
