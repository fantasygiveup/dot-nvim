local M = {}

M.setup = function(use)
  use({ "navarasu/onedark.nvim", config = M.theme_setup })
  use({ "folke/which-key.nvim", config = M.which_key_setup })
  use({ "nvim-lualine/lualine.nvim", config = M.status_line_setup })
  use({ "folke/zen-mode.nvim", config = M.zen_mode_setup })
end

M.theme_setup = function()
  local ok, onedark = pcall(require, "onedark")
  if not ok then
    return
  end

  vim.o.background = os.getenv("SYSTEM_COLOR_THEME")

  onedark.setup({
      style = vim.o.background,
      highlights = { QuickFixLine = { fmt = "none" } }, -- overrides
  })
  onedark.load()
end

M.which_key_setup = function()
  local ok, which_key = pcall(require, "which-key")
  if not ok then
    return
  end

  which_key.setup({
      layout = { height = { min = 4, max = 15 } },
  })
end

M.status_line_setup = function()
  local ok, lualine = pcall(require, "lualine")
  if not ok then
    return
  end

  local function spell()
    if not vim.o.spell then
      return ""
    end
    return "SPELL[" .. vim.o.spelllang .. "]"
  end

  local function lsp_active_client(msg)
    local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
    local clients = vim.lsp.get_active_clients()
    local str = ""
    if next(clients) == nil then
      return str
    end

    for _, client in ipairs(clients) do
      local filetypes = client.config.filetypes
      if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
        if string.len(str) > 0 then
          str = str .. " "
        end
        str = str .. client.name
      end
    end
    if string.len(str) > 0 then
      str = " [" .. str .. "]"
    end
    return str
  end

  local function diagnostics_severity()
    local severity = require("global").diagnostic_severity
    if severity == vim.diagnostic.severity.ERROR then
      return { "error" }
    end
    if severity == vim.diagnostic.severity.WARN then
      return { "error", "warn" }
    end
    if severity == vim.diagnostic.severity.INFO then
      return { "error", "warn", "info" }
    end
    if severity == vim.diagnostic.severity.HINT then
      return { "error", "warn", "info", "hint" }
    end
  end

  lualine.setup({
      options = {
          theme = "auto",
          section_separators = { left = "", right = "" },
          component_separators = { left = "", right = "" },
      },
      sections = {
          lualine_a = { "mode", spell },
          lualine_b = {
              {
                  "diagnostics",
                  sources = { "nvim_diagnostic" },
                  sections = diagnostics_severity(),
                  symbols = { error = " ", warn = " ", info = " ", hint = " " },
              },
          },
          lualine_x = {
              { lsp_active_client },
              "encoding",
              "fileformat",
              "filetype",
          },
          lualine_y = {
              "progress",
          },
      },
  })
end

M.zen_mode_setup = function()
  local ok, zen_mode = pcall(require, "zen-mode")
  if not ok then
    return
  end

  zen_mode.setup({
      window = {
          backdrop = 1.0,
          width = 80,
          options = {
              wrap = true,
              signcolumn = "no",
              number = false,
              relativenumber = false,
              cursorline = false,
              cursorcolumn = false,
              foldcolumn = "0",
              list = false,
          },
      },
  })

  vim.keymap.set(
      "n",
      "<localleader>z",
      "<cmd>lua require'frontend'.zen_mode()<cr>",
      { desc = "zen_mode_toggle" }
  )
end

M.zen_mode = function(extra_width, direction)
  local ok, view = pcall(require, "zen-mode.view")
  if not ok then
    return
  end
  local extra_width = extra_width or 0
  local direction = direction or 0

  local fn = view.toggle
  if direction > 0 then
    fn = view.open
  elseif direction < 0 then
    fn = view.close
  end

  local opts = {
      window = {
          width = vim.bo.textwidth + extra_width,
      },
  }

  fn(opts)
end

return M
