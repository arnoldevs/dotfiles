return {
	-- Git integration for buffers (gutter signs and hunk management)
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			signs = {
				add = { text = "▎" },
				change = { text = "▎" },
				delete = { text = "" },
				topdelete = { text = "" },
				changedelete = { text = "▎" },
				untracked = { text = "▎" },
			},
			on_attach = function(bufnr)
			local gs = require("gitsigns")

			local function map(mode, l, r, desc)
			vim.keymap.set(mode, l, r, { buffer = bufnr, desc = "Git: " .. desc })
			end

			-- Navigation between hunks
			map("n", "]h", function() gs.nav_hunk("next") end, "Next Git hunk")
			map("n", "[h", function() gs.nav_hunk("prev") end, "Prev Git hunk")

			-- Actions
			map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
			map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
			map("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Stage selected hunk")
			map("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Reset selected hunk")

			map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
			map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
			map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")

			map("n", "<leader>hp", gs.preview_hunk_inline, "Preview hunk inline")
			map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
			map("n", "<leader>hd", gs.diffthis, "Diff this")

			-- Text object for hunks (e.g., 'dih' to delete inner hunk)
			map({ "o", "x" }, "ih", gs.select_hunk, "Select Git hunk")
			end,
		},
	},
}
