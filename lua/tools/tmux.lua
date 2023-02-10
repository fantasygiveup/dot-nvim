local M = {}

M.setup = function(use)
  use({ "aserowy/tmux.nvim", config = M.tmux })
end

M.tmux = function()
  local ok, tmux = pcall(require, "tmux")
  if not ok then
    return
  end

  tmux.setup({
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

return M
