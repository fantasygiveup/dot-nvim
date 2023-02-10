local M = {}

M.setup = function(use)
  use({ "jose-elias-alvarez/null-ls.nvim", config = M.null_ls_setup })
end

M.null_ls_setup = function()
  local ok, null_ls = pcall(require, "null-ls")
  if not ok then
    return
  end

  -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
  local diagnostics = null_ls.builtins.diagnostics
  -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
  local formatting = null_ls.builtins.formatting

  local vars = require("vars")
  local config_dir = os.getenv("HOME") .. vars.path_sep .. ".config" .. vars.path_sep
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
        extra_args = { "-c", config_dir .. "yamllint" .. vars.path_sep .. "config.yaml" },
      }),
      diagnostics.shellcheck,
      diagnostics.eslint,
      formatting.goimports,
      formatting.golines.with({ extra_args = { "--max-len=150" } }),
      formatting.stylua.with({
        extra_args = {
          "--config-path=" .. config_dir .. "stylua" .. vars.path_sep .. "stylua.toml",
        },
      }),
      formatting.yapf,
      formatting.prettier.with({
        extra_args = function()
          local default_args =
            { "--config=" .. config_dir .. "prettier" .. vars.path_sep .. "prettier.config.js" }

          local ok, project_root = pcall(require, "project_nvim.project")
          if not ok then
            return default_args
          end

          local file_names = { ".prettierrc.js", "prettier.config.js" }

          for _, file_name in ipairs(file_names) do
            local conf_path = project_root.get_project_root() .. vars.path_sep .. file_name
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

return M
