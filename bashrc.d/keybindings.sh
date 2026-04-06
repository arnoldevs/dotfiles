#!/usr/bin/bash

# --- Function to check if sudo is already at the start ---
_sudo_plugin_is_inserted() {
  [[ "$READLINE_LINE" =~ ^sudo\  ]]
}

# --- Core Logic: Toggle sudo prefix ---
_sudo_plugin_toggle() {
  # If the line is empty, pull the last command from history (fc)
  if [[ -z "$READLINE_LINE" ]]; then
    READLINE_LINE=$(fc -ln -1 | sed 's/^[[:space:]]*//')
    READLINE_POINT=${#READLINE_LINE}
    _sudo_plugin_is_inserted && return
  fi

  if _sudo_plugin_is_inserted; then
    # Remove "sudo " (5 characters)
    READLINE_LINE="${READLINE_LINE#sudo }"
    ((READLINE_POINT -= 5))
  else
    # Add "sudo " at the beginning
    READLINE_LINE="sudo $READLINE_LINE"
    ((READLINE_POINT += 5))
  fi

  # Safety check for cursor position
  ((READLINE_POINT < 0)) && READLINE_POINT=0
}

# --- Keybindings (Keymap: ESC ESC) ---
# Escaping for Emacs, Vi-insert, and Vi-command modes
# Note: \e\e represents pressing Escape twice.
bind -m emacs -x '"\e\e": _sudo_plugin_toggle'
bind -m vi-insert -x '"\e\e": _sudo_plugin_toggle'
bind -m vi-command -x '"\e\e": _sudo_plugin_toggle'
