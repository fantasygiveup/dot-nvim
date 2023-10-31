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
      "make",
      "rust",
      "http",
      "comment",
      "typescript",
      "tsx",
      "org",
      "elixir",
      "heex", -- elixir templates
      "jsonc",
    },
  })

  vim.g.markdown_folding = 1 -- enable markdown folding
end

return M
