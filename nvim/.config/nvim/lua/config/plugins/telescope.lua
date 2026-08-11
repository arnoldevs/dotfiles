return {
	-- Highly extendable fuzzy finder over lists
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
				return vim.fn.executable("make") == 1
				end,
			},
		},
		cmd = "Telescope",
		keys = {
			{ "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
			{ "<leader>fF", "<cmd>Telescope find_files hidden=true no_ignore=true<cr>", desc = "Find all files" },
			{ "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Find text (live grep)" },
			{ "<leader>fG", "<cmd>Telescope live_grep additional_args={'--hidden','--no-ignore'}<cr>", desc = "Find text in all files" },
			{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find open buffers" },
			{ "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Find help tags" },
			{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Find recent files" },
			{ "<leader>fc", "<cmd>Telescope find_files cwd=" .. vim.fn.stdpath("config") .. "<cr>", desc = "Find Neovim config files" },
		},
		opts = {
			defaults = {
				path_display = { "smart" },
				file_ignore_patterns = { "%.git/" },
				preview = {
					treesitter = false,
				},
			},
		},
		config = function(_, opts)
		local telescope = require("telescope")
		telescope.setup(opts)
		pcall(telescope.load_extension, "fzf")
		end,
	},
}
