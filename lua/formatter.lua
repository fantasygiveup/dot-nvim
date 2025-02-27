local M = {}

M.config = function()
  local ft = require("guard.filetype")

  ft("lua"):fmt({
    cmd = "stylua",
    args = { "-" },
    stdin = true,
    ignore_patterns = "function.*_spec%.lua",
    find = ".stylua.toml",
  })

  local vars = require("vars")
  local config_dir = os.getenv("HOME") .. vars.path_sep .. ".config" .. vars.path_sep
  ft("yaml,markdown"):fmt({
    cmd = "prettier",
    args = {
      "--config=" .. config_dir .. "prettier" .. vars.path_sep .. "prettier.config.js",
      "--stdin-filepath",
    },
    stdin = true,
    fname = true,
  })

  ft("typescript,javascript,typescriptreact,javascriptreact,css,json"):fmt({
    cmd = "prettier",
    args = { "--stdin-filepath" },
    stdin = true,
    fname = true,
  })

  ft("go"):fmt("lsp"):append({ cmd = "golines", args = { "--max-len=150" }, stdin = true })
  ft("elixir", "heex"):fmt("lsp")
  ft("c,cpp"):fmt({ cmd = "clang-format", stdin = true })
  ft("nix"):fmt({ cmd = "nixfmt", stdin = true })
  ft("sh"):fmt({ cmd = "shfmt", stdin = true })
  ft("python"):fmt({ cmd = "yapf", stdin = true })
end

M.ft = function()
  return {
    "c",
    "cmake",
    "cpp",
    "css",
    "elixir",
    "go",
    "heex",
    "yaml",
    "html",
    "javascript",
    "javascriptreact",
    "json",
    "lua",
    "markdown",
    "nix",
    "python",
    "sh",
    "typescript",
    "typescriptreact",
  }
end

return M
