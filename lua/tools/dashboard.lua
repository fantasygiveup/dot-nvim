local M = {}

M.config = function()
  local ok, dashboard = pcall(require, "dashboard")
  if not ok then
    return
  end

  dashboard.setup({
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
