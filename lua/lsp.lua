local M = {}

M.config = function()
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

    require("keymap").lsp_diagnostic(bufnr)
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

return M
