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
    },
  })

  vim.g.markdown_folding = 1 -- enable markdown folding
end

return M
