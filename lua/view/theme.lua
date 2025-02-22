local M = {}

M.config = function()
  M.load_background()

  require("catppuccin").setup({
    background = { -- :h background
      light = "latte",
      dark = "mocha",
    },
    no_underline = true,
    custom_highlights = function(colors)
      return {
        Folded = { bg = colors.base },
        -- Override render_markdown.
        RenderMarkdownH1Bg = { bg = colors.base },
        RenderMarkdownH2Bg = { bg = colors.base },
        RenderMarkdownH3Bg = { bg = colors.base },
        RenderMarkdownH4Bg = { bg = colors.base },
        RenderMarkdownH5Bg = { bg = colors.base },
        RenderMarkdownH6Bg = { bg = colors.base },
        -- Override nvim-notify.
        NotifyINFOTitle = { fg = colors.green },
        NotifyINFOIcon = { fg = colors.green },
        NotifyINFOBorder = { fg = colors.green },
        ["@markup.link"] = { fg = colors.surface2 },
        ["@markup.link.url"] = { fg = colors.surface2 },
        ["@conceal"] = { fg = colors.surface2 },
        ["@markup.raw"] = { fg = colors.sapphire },
      }
    end,
  })
end

M.system_theme = function(theme_file)
  local fd = io.open(theme_file)
  local theme = fd:read()
  fd:close()
  return theme
end

M.load_background = function()
  local system_theme_file = require("vars").system_theme_file
  vim.o.background = M.system_theme(system_theme_file)
end

M.init = function()
  vim.cmd.colorscheme("catppuccin")
end

return M
