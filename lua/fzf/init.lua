local M = {}

M.config = function()
  local ok, dressing = pcall(require, "dressing")
  if not ok then
    return
  end

  -- Allow to pass options, e.g. center widget screen.
  dressing.setup({
    input = {
      get_config = function(opts)
        return opts
      end,
    },
  })

  local ok, fzf_lua = pcall(require, "fzf-lua")
  if not ok then
    return
  end

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
