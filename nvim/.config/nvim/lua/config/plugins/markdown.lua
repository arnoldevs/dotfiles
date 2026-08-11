return {
	-- Inline Markdown rendering for headings, tables, callouts, and code blocks
	{
		"MeanderingProgrammer/render-markdown.nvim",
		ft = { "markdown", "norg", "rmd", "org" },
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
		opts = {
			heading = {
				icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
			},
			code = {
				sign = false,
				width = "block",
				right_pad = 1,
			},
		},
	},
}
