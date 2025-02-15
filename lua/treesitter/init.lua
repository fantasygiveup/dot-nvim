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
          ["ae"] = { query = "@function.outer", desc = "select outer part function region" },
          ["ie"] = { query = "@function.inner", desc = "select innter part function region" },
          ["aa"] = { query = "@attribute.outer", desc = "select outer part attribute region" },
          ["ia"] = { query = "@attribute.inner", desc = "select innter part attribute region" },
          ["as"] = { query = "@class.outer", desc = "select outer part of a class region" },
          ["is"] = { query = "@class.inner", desc = "select inner part of a class region" },
          ["as"] = { query = "@scope", query_group = "locals", desc = "select language scope" },
        },
        include_surrounding_whitespace = true,
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          ["]e"] = { query = "@call.outer", desc = "next function call start" },
          ["]e"] = { query = "@function.outer", desc = "next method/function def start" },
          ["]s"] = { query = "@class.outer", desc = "next class start" },
          ["]s"] = { query = "@scope", query_group = "locals", desc = "next scope" },
          ["]z"] = { query = "@fold", query_group = "folds", desc = "next fold" },
        },
        goto_next_end = {
          ["]E"] = { query = "@call.outer", desc = "next function call end" },
          ["]E"] = { query = "@function.outer", desc = "next method/function def end" },
          ["]S"] = { query = "@class.outer", desc = "next class end" },
        },
        goto_previous_start = {
          ["[e"] = { query = "@call.outer", desc = "prev function call start" },
          ["[e"] = { query = "@function.outer", desc = "prev method/function def start" },
          ["[s"] = { query = "@class.outer", desc = "prev class start" },
          ["[s"] = { query = "@scope.outer", query_group = "locals", desc = "previous scope" },
          ["[z"] = { query = "@fold.outer", query_group = "folds", desc = "previous fold" },
        },
        goto_previous_end = {
          ["[E"] = { query = "@call.outer", desc = "prev function call end" },
          ["[E"] = { query = "@function.outer", desc = "prev method/function def end" },
          ["[S"] = { query = "@class.outer", desc = "prev class end" },
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
      "terraform",
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
