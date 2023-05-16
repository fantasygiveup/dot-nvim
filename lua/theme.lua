local M = {}

M.config = function()
  local ok, theme = pcall(require, "onedark")
  if not ok then
    return
  end

  local ok, fwatch = pcall(require, "fwatch")
  if not ok then
    return
  end

  require("utils.system_theme").load_background()
  fwatch.watch(require("vars").system_theme_file, {
    on_event = function()
      require("utils.system_theme").load_background_async()
    end,
  })

  theme.setup({
    style = vim.o.background,
    highlights = { QuickFixLine = { fmt = "none" } }, -- overrides
  })
  theme.load()
end

return M
