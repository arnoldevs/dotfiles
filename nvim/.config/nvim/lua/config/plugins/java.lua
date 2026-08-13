return {
  -- Java Language Server & Debugger integration (Nix managed)
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    config = function()
      if vim.fn.executable("jdtls") == 0 then
        return
      end

      local function setup_jdtls()
        local jdtls = require("jdtls")
        local bufnr = vim.api.nvim_get_current_buf()

        -- Project root detection
        local root_markers = { "pom.xml", "gradlew", "build.gradle", ".git" }
        local root_dir = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()

        -- Isolated workspace cache per project
        local project_name = vim.fs.basename(root_dir) or "default"
        local workspace_dir = vim.fn.stdpath("data") .. "/site/java-workspace/" .. project_name

        -- Pathing for XDG M2 local repository and Eclipse OSGi cache
        local cache_dir = os.getenv("XDG_CACHE_HOME") or (os.getenv("HOME") .. "/.cache")
        local m2_repo_dir = cache_dir .. "/m2/repository"
        local eclipse_cache_dir = cache_dir .. "/eclipse"

        local cmd = { 
          "jdtls", 
          "-data", workspace_dir,
          "--jvm-arg=-Dmaven.repo.local=" .. m2_repo_dir,
          "--jvm-arg=-Dosgi.configuration.area=" .. eclipse_cache_dir .. "/configuration",
          "--jvm-arg=-Dosgi.instance.area=" .. eclipse_cache_dir .. "/workspace",
          "--jvm-arg=-Dosgi.user.area=" .. eclipse_cache_dir .. "/user",
        }

        -- Inject Lombok agent provided by Nix environment
        local lombok_jar = os.getenv("LOMBOK_JAR")
        if lombok_jar and vim.fn.filereadable(lombok_jar) == 1 then
          table.insert(cmd, string.format("--jvm-arg=-javaagent:%s", lombok_jar))
        end

        -- Load Debugger and Testing bundle JARs provided by Nix environment
        local bundles = {}

        local debug_dir = os.getenv("JAVA_DEBUG_JAR")
        if debug_dir and vim.fn.isdirectory(debug_dir) == 1 then
          local debug_jars = vim.fn.glob(debug_dir .. "/*.jar", true, true)
          vim.list_extend(bundles, debug_jars)
        end

        local test_dir = os.getenv("JAVA_TEST_JARS")
        if test_dir and vim.fn.isdirectory(test_dir) == 1 then
          local test_jars = vim.fn.glob(test_dir .. "/*.jar", true, true)
          vim.list_extend(bundles, test_jars)
        end

        local extendedClientCapabilities = jdtls.extendedClientCapabilities
        extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
        if has_cmp then
          capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
        end

        local config = {
          cmd = cmd,
          root_dir = root_dir,
          capabilities = capabilities,
          init_options = {
            extendedClientCapabilities = extendedClientCapabilities,
            bundles = bundles,
          },
          settings = {
            java = {
              signatureHelp = { enabled = true },
              contentProvider = { preferred = "fernflower" },
              implementationsCodeLens = { enabled = true },
              referencesCodeLens = { enabled = true },
              configuration = {
                maven = {
                  globalSettings = os.getenv("MAVEN_CONFIG_FILE"),
                },
              },
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
          on_attach = function(client, buf)
            local map = function(mode, lhs, rhs, desc)
              vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = "Java: " .. desc })
            end

            -- Code refactoring & navigation
            map("n", "<leader>jo", jdtls.organize_imports, "Organize Imports")
            map("n", "<leader>jc", jdtls.extract_constant, "Extract Constant")
            map("v", "<leader>jm", function() jdtls.extract_method(true) end, "Extract Method")
            map("v", "<leader>jv", function() jdtls.extract_variable(true) end, "Extract Variable")

            -- Test runner mappings
            map("n", "<leader>jt", jdtls.test_class, "Run Test Class")
            map("n", "<leader>jn", jdtls.test_nearest_method, "Run Nearest Test")

            -- DAP integration
            if #bundles > 0 then
              pcall(function()
                jdtls.setup_dap({ hotcodereplace = "auto" })
              end)

              local dap = require("dap")
              map("n", "<leader>db", dap.toggle_breakpoint, "Toggle Breakpoint")
              map("n", "<leader>dc", dap.continue, "Continue / Start Debugger")
              map("n", "<leader>di", dap.step_into, "Step Into")
              map("n", "<leader>do", dap.step_over, "Step Over")
              map("n", "<leader>dq", dap.terminate, "Terminate Session")
            end
          end,
        }

        jdtls.start_or_attach(config)
      end

      -- Autocommand trigger for Java filetypes
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        callback = setup_jdtls,
      })

      if vim.bo.filetype == "java" then
        setup_jdtls()
      end
    end,
  },
}
