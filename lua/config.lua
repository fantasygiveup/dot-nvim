local config = {}

function config.global()
  vim.g.loaded_python3_provider = 0
  vim.g.loaded_ruby_provider = 0
  vim.g.loaded_node_provider = 0
  vim.g.loaded_perl_provider = 0
end

local function disable_distribution_plugins()
  vim.g.omni_sql_no_default_maps = 1
end
disable_distribution_plugins()

function config.lf()
  vim.g.lf_map_keys = 0
  vim.g.bclose_no_plugin_maps = 1
  vim.g.lf_replace_netrw = 1
end

function config.fzf()
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
      },
      fzf = {},
    },
  })
end

function config.gitlinker()
  require("gitlinker").setup({
    mappings = nil, -- don't use default mappings
  })
end

function config.comment_nvim()
  require("Comment").setup({})
end

function config.nvim_surround()
  require("nvim-surround").setup({})
end

function config.status_line()
  require("github-theme").setup()

  local feline = require("feline")
  feline.setup()

  local int2rgb = require("utils").int2rgb
  local red = vim.api.nvim_get_hl_by_name("DiagnosticSignError", true)
  local yellow = vim.api.nvim_get_hl_by_name("DiagnosticSignWarn", true)
  local cyan = vim.api.nvim_get_hl_by_name("DiagnosticSignHint", true)
  local skyblue = vim.api.nvim_get_hl_by_name("DiagnosticSignInfo", true)
  feline.use_theme({
    red = int2rgb(red.foreground),
    yellow = int2rgb(yellow.foreground),
    cyan = int2rgb(cyan.foreground),
    skyblue = int2rgb(skyblue.foreground),
  })
end

function config.todo_comments()
  require("todo-comments").setup({
    signs = false,
  })
end

function config.gitsigns()
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

function config.next_hunk()
  if vim.o.diff then
    vim.fn.execute("normal! ]c")
    return
  end
  require("gitsigns.actions").next_hunk()
  vim.fn.execute("normal! zz")
end

function config.prev_hunk()
  if vim.o.diff then
    vim.fn.execute("normal! [c")
    return
  end
  require("gitsigns.actions").prev_hunk()
end

function config.tmux()
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

function config.lsp()
  local function on_attach(client, bufnr)
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
  capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

  local servers = { "clangd", "gopls", "pyright", "tsserver" }
  for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
  end
end

function config.luasnip()
  require("snippets")
end

function config.cmp()
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
      ["<C-g>"] = cmp.mapping.abort(),
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

function config.colorizer()
  require("colorizer").setup({
    DEFAULT_OPTIONS = {
      names = false,
    },
  })
end

function config.treesitter()
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
      "elm",
      "bash",
      "vim",
      "html",
      "css",
      "query",
      "ruby",
    },
  })
end

function config.autopairs()
  require("nvim-autopairs").setup()
end

function config.project_nvim()
  require("project_nvim").setup()
end

function config.yanky()
  require("yanky").setup({
    highlight = {
      on_put = false,
      on_yank = false,
    },
  })
end

function config.dressing()
  require("dressing").setup({
    select = {
      backend = { "builtin" },
    },
  })
end

function config.null_ls()
  local null_ls = require("null-ls")

  -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
  local diagnostics = null_ls.builtins.diagnostics

  null_ls.setup({
    on_attach = function(client, bufnr)
      require("keymap").lsp(client, bufnr)
    end,
    debug = false,
    sources = {
      diagnostics.golangci_lint,
      diagnostics.yamllint,
      diagnostics.shellcheck,
    },
  })
end

return config
