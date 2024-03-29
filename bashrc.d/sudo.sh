#!/usr/bin/bash
function sudo-command-line() {
  [[ ${#READLINE_LINE} -eq 0 ]] && READLINE_LINE=$(fc -l -n -1 | xargs)
  if [[ $READLINE_LINE == sudo\ * ]]; then
    READLINE_LINE="${READLINE_LINE#sudo }"
  else
    READLINE_LINE="sudo $READLINE_LINE"
  fi
  READLINE_POINT=${#READLINE_LINE}
}

# Define shortcut keys: [Esc] [Esc]

# Readline library requires bash version 4 or later
if [ "${BASH_VERSINFO}" -ge 4 ]; then
  bind -x '"\e\e": sudo-command-line'
fi
