-- =====================================================================
-- Global Editor Options
-- UI, formatting, search, and system performance configurations.
-- =====================================================================

local opt = vim.opt

-- Line numbering
opt.number = true
opt.relativenumber = true

-- Code indentation (2-space standard)
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

-- Search behavior
opt.ignorecase = true
opt.smartcase = true

-- UI, performance, and rendering
opt.termguicolors = true
opt.splitbelow = true
opt.splitright = true
opt.signcolumn = "yes"
opt.updatetime = 250
opt.timeoutlen = 300
opt.cursorline = true
opt.scrolloff = 8
opt.wrap = false
opt.showmode = false
opt.confirm = true
opt.inccommand = "split"
opt.fillchars = { eob = " " }

-- Selection and mouse interaction
opt.mouse = "a"
opt.virtualedit = "block"

-- System integration, undo, and safety
opt.clipboard = "unnamedplus"
opt.undofile = true
opt.swapfile = false
opt.backup = false

-- Code folding defaults (Treesitter integration)
opt.foldlevel = 99
opt.foldlevelstart = 99
