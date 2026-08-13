return {
	-- Snappy buffer tabline with LSP integrations
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VeryLazy",
		keys = {
			{ "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev buffer" },
			{ "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
			{ "<leader>bp", "<cmd>BufferLinePick<cr>", desc = "Pick buffer" },
			{ "<leader>bc", "<cmd>BufferLinePickClose<cr>", desc = "Pick close buffer" },
			{ "<leader>bD", "<cmd>BufferLineCloseRight<cr>", desc = "Close buffers to the right" },
			{ "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "Close other buffers" },
		},
		opts = {
			options = {
				mode = "buffers",
				diagnostics = "nvim_lsp",
				diagnostics_indicator = function(count, level)
				local icon = level:match("error") and "󰅚 " or "󰀪 "
				return " " .. icon .. count
				end,
				separator_style = "thin",
				always_show_bufferline = true,
				show_buffer_close_icons = true,
				show_close_icon = false,
				offsets = {
					{
						filetype = "neo-tree",
						text = "File Explorer",
						text_align = "left",
						separator = true,
					},
				},
			},
		},
	},
}
