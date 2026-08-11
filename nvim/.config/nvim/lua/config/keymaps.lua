-- =====================================================================
-- Global Keymaps
-- Utility mappings for navigation, editing, visual mode, and UI.
-- =====================================================================

local function map(mode, lhs, rhs, desc)
vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc })
end

-- Clear search highlights on pressing <Esc>
map("n", "<Esc>", "<cmd>nohlsearch<cr>", "Clear search highlights")

-- Window navigation
map("n", "<C-h>", "<C-w>h", "Focus left window")
map("n", "<C-j>", "<C-w>j", "Focus lower window")
map("n", "<C-k>", "<C-w>k", "Focus upper window")
map("n", "<C-l>", "<C-w>l", "Focus right window")

-- Fast save and quit
map("n", "<leader>w", "<cmd>w<cr>", "Save file")
map("n", "<leader>q", "<cmd>q<cr>", "Quit window")

-- Center cursor during half-page scrolling and search navigation
map("n", "<C-d>", "<C-d>zz", "Scroll down and center")
map("n", "<C-u>", "<C-u>zz", "Scroll up and center")
map("n", "n", "nzzzv", "Next search match (centered)")
map("n", "N", "Nzzzv", "Previous search match (centered)")

-- Indentation preservation in Visual mode
map("v", "<", "<gv", "Indent left and keep selection")
map("v", ">", ">gv", "Indent right and keep selection")

-- Move selected lines up and down
map("v", "J", ":m '>+1<cr>gv=gv", "Move selection down")
map("v", "K", ":m '<-2<cr>gv=gv", "Move selection up")

-- Paste over selection without replacing the paste buffer
map("x", "<leader>p", [["_dP]], "Paste without overwriting register")
