local M = {}

M.config = function()
  local ok, orgmode = pcall(require, "orgmode")
  if not ok then
    return
  end

  orgmode.setup_ts_grammar()
  orgmode.setup({})
end

return M
