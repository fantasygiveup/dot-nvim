local config = {}

function config.lf()
  vim.g.lf_map_keys = 0
  vim.g.bclose_no_plugin_maps = 1
end

function config.fzf()
  vim.g.fzf_command_prefix = "Fzf"
  vim.g.fzf_layout = { window = { width = 1.0, height = 1.0 } }
  vim.g.fzf_colors = { gutter =  {"bg", "Normal"} }
  vim.g.fzf_buffers_jump = 1
end

function config.colortheme()
  vim.cmd("colorscheme github_light")
end

function config.gitlinker()
  require("gitlinker").setup({
    mappings = nil, -- don't use default mappings
  })
end

-- See <Plug>(sandwich-add).
function config.sandwich_surround(ch)
  if ch == [["]] then
    ch = [[\"]]
  end
  vim.cmd([[exec "normal v%\<Plug>(sandwich-add)]] .. ch .. [[<CR>"]])
end

function config.lualine()

  local function spell()
    if not vim.o.spell then
      return ""
    end
    return "SPELL[" .. vim.o.spelllang .. "]"
  end

  local function lsp_client(msg)
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
      lualine_x = { lsp_client, "encoding", "fileformat", "filetype" },
      lualine_y = {
        "progress",
        { "diagnostics", sources = { "ale" },
        sections = { "error", "warn" },
        symbols = { error = " ", warn = "  "},
        diagnostics_color = {
          error = "DiffDelete",
          warn  = "DiffChange",
        } },
      },
    }
  })
end

function config.gitsigns()
  require("gitsigns").setup({
    on_attach = function(bufnr)
      if vim.o.diff then
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
    css = { "prettier" },
    elm = { "elm-format" },
    python = { "yapf" },
  }
end

function config.gnupg()
  vim.g.GPGPreferArmor = 1  -- base64 armor message
  vim.g.GPGDefaultRecipients = { "me@eli.net" }
end


function config.go()
  vim.g.go_fmt_fail_silently = 1
  vim.g.go_def_mapping_enabled = 0
  vim.g.go_gopls_enabled = 0
  vim.g.go_template_autocreate = 0
  vim.g.go_echo_command_info = 0
  vim.g.go_echo_go_info = 0
end

-- The function must be a global one to be found by lsp.setup().
function lsp_on_attach(_, bufnr)
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
end

function config.tmux()
  vim.g.tmux_navigator_no_mappings = 1
end

function config.lsp()
  local nvim_lsp = require("lspconfig")
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

  local servers = { "clangd", "gopls", "pyright", "tsserver", "elmls" }
  for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup({
      on_attach = lsp_on_attach,
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
  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = {
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-u>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-g>"] = cmp.mapping.close(),
      ["<CR>"] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      },
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
      { name = "buffer" },
      { name = "path" },
      { name = "nvim_lsp" },
      { name = "luasnip" },
      { name = "tmux", option = { all_panes = true, label = "", } },
      { name = "conjure" },
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

function config.markdown()
  vim.g.vim_markdown_folding_style_pythonic = 1
end

function config.treesitter()
  require("nvim-treesitter.configs").setup({
    highlight = {
      enable = true,
      -- org: required since TS highlighter doesn't support all syntax features (conceal).
      additional_vim_regex_highlighting = { "org" },
    },
    ensure_installed = { "org", "go", "javascript", "yaml", "json", "lua", "clojure", "python" },
  })
end

function config.orgmode()
  require("orgmode").setup_ts_grammar()
end

return config
