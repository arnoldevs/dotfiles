return {
  "brenoprata10/nvim-highlight-colors",
  config = function()
    require("nvim-highlight-colors").setup({
      render = "background", -- 'background'|'foreground'|'virtual'
      enable_named_colors = true,
      enable_var_usage = true,
      enable_tailwind = true,
    })
  end,
}
