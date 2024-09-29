local M = {}

M.config = function()
  local ok, theme = pcall(require, "onedark")
  if not ok then
    return
  end

  M.load_background()

  theme.setup({
    style = vim.o.background,
    highlights = {
      QuickFixLine = { fmt = "none" },
      -- Markdown | Zettelkasten.
      ["@markup.link.label"] = { fg = "$blue", fmt = "bold" },
      ["@markup.link"] = { fg = "$grey", fmt = "none" },
      markdownAutomaticLink = { fg = "$cyan", fmt = "bold" },
      ["@markup.link.url"] = { fg = "none", fmt = "none" },
      markdownUrl = { fmt = "none" },
      markdownLink = { fmt = "none" },
      -- render-markdown.
      ["RenderMarkdownH1Bg"] = { bg = "$bg1" },
      ["RenderMarkdownH2Bg"] = { bg = "$bg1" },
      ["RenderMarkdownH3Bg"] = { bg = "$bg1" },
      ["RenderMarkdownH4Bg"] = { bg = "$bg1" },
      ["RenderMarkdownH5Bg"] = { bg = "$bg1" },
      ["RenderMarkdownH6Bg"] = { bg = "$bg1" },
    },
  })
  theme.load()
end

M.listen_to_system_background_change = function()
  local ok, fwatch = pcall(require, "fwatch")
  if not ok then
    return
  end

  fwatch.watch(require("vars").system_theme_file, {
    on_event = function()
      M.load_background_async()
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

M.load_background_async = function()
  require("utils.async").timer(function()
    require("view.theme").load_background()
  end)
end

M.init = function()
  M.listen_to_system_background_change()
end

return M
