return {
	-- Lightweight and flexible code formatter
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>cf",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = { "n", "v" },
				desc = "Format buffer or visual selection",
			},
		},
		opts = {
			-- Suppress popup warnings when binaries are missing outside Nix shells
			notify_on_error = false,
			notify_no_formatters = false,

			formatters_by_ft = {
				lua = { "stylua" },
				python = { "ruff_organize_imports", "ruff_format" },
				javascript = { "prettierd", "prettier", stop_after_first = true },
				typescript = { "prettierd", "prettier", stop_after_first = true },
				javascriptreact = { "prettierd", "prettier", stop_after_first = true },
				typescriptreact = { "prettierd", "prettier", stop_after_first = true },
				css = { "prettierd", "prettier", stop_after_first = true },
				html = { "prettierd", "prettier", stop_after_first = true },
				json = { "prettierd", "prettier", stop_after_first = true },
				yaml = { "prettierd", "prettier", stop_after_first = true },
				markdown = { "prettierd", "prettier", stop_after_first = true },
				java = { "google-java-format" },
				sh = { "shfmt" },
				bash = { "shfmt" },
				go = { "goimports", "gofmt" },
				rust = { "rustfmt" },
				nix = { "nixfmt" },
			},
			format_on_save = {
				timeout_ms = 1000,
				lsp_format = "fallback",
				quiet = true, -- Suppress status bar error noise on save when formatters fail
			},
		},
	},
}
