local M = {}

M.config = function()
  require("colorizer").setup({
    filetypes = {
      css = {},
      heex = { names = false },
      elixir = { names = false },
      eelixir = { names = false },
      html = { names = false },
      cmp_menu = { always_update = true, mode = "background" },
      cmp_docs = { always_update = true, mode = "background" },
    },
    user_default_options = {
      mode = "virtualtext",
      tailwind = true,
      css_fn = true, -- rgb() and hsl() detection
    },
  })

  require("keymap").colorizer()
end

return M
