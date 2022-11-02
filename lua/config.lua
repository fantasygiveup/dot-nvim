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
  -- NOTE! Temporary disabled to avoid fzf-todo open file issue.
  -- vim.g.lf_netrw = 1

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
  vim.o.background = require("internal").system_background()
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
      theme = "onedark",
      section_separators = { left = "", right = "" },
      component_separators = { left = "", right = "" },
    },
    sections = {
      lualine_a = { "mode", spell },
      lualine_x = {
        { lsp_active_client },
        "encoding",
        "fileformat",
        "filetype",
      },
      lualine_y = {
        "progress",
        {
          "diagnostics",
          sources = { "ale" },
          sections = { "error", "warn" },
          symbols = { error = " ", warn = "  " },
        },
      },
    },
  })
end

M.todo_comments = function()
  require("todo-comments").setup({
    signs = false,
  })
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
      add = { hl = "GitSignsAdd", text = "▌", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
      change = {
        hl = "GitSignsChange",
        text = "▌",
        numhl = "GitSignsChangeNr",
        linehl = "GitSignsChangeLn",
      },
      delete = {
        hl = "GitSignsDelete",
        text = "▌",
        numhl = "GitSignsDeleteNr",
        linehl = "GitSignsDeleteLn",
      },
      topdelete = {
        hl = "GitSignsDelete",
        text = "▌",
        numhl = "GitSignsDeleteNr",
        linehl = "GitSignsDeleteLn",
      },
      changedelete = {
        hl = "GitSignsChange",
        text = "▌",
        numhl = "GitSignsChangeNr",
        linehl = "GitSignsChangeLn",
      },
    },
    attach_to_untracked = false, -- don't highlight new files
  })
end

M.next_hunk = function()
  if vim.o.diff then
    vim.fn.execute("normal! ]czz")
    return
  end
  require("gitsigns.actions").next_hunk()
  vim.fn.execute("normal! zz")
end

M.prev_hunk = function()
  if vim.o.diff then
    vim.fn.execute("normal! [czz")
    return
  end
  require("gitsigns.actions").prev_hunk()
  vim.fn.execute("normal! zz")
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

  local function on_attach(client, bufnr)
    -- Disable diagnostic handlers.
    if client.name == "tsserver" then
      vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end
      vim.lsp.diagnostic.set_signs = function() end
    end

    lsp_highlight_document(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    require("keymap").lsp(client, bufnr)
  end

  local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  local config = {
    virtual_text = false,
    signs = {
      active = signs,
    },
    update_in_insert = true,
    underline = true,
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

  vim.diagnostic.config(config)

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
  })

  local nvim_lsp = require("lspconfig")
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

  local servers = { "ccls", "gopls", "pyright", "tsserver" }
  for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
  end
end

M.luasnip = function()
  require("snippets")
end

M.cmp = function()
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
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-u>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm({ select = true }),
      ["<Tab>"] = function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end,
      ["<S-Tab>"] = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end,
    },
    sources = {
      { name = "luasnip", priority = 9 },
      { name = "nvim_lsp", priority = 8 },
      { name = "nvim_lua", priority = 7 },
      { name = "buffer", priority = 6 },
      { name = "tmux", option = { all_panes = true, label = "" }, priority = 6 },
      { name = "path", priority = 5 },
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
    ensure_installed = {
      "go",
      "javascript",
      "yaml",
      "json",
      "lua",
      "clojure",
      "commonlisp",
      "scheme",
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

M.dressing = function()
  require("dressing").setup({
    select = {
      backend = { "builtin" },
    },
  })
end

M.null_ls = function()
  local null_ls = require("null-ls")

  -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
  local diagnostics = null_ls.builtins.diagnostics
  -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
  local formatting = null_ls.builtins.formatting

  local gl = require("global")
  local config_dir = os.getenv("HOME") .. gl.path_sep .. ".config" .. gl.path_sep
  local yamllint_path = config_dir .. "yamllint" .. gl.path_sep .. "config.yaml"

  null_ls.setup({
    on_attach = function(client, bufnr)
      require("keymap").lsp(client, bufnr)
    end,
    debug = false,
    sources = {
      diagnostics.golangci_lint,
      diagnostics.yamllint.with({ extra_args = { "-c", yamllint_path } }),
      diagnostics.shellcheck,
      diagnostics.eslint,
      formatting.gofumpt,
      formatting.golines,
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

return M
