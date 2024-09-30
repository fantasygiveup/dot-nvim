local M = {}

M.config = function()
  require("dashboard").setup({
    config = {
      week_header = {
        enable = true,
      },
      shortcut = {
        { desc = "󰊳 Update", group = "@property", action = "Lazy update", key = "u" },
      },
      project = { enable = false },
    },
  })
end

return M
