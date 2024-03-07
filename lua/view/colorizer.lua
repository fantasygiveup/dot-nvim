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
    },
    user_default_options = {
      mode = "virtualtext",
      tailwind = true,
    },
  })

  require("keymap").colorizer()
end

return M
