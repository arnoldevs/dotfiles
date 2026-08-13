return {
    -- Modern, high-performance UI utilities (dashboard, notifications, picker, terminal, buffer delete, indent)
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
            picker = { enabled = true },
            indent = {
                enabled = true,
                char = "│",
                only_scope = false,
                only_current = false,
            },
        },
        keys = {
            -- Notification management
            { "<leader>nh", function() Snacks.notifier.show_history() end, desc = "Show notification history" },
            { "<leader>nd", function() Snacks.notifier.hide() end, desc = "Dismiss active notifications" },

            -- Layout-safe buffer deletion
            { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete current buffer safely" },

            -- Integrated floating terminal toggle
            { "<c-/>", function() Snacks.terminal() end, mode = { "n", "t" }, desc = "Toggle terminal" },
            { "<c-_>", function() Snacks.terminal() end, mode = { "n", "t" }, desc = "which_key_ignore" },

            -- Git utilities
            { "<leader>gb", function() Snacks.git.blame_line() end, desc = "Git blame line" },
            { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git browse (open web repository)" },

            -- Smart LSP/symbol navigation
            { "]r", function() Snacks.words.jump(1, true) end, desc = "Next reference" },
            { "[r", function() Snacks.words.jump(-1, true) end, desc = "Prev reference" },

            -- --- Picker ---
            { "<leader>ff", function() Snacks.picker.files() end, desc = "Find files" },
            { "<leader>fF", function() Snacks.picker.files({ hidden = true, ignored = true }) end, desc = "Find all files" },
            { "<leader>fg", function() Snacks.picker.grep() end, desc = "Find text (live grep)" },
            { "<leader>fG", function() Snacks.picker.grep({ hidden = true, ignored = true }) end, desc = "Find text in all files" },
            { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Find open buffers" },
            { "<leader>fh", function() Snacks.picker.help() end, desc = "Find help tags" },
            { "<leader>fr", function() Snacks.picker.recent() end, desc = "Find recent files" },
            { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Neovim config files" },
            { "<leader>sp", function() Snacks.picker.pickers() end, desc = "List all available pickers" },
        },
    },
}
