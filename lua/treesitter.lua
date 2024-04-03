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
          ["aa"] = { query = "@attribute.outer", desc = "Select outer part attribute region" },
          ["ia"] = { query = "@attribute.inner", desc = "Select innter part attribute region" },
          ["as"] = { query = "@class.outer", desc = "Select outer part of a class region" },
          ["is"] = { query = "@class.inner", desc = "Select inner part of a class region" },
          ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
        },
        include_surrounding_whitespace = true,
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          ["]f"] = { query = "@call.outer", desc = "Next function call start" },
          ["]f"] = { query = "@function.outer", desc = "Next method/function def start" },
          ["]s"] = { query = "@class.outer", desc = "Next class start" },
          ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
          ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
        },
        goto_next_end = {
          ["]F"] = { query = "@call.outer", desc = "Next function call end" },
          ["]F"] = { query = "@function.outer", desc = "Next method/function def end" },
          ["]S"] = { query = "@class.outer", desc = "Next class end" },
        },
        goto_previous_start = {
          ["[f"] = { query = "@call.outer", desc = "Prev function call start" },
          ["[f"] = { query = "@function.outer", desc = "Prev method/function def start" },
          ["[s"] = { query = "@class.outer", desc = "Prev class start" },
          ["[s"] = { query = "@scope.outer", query_group = "locals", desc = "Previous scope" },
          ["[z"] = { query = "@fold.outer", query_group = "folds", desc = "Previous fold" },
        },
        goto_previous_end = {
          ["[F"] = { query = "@call.outer", desc = "Prev function call end" },
          ["[F"] = { query = "@function.outer", desc = "Prev method/function def end" },
          ["[S"] = { query = "@class.outer", desc = "Prev class end" },
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ["<localleader>ff"] = "@call.outer",
          ["<localleader>ff"] = "@function.outer",
          ["<localleader>fs"] = "@class.outer",
          ["<localleader>fs"] = "@scope.outer",
          ["<localleader>fz"] = "@fold",
        },
        swap_previous = {
          ["<localleader>fF"] = "@call.outer",
          ["<localleader>fF"] = "@function.outer",
          ["<localleader>fS"] = "@class.outer",
          ["<localleader>fS"] = "@scope.outer",
          ["<localleader>fZ"] = "@fold",
        },
      },
    },
    ensure_installed = {
      "bash",
      "clojure",
      "comment",
      "commonlisp",
      "cpp",
      "css",
      "dart",
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
      "xml",
      "yaml",
    },
  })

  vim.g.markdown_folding = 0

  require("keymap").tree_sitter()
end

return M
