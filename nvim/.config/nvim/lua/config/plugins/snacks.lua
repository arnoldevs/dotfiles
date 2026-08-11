return {
	-- Modern, high-performance UI utilities (dashboard, notifications, picker, terminal, buffer delete)
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			dashboard = { enabled = true },
			notifier = { enabled = true, timeout = 3000 },
			bigfile = { enabled = true },
			quickfile = { enabled = true },
			statuscolumn = { enabled = true },
			words = { enabled = true },
			bufdelete = { enabled = true },
		},
		keys = {
			-- Notification management
			{ "<leader>nh", function() Snacks.notifier.show_history() end, desc = "Show notification history" },
			{ "<leader>nd", function() Snacks.notifier.hide() end, desc = "Dismiss active notifications" },

			-- Layout-safe buffer deletion (replaces dangerous plain :bdelete)
			{ "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete current buffer safely" },

			-- Integrated floating terminal toggle (works from Normal and Terminal mode)
			{ "<c-/>", function() Snacks.terminal() end, mode = { "n", "t" }, desc = "Toggle terminal" },
			{ "<c-_>", function() Snacks.terminal() end, mode = { "n", "t" }, desc = "which_key_ignore" },

			-- Git utilities
			{ "<leader>gb", function() Snacks.git.blame_line() end, desc = "Git blame line" },
			{ "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git browse (open web repository)" },

			-- Smart LSP/symbol navigation
			{ "]r", function() Snacks.words.jump(1, true) end, desc = "Next reference" },
			{ "[r", function() Snacks.words.jump(-1, true) end, desc = "Prev reference" },
		},
	},
}
