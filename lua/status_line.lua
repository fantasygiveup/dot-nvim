local M = {}

M.config = function()
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

  local function lsp_active_clients(msg)
    local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
    local clients = vim.lsp.get_active_clients()
    local str = ""
    if next(clients) == nil then
      return str
    end

    local unique_clients = {} -- handle the case when several projects are opened
    for _, client in ipairs(clients) do
      local filetypes = client.config.filetypes
      if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
        if unique_clients[client.name] == nil then
          if string.len(str) > 0 then
            str = str .. " "
          end
          str = str .. client.name
          unique_clients[client.name] = true
        end
      end
    end
    if string.len(str) > 0 then
      str = "[" .. str .. "]"
    end
    return str
  end

  local function diagnostics_severity()
    local severity = require("vars").diagnostic_severity
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
          diagnostics_color = {
            error = "MiniStatuslineModeReplace", -- red background
            warn = "MiniStatuslineModeCommand", -- yellow background
          },
        },
        "branch",
      },
      lualine_x = {
        { lsp_active_clients, color = { fg = vim.g.terminal_color_6 } },
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

return M
