local M = {}

M.qf_toggle = function()
  local nr = vim.api.nvim_win_get_buf(0)
  vim.cmd("cwindow")
  local nr2 = vim.api.nvim_win_get_buf(0)
  if nr == nr2 then
    vim.cmd("cclose")
  end
end

M.zen_mode = function(extra_width, direction)
  local extra_width = extra_width or 0
  local direction = direction or 0
  local zen_mode = require("zen-mode.view")

  local fn = zen_mode.toggle
  if direction > 0 then
    fn = zen_mode.open
  elseif direction < 0 then
    fn = zen_mode.close
  end

  local opts = {
    window = {
      width = vim.bo.textwidth + extra_width,
    },
  }

  fn(opts)
end

M.diagnostic_severity = function()
  local severity = require("global").diagnostic_severity
  if severity == vim.diagnostic.severity.ERROR then
    return { "error" }
  end
  if severity == vim.diagnostic.severity.WARN then
    return { "error", "warn" }
  end
  if severity == vim.diagnostic.severity.INFO then
    return { "error", "warn", "info" }
  end
  if severity == vim.diagnostic.severity.HINT then
    return { "error", "warn", "info", "hint" }
  end
end

return M
