return {
	-- Automatic pairing of delimiters and quotes
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {
			check_ts = true,
		},
	},
}
