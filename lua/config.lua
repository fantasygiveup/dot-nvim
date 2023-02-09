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

M.comment_nvim = function()
  require("Comment").setup({})
end

M.nvim_surround = function()
  require("nvim-surround").setup({})
end

M.autopairs = function()
  require("nvim-autopairs").setup()
end

M.project_nvim = function()
  local project_nvim = require("project_nvim").setup({
    patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "go.mod" },
    detection_methods = { "pattern", "lsp" },
  })
end

M.yanky = function()
  require("yanky").setup({
    highlight = {
      on_put = false,
      on_yank = false,
    },
  })
end

M.tmux = function()
  require("tmux").setup({
    copy_sync = {
      -- sync registers *, +, unnamed, and 0 till 9 from tmux in advance
      enable = false,
    },
    navigation = {
      -- enables default keybindings (C-hjkl) for normal mode
      enable_default_keybindings = true,
    },
    resize = {
      -- enables default keybindings (A-hjkl) for normal mode
      enable_default_keybindings = true,
    },
  })
end

M.rest_nvim = function()
  require("rest-nvim").setup({})
end

return M
