local M = {}

M.config = function()
  local ok, colorizer = pcall(require, "colorizer")
  if not ok then
    return
  end

  colorizer.setup({
    filetypes = {
      heex = { names = true },
      elixir = { names = true },
      html = { names = false },
      cmp_menu = { always_update = true, mode = "background" },
      cmp_docs = { always_update = true, mode = "background" },
    },
    user_default_options = {
      mode = "virtualtext",
      tailwind = true,
    },
  })

  require("keymap").colorizer()
end

return M
