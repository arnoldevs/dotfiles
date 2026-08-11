return {
	-- Real-time color code highlighter with Tailwind support
	{
		"brenoprata10/nvim-highlight-colors",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			render = "background",
			enable_named_colors = true,
			enable_tailwind = true,
		},
	},
}
