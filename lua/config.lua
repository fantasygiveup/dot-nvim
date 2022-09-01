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
  require('fzf-lua').setup({
    winopts = {
      fullscreen = true,
      preview = {
        vertical       = 'down:50%',
        horizontal     = 'right:50%',
        flip_columns   = 160,
        scrollbar      = false,
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

function config.lualine()

  -- lualine uses a theme.
  require('github-theme').setup()

  local function spell()
    if not vim.o.spell then
      return ""
    end
    return "SPELL[" .. vim.o.spelllang .. "]"
  end

  local function lsp_active_client(msg)
    local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
    local clients = vim.lsp.get_active_clients()
    if next(clients) == nil then
      return ""
    end

    for _, client in ipairs(clients) do
      local filetypes = client.config.filetypes
      if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
        return "lsp:" .. client.name
      end
    end
    return ""
  end

  local ll = require("lualine")
  ll.setup({
    options = {
      theme = "auto",
      section_separators = {left = "", right = ""},
      component_separators = {left = "", right = ""},
    },
    sections = {
      lualine_a = { "mode", spell },
      lualine_x = {
        { lsp_active_client, color = { fg = vim.api.nvim_get_hl_by_name("Function", false).foreground } },
        "encoding",
        "fileformat",
        "filetype",
      },
      lualine_y = {
        "progress",
        { "diagnostics",
          sources = { "ale" },
          sections = { "error", "warn" },
          symbols = { error = " ", warn = "  "},
        },
      },
    }
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
      add          = { hl = "GitSignsAdd"   , text = "▌", numhl="GitSignsAddNr"   , linehl="GitSignsAddLn" },
      change       = { hl = "GitSignsChange", text = "▌", numhl="GitSignsChangeNr", linehl="GitSignsChangeLn" },
      delete       = { hl = "GitSignsDelete", text = "▌", numhl="GitSignsDeleteNr", linehl="GitSignsDeleteLn" },
      topdelete    = { hl = "GitSignsDelete", text = "▌", numhl="GitSignsDeleteNr", linehl="GitSignsDeleteLn" },
      changedelete = { hl = "GitSignsChange", text = "▌", numhl="GitSignsChangeNr", linehl="GitSignsChangeLn" },
    },
    attach_to_untracked = false,  -- don't highlight new files
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

function config.toggle_diagnostics_sign()
  if not vim.g.ale_enabled then
    return
  end

  -- toggle 0 and -1
  vim.g.ale_max_signs = -1 - vim.g.ale_max_signs
  vim.cmd("ALEDisable | ALEEnable")
end

function config.ale()
  vim.g.ale_set_highlights = 0
  vim.g.ale_linters_explicit = 1
  vim.g.ale_lint_on_save = 1
  vim.g.ale_sign_error = ""
  vim.g.ale_sign_warning = ""
  vim.g.ale_sign_info = ""
  vim.g.ale_sign_style_error = ""
  vim.g.ale_sign_style_warning = ""
  vim.g.ale_fix_on_save = 1
  vim.g.ale_max_signs = 0

  vim.g.ale_linters = {
    go = { "gopls" },
    javascript = { "eslint" },
    yaml = { "yamllint" },
    sh = { "shellcheck" },
    lua = { "luacheck" },
    elm = { "make" },
    python = { "flake8" },
  }

  vim.g.ale_fixers = {
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    css = { "prettier" },
    elm = { "elm-format" },
    python = { "yapf" },
  }
end

function config.go()
  require("go").setup()
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
    }
  })
end

function config.lsp()
  -- The function must be a global one to be found by lsp.setup().
  local function on_attach(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    -- Don't show diagnostics hints.
    vim.lsp.handlers["textDocument/publishDiagnostics"] = function() end
    -- Don't show diagnostics signs.
    vim.lsp.diagnostic.set_signs = function() end

    local opts = { noremap = true, silent = true }
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<Cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gh", "<Cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "i", "<C-h>", "<Cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<Cmd>lua vim.lsp.buf.references()<CR>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gR", "<Cmd>lua vim.lsp.buf.rename()<CR>", opts)
  end

  local nvim_lsp = require("lspconfig")
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

  local servers = { "clangd", "gopls", "pyright", "tsserver", "elmls" }
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
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm { select = true },
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
      { name = "tmux", option = { all_panes = true, label = "", }, priority = 6 },
      { name = "path", priority = 5 },
    },
    preselect = cmp.PreselectMode.None,
    completion = {
      completeopt = "menu,menuone,noinsert",
      autocomplete = false,
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
      names = false;
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
      }
  })
end

function config.dressing()
  require("dressing").setup({
    select = {
      backend = { "builtin" },
    },
  })
end

return config
