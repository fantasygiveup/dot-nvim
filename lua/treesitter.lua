local M = {}

M.config = function()
  require("nvim-treesitter.configs").setup({
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = true,
    },
    autotag = {
      enable = true,
    },
    indent = {
      enable = true,
    },
    textobjects = {
      select = {
        enable = true,
        keymaps = {
          ["af"] = { query = "@function.outer", desc = "Select outer part function region" },
          ["if"] = { query = "@function.inner", desc = "Select innter part function region" },
          ["ac"] = { query = "@class.outer", desc = "Select outer part of a class region" },
          ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
          ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
        },
        include_surrounding_whitespace = true,
      },
    },
    ensure_installed = {
      "bash",
      "clojure",
      "comment",
      "commonlisp",
      "cpp",
      "css",
      "elixir",
      "elm",
      "fennel",
      "go",
      "heex", -- elixir templates
      "html",
      "http",
      "javascript",
      "json",
      "jsonc",
      "lua",
      "make",
      "markdown",
      "markdown_inline",
      "nix",
      "org",
      "python",
      "query",
      "regex",
      "ruby",
      "rust",
      "scheme",
      "sql",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "yaml",
    },
  })

  vim.g.markdown_folding = 0
end

return M
