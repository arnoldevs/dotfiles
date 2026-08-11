return {
	-- Java Language Server integration (Nix managed)
	{
		"mfussenegger/nvim-jdtls",
		ft = { "java" },
		opts = function()
		return {
			settings = {
				java = {
					signatureHelp = { enabled = true },
					contentProvider = { preferred = "fernflower" },
					completion = {
						favoriteStaticMembers = {
							"org.hamcrest.MatcherAssert.assertThat",
							"org.hamcrest.Matchers.*",
							"org.hamcrest.CoreMatchers.*",
							"org.junit.jupiter.api.Assertions.*",
							"java.util.Objects.requireNonNull",
							"java.util.Objects.requireNonNullElse",
							"org.mockito.Mockito.*",
						},
					},
					sources = {
						organizeImports = {
							starThreshold = 9999,
							staticStarThreshold = 9999,
						},
					},
				},
			},
		}
		end,
		config = function(_, opts)
		if vim.fn.executable("jdtls") ~= 1 then
			return
			end

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "java",
				callback = function(event)
				local jdtls = require("jdtls")
				local root_markers = { "pom.xml", "gradlew", "build.gradle", ".git" }
				local root_dir = vim.fs.root(event.buf, root_markers) or vim.fn.getcwd()

				local project_name = vim.fs.basename(root_dir) or "default"
				local workspace_dir = vim.fn.stdpath("data") .. "/site/java-workspace/" .. project_name

				local extendedClientCapabilities = jdtls.extendedClientCapabilities
				extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

				local capabilities = vim.lsp.protocol.make_client_capabilities()
				local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
				if has_cmp then
					capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
					end

					local config = vim.deepcopy(opts)

					config.cmd = { "jdtls", "-data", workspace_dir }
					config.root_dir = root_dir
					config.capabilities = capabilities
					config.init_options = {
						extendedClientCapabilities = extendedClientCapabilities,
					}

					config.on_attach = function(client, bufnr)
					local map = function(mode, lhs, rhs, desc)
					vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = "Java: " .. desc })
					end

					map("n", "<leader>jo", jdtls.organize_imports, "Organize Imports")
					map("n", "<leader>jc", jdtls.extract_constant, "Extract Constant")
					map("v", "<leader>jm", function() jdtls.extract_method(true) end, "Extract Method")
					map("v", "<leader>jv", function() jdtls.extract_variable(true) end, "Extract Variable")

					pcall(function()
					jdtls.setup_dap({ hotcodereplace = "auto" })
					end)
					end

					jdtls.start_or_attach(config)
					end,
			})
			end,
	},
}
