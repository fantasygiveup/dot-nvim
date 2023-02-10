local M = {}

M.global = function()
  vim.g.loaded_python3_provider = 0
  vim.g.loaded_ruby_provider = 0
  vim.g.loaded_node_provider = 0
  vim.g.loaded_perl_provider = 0
end

local function disable_distribution_plugins()
  vim.g.omni_sql_no_default_maps = 1
end

disable_distribution_plugins()

return M
