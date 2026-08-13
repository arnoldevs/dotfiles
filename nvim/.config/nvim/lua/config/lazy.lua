-- =====================================================================
-- Plugin Manager Initialization (lazy.nvim)
-- Standardized configuration for performance and reliability.
-- =====================================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "config.plugins" },
  },
  defaults = {
    lazy = false,
  },
  -- Dynamic concurrency mapping based on available hardware cores
  concurrency = math.min(vim.uv.available_parallelism() * 2, 16),
  git = {
    timeout = 300, -- 5 minutes threshold for heavy repositories
    -- Global network flags (IPv4, HTTP/1.1) belong in ~/.gitconfig, 
    -- keeping only environment overrides here.
    args = {
      "-c", "commit.gpgsign=false",
      "-c", "tag.gpgSign=false",
      "-c", "core.pager=cat",
    },
  },
  install = {
    colorscheme = { "gruvbox", "habamax" },
  },
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    enabled = true,
    notify = false,
  },
  performance = {
    cache = {
      enabled = true,
    },
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
  ui = {
    border = "rounded",
    backdrop = 60, -- Dim background elements for better focus
  },
})
