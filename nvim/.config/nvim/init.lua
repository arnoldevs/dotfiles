-- =====================================================================
-- Neovim Entry Point
-- Modular architecture for options, keymaps, autocmds, and plugins.
-- =====================================================================

-- Set leader key before loading any modules or keymaps
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Core configuration modules
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")
