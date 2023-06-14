local M = {}

M.config = function()
  local custom_settings_file =
    vim.fn.expand("$HOME/github.com/illia-danko/restricted/nvim/custom_settings.lua")
  if require("utils.file").file_exists(custom_settings_file) then
    dofile(custom_settings_file)
  end
end

return M
