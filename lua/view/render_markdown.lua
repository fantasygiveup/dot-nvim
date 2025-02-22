local M = {}

M.config = function()
  require("render-markdown").setup({
    file_types = { "markdown" },
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
      backgrounds = {
        "RenderMarkdownH1Bg",
        "RenderMarkdownH2Bg",
        "RenderMarkdownH3Bg",
        "RenderMarkdownH4Bg",
        "RenderMarkdownH5Bg",
        "RenderMarkdownH6Bg",
      },
      foregrounds = {
        "RenderMarkdownH1",
        "RenderMarkdownH2",
        "RenderMarkdownH3",
        "RenderMarkdownH4",
        "RenderMarkdownH5",
        "RenderMarkdownH6",
      },
    },
    code = { highlight_inline = "none" },
  })
end

return M
