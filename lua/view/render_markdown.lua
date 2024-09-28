local M = {}

M.config = function()
  require("render-markdown").setup({
    file_types = { "markdown", "quarto" },
    render_modes = { "n", "v", "i", "c" },
    code = {
      sign = false,
      style = "normal",
    },
    sign = {
      enabled = false,
    },
    heading = {
      icons = { " ", " ", " ", " ", " ", " " },
    },
  })
end

return M
