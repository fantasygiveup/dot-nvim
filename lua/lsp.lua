local M = {}

M.config = function()
  local lspconfig = require("lspconfig")
  local cmp_nvim_lsp = require("cmp_nvim_lsp")

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

    require("keymap").lsp_diagnostic(bufnr)
    require("keymap").lsp_flow()
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
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
  local servers = {
    "ccls",
    "gopls",
    "pyright",
    "ts_ls",
    "rust_analyzer",
    "lua_ls",
    "cssls",
    "nixd",
    "terraformls",
  }
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

  lspconfig.zk.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { "zk", "lsp" },
    name = "zk",
  })

  lspconfig.tailwindcss.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "html", "elixir", "eelixir", "heex" },
    init_options = {
      userLanguages = {
        elixir = "html-eex",
        eelixir = "html-eex",
        heex = "html-eex",
      },
    },
    settings = {
      tailwindCSS = {
        experimental = {
          classRegex = {
            'class[:]\\s*"([^"]*)"',
          },
        },
      },
    },
  })

  lspconfig.emmet_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = {
      "css",
      "html",
      "javascript",
      "javascriptreact",
      "less",
      "sass",
      "scss",
      "heex",
      "elixir",
    },
    init_options = {
      html = {
        options = {
          -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
          ["bem.enabled"] = true,
        },
      },
    },
  })

  lspconfig.dartls.setup({
    cmd = { "dart", "language-server", "--protocol=lsp" },
    filetypes = { "dart" },
    init_options = {
      closingLabels = true,
      flutterOutline = true,
      onlyAnalyzeProjectsWithOpenFiles = true,
      outline = true,
      suggestFromUnimportedLibraries = true,
    },
    -- root_dir = root_pattern("pubspec.yaml"),
    settings = {
      dart = {
        completeFunctionCalls = true,
        showTodos = true,
      },
    },
    on_attach = on_attach,
  })
end

return M
