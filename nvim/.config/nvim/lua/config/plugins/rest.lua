return {
  -- REST Client for testing HTTP Endpoints natively inside Neovim
  {
    "mistweaverco/kulala.nvim",
    ft = { "http", "rest" },
    opts = {
      default_view = "body",
      display_mode = "split",
      split_direction = "vertical",
      contenttypes = {
        ["application/json"] = {
          ft = "json",
          formatter = { "jq", "." },
        },
      },
    },
    keys = {
      { "<leader>Rr", function() require("kulala").run() end, desc = "REST: Send Request", ft = { "http", "rest" } },
      { "<leader>Ra", function() require("kulala").run_all() end, desc = "REST: Send All Requests", ft = { "http", "rest" } },
      { "<leader>Rt", function() require("kulala").toggle_view() end, desc = "REST: Toggle Headers/Body", ft = { "http", "rest" } },
    },
  },
}
