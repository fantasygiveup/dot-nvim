local M = {}

M.config = function()
  local orgmode = require("orgmode")
  orgmode.setup_ts_grammar()
  orgmode.setup({})
end

return M
