# =====================================================================
# File: ~/.bashrc.d/themes.sh
# Description: Adaptive CLI Themes & Visual Tooling (Gruvbox Integration)
# =====================================================================

# ---------------------------------------------------------------------
# Dynamic Appearance Adapter
# ---------------------------------------------------------------------
# Read the environment state passed natively by the terminal emulator.
# Defaults safely to 'dark' if the variable is unassigned.
_theme_mode="${WEZTERM_THEME_MODE:-dark}"

if [[ "$_theme_mode" == "light" ]]; then
    export BAT_THEME="gruvbox-light"
    export FZF_DEFAULT_OPTS="
        --color=bg+:#ebdbb2,bg:#fbf1c7,spinner:#b57614,hl:#b57614
        --color=fg:#3c3836,header:#b57614,info:#076678,pointer:#b57614
        --color=marker:#b57614,fg+:#3c3836,prompt:#b57614,hl+:#b57614"
else
    export BAT_THEME="gruvbox-dark"
    export FZF_DEFAULT_OPTS="
        --color=bg+:#3c3836,bg:#282828,spinner:#fabd2f,hl:#fabd2f
        --color=fg:#ebdbb2,header:#fabd2f,info:#83a598,pointer:#fabd2f
        --color=marker:#fabd2f,fg+:#ebdbb2,prompt:#fabd2f,hl+:#fabd2f"
fi

# ---------------------------------------------------------------------
# Cleanup
# ---------------------------------------------------------------------
# Unset temporary local variables to prevent polluting the global shell scope.
unset _theme_mode
