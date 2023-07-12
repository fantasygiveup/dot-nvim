local M = {}

M.cmp_config = function()
  local ok, cmp = pcall(require, "cmp")
  if not ok then
    return
  end
  local ok, luasnip = pcall(require, "luasnip")
  if not ok then
    return
  end

  local ok, _ = pcall(require, "snippets")
  if not ok then
    return
  end

  local function has_words_before()
    unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0
      and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
  end

  cmp.setup({
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-n>"] = cmp.mapping.select_next_item({ behavior = "select", count = 1 }),
      ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = "select", count = 1 }),
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = "nvim_lsp" },
      { name = "luasnip" },
    }, {
      { name = "buffer" },
      { name = "tmux", option = { all_panes = true, label = "" } },
      { name = "path" },
      { name = "calc" },
    }),
  })
end

M.lsp_config = function()
  local ok, lspconfig = pcall(require, "lspconfig")
  if not ok then
    return
  end
  local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if not ok then
    return
  end

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
        -- Disable signs.
        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
      },
      severity = require("vars").diagnostic_severity,
    },
    update_in_insert = true,
    underline = false,
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

    local opts = { noremap = true, silent = true }

    vim.api.nvim_buf_set_keymap(
      bufnr,
      "n",
      "]d",
      "<cmd>lua vim.diagnostic.goto_next({ severity = require'vars'.diagnostic_severity })<cr>",
      opts
    )
    vim.api.nvim_buf_set_keymap(
      bufnr,
      "n",
      "[d",
      "<cmd>lua vim.diagnostic.goto_prev({ severity = require'vars'.diagnostic_severity })<cr>",
      opts
    )
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gh", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
    vim.api.nvim_buf_set_keymap(
      bufnr,
      "i",
      "<C-h>",
      "<cmd>lua vim.lsp.buf.signature_help()<cr>",
      opts
    )
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "gn", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
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

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

  -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
  local servers = { "ccls", "gopls", "pyright", "tsserver", "rust_analyzer", "lua_ls", "cssls" }
  for _, lsp in ipairs(servers) do
    lspconfig[lsp].setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
  end

  lspconfig.elixirls.setup({
    cmd = { "elixir-ls" },
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

M.config = function()
  M.cmp_config()
  M.lsp_config()
end

return M
