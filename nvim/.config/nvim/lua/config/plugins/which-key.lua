return {
    -- Keybinding popup menu and command discoverability engine
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            preset = "modern",
            spec = {
                { "<leader>b", group = "Buffer" },
                { "<leader>c", group = "Code / LSP" },
                { "<leader>d", group = "Debug (DAP)" },
                { "<leader>f", group = "Find / Picker" },
                { "<leader>g", group = "Git" },
                { "<leader>h", group = "Git Hunks" },
                { "<leader>j", group = "Java / Spring" },
                { "<leader>n", group = "Notifications" },
                { "<leader>r", group = "Rename / References" },
                { "<leader>x", group = "Trouble / Diagnostics" },
            },
        },
        keys = {
            {
                "<leader>?",
                function() require("which-key").show({ global = false }) end,
                desc = "Buffer local keymaps (WhichKey)",
            },
        },
    },
}
