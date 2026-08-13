return {
  -- Debug Adapter Protocol User Interface
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    keys = {
      {
        "<leader>du",
        function() require("dapui").toggle() end,
        desc = "Debug: Toggle UI",
      },
      {
        "<leader>de",
        function() require("dapui").eval() end,
        desc = "Debug: Evaluate Expression",
        mode = { "n", "v" },
      },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- Initialize default UI components
      dapui.setup()

      -- Automatically open DAP UI panels when a debug session starts
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end

      -- Automatically close DAP UI panels when a debug session ends
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end

      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
}
