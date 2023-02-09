local M = {}

M.global = function()
  vim.g.loaded_python3_provider = 0
  vim.g.loaded_ruby_provider = 0
  vim.g.loaded_node_provider = 0
  vim.g.loaded_perl_provider = 0
end

local function disable_distribution_plugins()
  vim.g.omni_sql_no_default_maps = 1
end

disable_distribution_plugins()

M.comment_nvim = function()
  require("Comment").setup({})
end

M.nvim_surround = function()
  require("nvim-surround").setup({})
end

M.theme = function()
  vim.o.background = os.getenv("SYSTEM_COLOR_THEME")
  require("onedark").setup({
    style = vim.o.background,
    highlights = { QuickFixLine = { fmt = "none" } }, -- overrides
  })
  require("onedark").load()
end

M.status_line = function()
  local function spell()
    if not vim.o.spell then
      return ""
    end
    return "SPELL[" .. vim.o.spelllang .. "]"
  end

  local function lsp_active_client(msg)
    local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
    local clients = vim.lsp.get_active_clients()
    if next(clients) == nil then
      return ""
    end

    for _, client in ipairs(clients) do
      local filetypes = client.config.filetypes
      if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
        return " " .. client.name
      end
    end
    return ""
  end

  local ll = require("lualine")
  ll.setup({
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
          sections = require("internal").diagnostic_severity(),
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

M.colorizer = function()
  require("colorizer").setup({
    DEFAULT_OPTIONS = {
      names = false,
    },
  })
end

M.autopairs = function()
  require("nvim-autopairs").setup()
end

M.project_nvim = function()
  local project_nvim = require("project_nvim").setup({
    patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "go.mod" },
    detection_methods = { "pattern", "lsp" },
  })
end

M.yanky = function()
  require("yanky").setup({
    highlight = {
      on_put = false,
      on_yank = false,
    },
  })
end

M.null_ls = function()
  local null_ls = require("null-ls")

  -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
  local diagnostics = null_ls.builtins.diagnostics
  -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
  local formatting = null_ls.builtins.formatting

  local global = require("global")
  local config_dir = os.getenv("HOME") .. global.path_sep .. ".config" .. global.path_sep
  local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

  null_ls.setup({
    on_attach = function(client, bufnr)
      if client.supports_method("textDocument/formatting") then
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = augroup,
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format({ bufnr = bufnr })
          end,
        })
      end
    end,
    debug = false,
    sources = {
      diagnostics.golangci_lint,
      diagnostics.yamllint.with({
        extra_args = { "-c", config_dir .. "yamllint" .. global.path_sep .. "config.yaml" },
      }),
      diagnostics.shellcheck,
      diagnostics.eslint,
      formatting.goimports,
      formatting.golines.with({ extra_args = { "--max-len=150" } }),
      formatting.stylua.with({
        extra_args = {
          "--config-path=" .. config_dir .. "stylua" .. global.path_sep .. "stylua.toml",
        },
      }),
      formatting.yapf,
      formatting.prettier.with({
        extra_args = function()
          local default_args =
            { "--config=" .. config_dir .. "prettier" .. global.path_sep .. "prettier.config.js" }

          local ok, project_root = pcall(require, "project_nvim.project")
          if not ok then
            return default_args
          end

          local file_names = { ".prettierrc.js", "prettier.config.js" }

          for _, file_name in ipairs(file_names) do
            local conf_path = project_root.get_project_root() .. global.path_sep .. file_name
            local prettierrc_fd = io.open(conf_path, "r")

            if prettierrc_fd ~= nil then
              io.close(prettierrc_fd)
              return { "--config=" .. conf_path }
            end
          end

          return default_args
        end,
      }),
    },
  })
end

M.tmux = function()
  require("tmux").setup({
    copy_sync = {
      -- sync registers *, +, unnamed, and 0 till 9 from tmux in advance
      enable = false,
    },
    navigation = {
      -- enables default keybindings (C-hjkl) for normal mode
      enable_default_keybindings = true,
    },
    resize = {
      -- enables default keybindings (A-hjkl) for normal mode
      enable_default_keybindings = true,
    },
  })
end

M.zen_mode = function()
  require("zen-mode").setup({
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
end

M.which_key = function()
  require("which-key").setup({
    layout = { height = { min = 4, max = 15 } },
  })
end

M.rest_nvim = function()
  require("rest-nvim").setup({})
end

return M
