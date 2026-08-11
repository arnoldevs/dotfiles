# =====================================================================
# File: ~/.bashrc.d/keybindings.sh
# Description: Custom Readline Shortcuts (Sudo & Editor Toggles)
# =====================================================================

# ---------------------------------------------------------------------
# Execution Guard
# ---------------------------------------------------------------------
# Abort if not running interactively OR if the shell is not Bash.
# This script relies heavily on GNU Readline and Bash-specific variables
# (READLINE_LINE, READLINE_POINT) which will cause errors in Zsh or Dash.
if [[ $- != *i* ]] || [[ -z "$BASH_VERSION" ]]; then
    return
fi

# ---------------------------------------------------------------------
# Sudo Toggle Core Logic (Shortcut: Esc Esc)
# ---------------------------------------------------------------------
# Helper function to evaluate if the current line already begins with 'sudo '
_sudo_plugin_is_inserted() {
    [[ "$READLINE_LINE" == "sudo "* ]]
}

# Toggles the 'sudo ' prefix on the current command line.
# If the line is empty, it automatically fetches the last executed command.
_sudo_plugin_toggle() {
    if [[ -z "$READLINE_LINE" ]]; then
        local last_cmd
        # Fetch the exact last command, stripping leading history line numbers 
        # and modification flags (e.g., ' 123* ') outputted by the history builtin.
        last_cmd=$(HISTTIMEFORMAT= history 1 | sed 's/^[ ]*[0-9]*[ *]*//')
        
        # Fallback to fc if history output varies across shell environments
        if [[ -z "$last_cmd" ]]; then
            last_cmd=$(fc -ln -1 2>/dev/null)
        fi
        READLINE_LINE="${last_cmd#"${last_cmd%%[![:space:]]*}"}"
    fi

    if _sudo_plugin_is_inserted; then
        READLINE_LINE="${READLINE_LINE#sudo }"
        ((READLINE_POINT -= 5))
    else
        READLINE_LINE="sudo $READLINE_LINE"
        ((READLINE_POINT += 5))
    fi

    READLINE_POINT=${#READLINE_LINE}
    ((READLINE_POINT < 0)) && READLINE_POINT=0
}

# ---------------------------------------------------------------------
# Pipe-to-Editor Core Logic (Shortcut: Alt + v)
# ---------------------------------------------------------------------
# Appends or removes a pipe to Neovim at the end of the current command.
# The '-' argument instructs Neovim to read from standard input (stdin),
# making it ideal for capturing and searching through large CLI outputs.
_pipe_to_editor_toggle() {
    local suffix=" | nvim -"
    
    # Check if the current line already ends with the suffix
    if [[ "$READLINE_LINE" == *"$suffix" ]]; then
        # Strip the suffix from the end of the string
        READLINE_LINE="${READLINE_LINE%$suffix}"
        ((READLINE_POINT -= ${#suffix}))
    else
        # Append the suffix to the end of the string
        READLINE_LINE="${READLINE_LINE}${suffix}"
        ((READLINE_POINT += ${#suffix}))
    fi
}

# ---------------------------------------------------------------------
# Key Bindings Mapping
# ---------------------------------------------------------------------
# The '-x' flag executes the shell command instead of inserting text.
# Applied across multiple Readline editing modes to ensure availability.

# Bind 'Esc Esc' (\e\e) to the Sudo Toggle
bind -m emacs -x '"\e\e": _sudo_plugin_toggle'
bind -m vi-insert -x '"\e\e": _sudo_plugin_toggle'
bind -m vi-command -x '"\e\e": _sudo_plugin_toggle'

# Bind 'Alt + v' (\ev) to the Pipe-to-Editor Toggle
bind -m emacs -x '"\ev": _pipe_to_editor_toggle'
bind -m vi-insert -x '"\ev": _pipe_to_editor_toggle'
