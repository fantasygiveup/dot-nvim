local M = {}

M.config = function()
  local dressing = require("dressing").setup({
    input = {
      get_config = function(opts)
        return opts
      end,
    },
  })

  local fzf_lua = require("fzf-lua")
  local keymap = require("keymap")

  fzf_lua.setup({
    winopts = {
      fullscreen = true,
      number = false,
      preview = {
        vertical = "down:50%",
        horizontal = "right:50%",
        flip_columns = 160,
      },
    },
    keymap = {
      builtin = keymap.fzf_builtin(),
      fzf = {},
    },
  })

  keymap.fzf()
end

return M
