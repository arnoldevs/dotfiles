return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "css",
        "dockerfile",
        "go",
        "html",
        "java",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "nix",
        "python",
        "query",
        "regex",
        "rust",
        "sql",
        "toml",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      },
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = { query = "@function.outer", desc = "Select outer function" },
            ["if"] = { query = "@function.inner", desc = "Select inner function" },
            ["ac"] = { query = "@class.outer", desc = "Select outer class" },
            ["ic"] = { query = "@class.inner", desc = "Select inner class" },
            ["aa"] = { query = "@parameter.outer", desc = "Select outer parameter" },
            ["ia"] = { query = "@parameter.inner", desc = "Select inner parameter" },
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]m"] = { query = "@function.outer", desc = "Next function start" },
            ["]]"] = { query = "@class.outer", desc = "Next class start" },
          },
          goto_next_end = {
            ["]M"] = { query = "@function.outer", desc = "Next function end" },
            ["]["] = { query = "@class.outer", desc = "Next class end" },
          },
          goto_previous_start = {
            ["[m"] = { query = "@function.outer", desc = "Previous function start" },
            ["[["] = { query = "@class.outer", desc = "Previous class start" },
          },
          goto_previous_end = {
            ["[M"] = { query = "@function.outer", desc = "Previous function end" },
            ["[]"] = { query = "@class.outer", desc = "Previous class end" },
          },
        },
      },
    },
  },
}
