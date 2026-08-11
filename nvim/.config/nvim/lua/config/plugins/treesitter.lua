return {
	-- Syntax highlighting and AST-based code navigation engine
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPre", "BufNewFile" },
		cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
		config = function(_, opts)
		local status_configs, configs = pcall(require, "nvim-treesitter.configs")
		if status_configs then
			configs.setup(opts)
			else
				local status_ts, ts = pcall(require, "nvim-treesitter")
				if status_ts and ts.setup then
					ts.setup(opts)
					end
					end
					end,
					opts = {
						ensure_installed = {
							"bash",
							"c",
							"dockerfile",
							"go",
							"java",
							"json",
							"lua",
							"markdown",
							"markdown_inline",
							"nix",
							"python",
							"query",
							"regex",
							"rust",
							"toml",
							"vim",
							"vimdoc",
							"yaml",
						},
						sync_install = false,
						auto_install = false,
						highlight = {
							enable = true,
							additional_vim_regex_highlighting = false,
						},
						indent = {
							enable = true,
						},
						incremental_selection = {
							enable = true,
							keymaps = {
								init_selection = "<C-space>",
								node_incremental = "<C-space>",
								scope_incremental = false,
								node_decremental = "<bs>",
							},
						},
					},
	},
}
