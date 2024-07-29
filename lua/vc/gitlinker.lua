local M = {}

M.config = function()
  local ok, gitlinker = pcall(require, "gitlinker")
  if not ok then
    return
  end

  local ok, actions = pcall(require, "gitlinker.actions")
  if not ok then
    return
  end

  gitlinker.setup({
    mappings = nil, -- don't use default mappings
  })

  require("keymap").git_linker()
end

return M
