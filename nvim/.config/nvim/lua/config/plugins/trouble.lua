return {

	-- Pretty list for showing diagnostics, references, quickfix, and location lists

	{

		"folke/trouble.nvim",

		cmd = "Trouble",

		opts = {

			modes = {

				symbols = {

					desc = "document symbols",

					mode = "lsp_document_symbols",

					focus = false,

					win = { position = "right", width = 0.3 },

				},

			},

		},

		keys = {

			{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Project diagnostics (Trouble)" },

			{ "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics (Trouble)" },

			{ "<leader>cs", "<cmd>Trouble symbols toggle<cr>", desc = "Document symbols (Trouble)" },

			{ "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP definitions / references (Trouble)" },

			{ "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location list (Trouble)" },

			{ "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix list (Trouble)" },


			-- Quick navigation between diagnostics without opening the panel

			{

				"[x",

				function()

				require("trouble").prev({ skip_groups = true, jump = true })

				end,

				desc = "Previous Trouble item",

			},

			{

				"]x",

				function()

				require("trouble").next({ skip_groups = true, jump = true })

				end,

				desc = "Next Trouble item",

			},

		},

	},

}
