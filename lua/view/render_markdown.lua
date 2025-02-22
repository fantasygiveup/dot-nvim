local M = {}

M.config = function()
  require("render-markdown").setup({
    file_types = { "markdown" },
    render_modes = { "n", "v", "i", "c" },
    code = { sign = false, style = "normal" },
    sign = { enabled = false },
    heading = { icons = { " ", " ", " ", " ", " ", " " } },
    code = { highlight_inline = "none" },
    anti_conceal = { enabled = false },
  })
end

return M
