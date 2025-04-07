local M = {}

M.config = function()
  local lualine = require("lualine")

  local function spelling()
    if not vim.o.spell then
      return ""
    end
    return "📚 " .. vim.o.spelllang .. ""
  end

  local function lsp_active_clients(msg)
    local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
    local clients = vim.lsp.get_clients()
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

  local flavour = require("catppuccin").flavour
  local clrs = require("catppuccin.palettes").get_palette(flavour)

  lualine.setup({
    options = {
      theme = "catppuccin",
      component_separators = "",
      section_separators = { left = "", right = "" },
    },
    sections = {
      lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
      lualine_b = { "filename", "branch" },
      lualine_c = {
        "%=",
        {
          spelling,
          color = { bg = clrs.surface0, fg = clrs.red },
          separator = { right = "", left = "" },
        },
      },
      lualine_x = {
        {
          lsp_active_clients,
          separator = { right = "", left = "" },
          right_padding = 2,
          color = { bg = clrs.surface0, fg = clrs.yellow },
        },
        "encoding",
      },
      lualine_y = { "filetype", "progress" },
      lualine_z = {
        { "location", separator = { right = "" }, left_padding = 2 },
      },
    },
    inactive_sections = {
      lualine_a = { "filename" },
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = { "location" },
    },
    tabline = {},
    extensions = {},
  })
end

return M
