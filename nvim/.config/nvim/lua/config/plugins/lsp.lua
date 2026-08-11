return {
	-- Native LSP client configuration
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			-- Load default LSP configs into vim.lsp.config
			require("lspconfig")

			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			-- Global Diagnostic UI Configuration
			vim.diagnostic.config({
				virtual_text = true,
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				float = {
					border = "rounded",
					source = "always",
				},
			})

			-- Global LSP keymaps attached per active buffer
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
				callback = function(ev)
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = ev.buf, desc = "LSP: " .. desc })
					end

					map("gd", vim.lsp.buf.definition, "Go to definition")
					map("gD", vim.lsp.buf.declaration, "Go to declaration")
					map("gr", vim.lsp.buf.references, "Show references")
					map("gi", vim.lsp.buf.implementation, "Go to implementation")
					map("K", vim.lsp.buf.hover, "Hover documentation")
					map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
					map("<leader>ca", vim.lsp.buf.code_action, "Code action")
					map("[d", function()
						vim.diagnostic.jump({ count = -1 })
					end, "Previous diagnostic")
					map("]d", function()
						vim.diagnostic.jump({ count = 1 })
					end, "Next diagnostic")
				end,
			})

			-- Language servers dictionary
			local servers = {
				lua_ls = {
					binary = { "lua-language-server" },
					opts = {
						settings = {
							Lua = {
								diagnostics = { globals = { "vim" } },
								workspace = { checkThirdParty = false },
								telemetry = { enable = false },
							},
						},
					},
				},
				bashls = { binary = { "bash-language-server" }, opts = {} },
				pyright = { binary = { "pyright-langserver", "pyright" }, opts = {} },
				gopls = { binary = { "gopls" }, opts = {} },
				rust_analyzer = { binary = { "rust-analyzer" }, opts = {} },
				nixd = { binary = { "nixd" }, opts = {} },
				dockerls = { binary = { "docker-langserver" }, opts = {} },
				marksman = { binary = { "marksman" }, opts = {} },
				ts_ls = { binary = { "typescript-language-server" }, opts = {} },
			}

			-- Attach servers using native Neovim 0.11+ API
			for server_name, server_info in pairs(servers) do
				local installed = false
				for _, bin in ipairs(server_info.binary) do
					if vim.fn.executable(bin) == 1 then
						installed = true
						break
					end
				end

				if installed then
					local opts = vim.tbl_deep_extend("force", { capabilities = capabilities }, server_info.opts or {})

					vim.lsp.config(server_name, opts)
					vim.lsp.enable(server_name)
				end
			end
		end,
	},
}
