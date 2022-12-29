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
  vim.g.lf_netrw = 1 -- use lf over netrw

  require("lf").setup({
    winblend = 0, -- disable transparency
    border = "single",
    height = 1.0,
    width = 1.0,
  })
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

M.lsp = function()
  local function lsp_highlight_document(client, bufnr)
    if client.server_capabilities.documentHighlightProvider then
      local group = vim.api.nvim_create_augroup("document_highlight_group", { clear = true })

      vim.api.nvim_create_autocmd({ "CursorHold" }, {
        group = group,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.document_highlight()
        end,
      })

      vim.api.nvim_create_autocmd({ "CursorMoved" }, {
        group = group,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.clear_references()
        end,
      })
    end
  end

  local diagnostic_config = {
    virtual_text = false,
    signs = {
      active = {
        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
      },
      severity = vim.diagnostic.severity.ERROR,
    },
    update_in_insert = true,
    underline = { severity = vim.diagnostic.severity.ERROR },
    severity_sort = true,
    float = {
      focusable = false,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  }

  for _, sign in ipairs(diagnostic_config.signs.active) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  local function on_attach(client, bufnr)
    lsp_highlight_document(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    require("keymap").lsp(client, bufnr)
  end

  vim.lsp.handlers["textDocument/publishDiagnostics"] =
  vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, diagnostic_config)

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
  })
  vim.diagnostic.config(diagnostic_config)

  local nvim_lsp = require("lspconfig")
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

  -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
  local servers = { "ccls", "gopls", "pyright", "tsserver", "clojure_lsp" }
  for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
  end

  -- See https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#sumneko_lua.
  nvim_lsp.sumneko_lua.setup({
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        diagnostics = { globals = { "vim" } },
        workspace = { library = vim.api.nvim_get_runtime_file("", true) },
        telemetry = { enable = false },
      },
    },
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

M.luasnip = function()
  require("snippets")
end

M.cmp = function()
  local function has_words_before()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0
        and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end

  local cmp = require("cmp")
  local luasnip = require("luasnip")
  local lspkind = require("lspkind")
  cmp.setup({
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = {
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<Up>"] = cmp.mapping.select_prev_item(),
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<Down>"] = cmp.mapping.select_next_item(),
      ["<C-u>"] = cmp.mapping.scroll_docs(-4),
      ["<C-d>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" }),

      ["<S-Tab>"] = cmp.mapping(function()
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        end
      end, { "i", "s" }),
    },
    sources = {
      { name = "luasnip", priority = 9 },
      { name = "nvim_lsp", priority = 8 },
      { name = "nvim_lua", priority = 7 },
      { name = "buffer", priority = 6 },
      { name = "tmux", option = { all_panes = true, label = "" }, priority = 6 },
      { name = "path", priority = 5 },
      { name = "calc", priority = 5 },
    },
    preselect = cmp.PreselectMode.None,
    completion = {
      completeopt = "menu,menuone,noinsert",
    },
    formatting = {
      format = lspkind.cmp_format({
        mode = "symbol",
        maxwidth = 50,
      }),
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
      formatting.zprint, -- clojure formatter
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

M.dap = function()
  ok, dap = pcall(require, "dap")
  if not ok then
    return
  end
  dap.adapters.delve = {
    type = "server",
    port = "${port}",
    executable = {
      command = "dlv",
      args = { "dap", "-l", "127.0.0.1:${port}" },
    },
  }

  -- 'dlv' binary is required.
  dap.configurations.go = {
    {
      type = "delve",
      name = "Debug",
      request = "launch",
      program = "${file}",
    },
    {
      type = "delve",
      name = "Debug test",
      request = "launch",
      mode = "test",
      program = "./${relativeFileDirname}",
    },
  }

  vim.fn.sign_define("DapBreakpoint", { text = "✴" })
  vim.fn.sign_define("DapBreakpointCondition", { text = "" })
  vim.fn.sign_define("DapLogPoint", { text = "" })
  vim.fn.sign_define("DapStopped", { text = "ﭥ" })
  vim.fn.sign_define("DapBreakpointRejected", { text = "" })

  ok, dapui = pcall(require, "dapui")
  if not ok then
    return
  end

  dapui.setup()
end

M.which_key = function()
  require("which-key").setup({
    layout = { height = { min = 4, max = 15 } },
  })
end

M.dashboard = function()
  local db = require("dashboard")
  db.custom_header = {
    " ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
    " ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
    " ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
    " ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
    " ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
    " ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
  }
  db.custom_center = {
    {
      icon = "  ",
      desc = "Switch project                         ",
      shortcut = "<leader>pp",
      action = "lua require'fzf_projects'.navigate()",
    },
    {
      icon = "  ",
      desc = "Find File                              ",
      action = "lua require'fzf-lua'.files()",
      shortcut = "<leader>pf",
    },
    {
      icon = "  ",
      desc = "New Buffer                        ",
      action = "DashboardNewFile",
      shortcut = "<localleader>bn",
    },
    {
      icon = "  ",
      desc = "File Browser                                    ",
      action = "nohlsearch | Lf",
      shortcut = "-",
    },
    {
      icon = "  ",
      desc = "Recently opened files             ",
      action = "lua require'fzf-lua'.oldfiles()",
      shortcut = "<localleader>fr",
    },
    {
      icon = "  ",
      desc = "Rebuild plugins                        ",
      action = "PackerCompile",
      shortcut = "<leader>pc",
    },
    {
      icon = "痢 ",
      desc = "Sync plugins remote                    ",
      action = "PackerSync",
      shortcut = "<leader>ps",
    },
    {
      icon = "  ",
      desc = "Dashboard                         ",
      action = "Dashboard",
      shortcut = "<localleader>gh",
    },
  }
end

M.todo_comments = function()
  require("todo-comments").setup({
    signs = false,
    merge_keywords = false,
    highlight = {
      keyword = "fg",
      after = "",
      pattern = [[.*<(KEYWORDS)\s*(\(.*\))?\s*:]],
    },
  })
end

M.parinfer = function() end

M.conjure = function()
  vim.g["conjure#mapping#def_word"] = { "gd" }
end

return M
