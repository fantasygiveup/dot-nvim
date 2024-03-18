local M = {}

M.config = function()
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

  local keymap = require("keymap")

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
    mapping = cmp.mapping.preset.insert(keymap.cmp_preset()),
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

  keymap.completion()
end

return M
