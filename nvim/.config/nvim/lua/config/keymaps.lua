-- =====================================================================
-- Global Keymaps Configuration
-- General utility mappings for UI, navigation, editing, and visual mode.
-- =====================================================================

local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

-- ---------------------------------------------------------------------
-- UI & General Operations
-- ---------------------------------------------------------------------

-- Clear search highlights
map("n", "<Esc>", "<cmd>nohlsearch<cr>", "Clear search highlights")

-- Fast file save and quit
map("n", "<leader>w", "<cmd>w<cr>", "Save file")
map("n", "<leader>q", "<cmd>q<cr>", "Quit window")

-- Universal save shortcut across Normal, Insert, and Visual modes
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr>", "Save file")

-- ---------------------------------------------------------------------
-- Window & Navigation Controls
-- ---------------------------------------------------------------------

-- Window focus switching
map("n", "<C-h>", "<C-w>h", "Focus left window")
map("n", "<C-j>", "<C-w>j", "Focus lower window")
map("n", "<C-k>", "<C-w>k", "Focus upper window")
map("n", "<C-l>", "<C-w>l", "Focus right window")

-- Centered half-page scrolling
map("n", "<C-d>", "<C-d>zz", "Scroll down and center cursor")
map("n", "<C-u>", "<C-u>zz", "Scroll up and center cursor")

-- Centered search navigation
map("n", "n", "nzzzv", "Next search match (centered)")
map("n", "N", "Nzzzv", "Previous search match (centered)")

-- ---------------------------------------------------------------------
-- Line & Text Manipulation
-- ---------------------------------------------------------------------

-- Move single lines or selections up/down (Alt + j/k in N, I, V)
map("n", "<A-j>", "<cmd>m .+1<cr>==", "Move line down")
map("n", "<A-k>", "<cmd>m .-2<cr>==", "Move line up")
map("i", "<A-j>", "<cmd>m .+1<cr>==gi", "Move line down")
map("i", "<A-k>", "<cmd>m .-2<cr>==gi", "Move line up")
map("v", "<A-j>", ":m '>+1<cr>gv=gv", "Move selection down")
map("v", "<A-k>", ":m '<-2<cr>gv=gv", "Move selection up")

-- Preserve visual selection during re-indentation
map("v", "<", "<gv", "Indent left and keep selection")
map("v", ">", ">gv", "Indent right and keep selection")

-- Paste over selection without overwriting default register
map("x", "<leader>p", [["_dP]], "Paste without overwriting register")
