return {
	-- Active startup colorscheme
	{
		"ellisonleao/gruvbox.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			contrast = "hard",
		},
		init = function()
		vim.cmd.colorscheme("gruvbox")
		end,
	},

	-- Secondary colorscheme (lazy-loaded for hot-swapping)
	{
		"folke/tokyonight.nvim",
		lazy = true,
		opts = {
			style = "night",
		},
	},
}
