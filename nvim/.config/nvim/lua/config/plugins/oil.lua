return {
	-- File manager that lets you edit your filesystem like a normal Neovim buffer
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		lazy = false,
		keys = {
			{ "<leader>e", "<cmd>Oil --float<cr>", desc = "Toggle file explorer (Oil)" },
			{ "-", "<cmd>Oil<cr>", desc = "Open parent directory (Oil)" },
		},
		opts = {
			default_file_explorer = true,
			columns = { "icon" },
			view_options = {
				show_hidden = true,
			},
			float = {
				padding = 3,
				max_width = 100,
				max_height = 25,
				border = "rounded",
			},
			keymaps = {
				["l"] = "actions.select",
				["h"] = "actions.parent",
				["q"] = "actions.close",
				["<Esc>"] = "actions.close",
				["g."] = "actions.toggle_hidden",
			},
		},
	},
}
