local M = {}

-- load_system_theme relies on $HOME/.config/appearance/background

M.theme = function(theme_file)
  local fd = io.open(theme_file)
  local theme = fd:read()
  fd:close()
  return theme
end

M.load_background = function()
  local system_theme_file = require("vars").system_theme_file
  vim.o.background = M.theme(system_theme_file)
end

M.load_background_async = function()
  local timer = vim.loop.new_timer()
  timer:start(
    0,
    0,
    vim.schedule_wrap(function()
      M.load_background()
    end)
  )
end

return M
