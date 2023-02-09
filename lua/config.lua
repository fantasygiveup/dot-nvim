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

M.lf = function()
  vim.g.lf_replace_netrw = 1 -- use lf over netrw
  vim.g.lf_map_keys = 0
end

M.fzf = function()
  require("fzf-lua").setup({
      winopts = {
          fullscreen = true,
          preview = {
              vertical = "down:50%",
              horizontal = "right:50%",
              flip_columns = 160,
              scrollbar = false,
          },
      },
      keymap = {
          builtin = {
              ["<A-p>"] = "toggle-preview",
              ["<C-f>"] = "preview-page-down",
              ["<C-b>"] = "preview-page-up",
          },
          fzf = {},
      },
  })
end

M.gitlinker = function()
  require("gitlinker").setup({
      mappings = nil, -- don't use default mappings
  })
end

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

M.gitsigns = function()
  require("gitsigns").setup({
      on_attach = function(bufnr)
        if vim.o.diff or vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":e") == "gpg" then
          return false
        end
        return true
      end,
      keymaps = {},
      signs = {
          add = { text = "" },
          change = { text = "" },
          delete = { text = "" },
          topdelete = { text = "" },
          changedelete = { text = "" },
      },
      attach_to_untracked = false, -- don't highlight new files
  })
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

M.treesitter = function()
  require("nvim-treesitter.configs").setup({
      highlight = {
          enable = true,
      },
      rainbow = {
          enable = true,
          disable = { "lua", "jsx", "javascript", "json", "c", "cpp", "go" },
          extended_mode = true,
          max_file_lines = nil,
      },
      ensure_installed = {
          "go",
          "javascript",
          "yaml",
          "json",
          "lua",
          "clojure",
          "commonlisp",
          "scheme",
          "fennel",
          "python",
          "markdown",
          "markdown_inline",
          "elm",
          "bash",
          "vim",
          "html",
          "css",
          "query",
          "ruby",
          "cpp",
          "sql",
          "make",
          "rust",
          "http",
          "comment",
      },
  })

  vim.g.markdown_folding = 1 -- enable markdown folding
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

M.dressing = function()
  require("dressing").setup({
      input = {
          get_config = function(opts)
            return opts
          end,
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

M.icon_picker = function()
  require("icon-picker").setup({})
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
