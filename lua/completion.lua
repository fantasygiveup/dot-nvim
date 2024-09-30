local M = {}

M.config = function()
  local ok, _ = require("snippets")
  if not ok then
    error("Snippets plugin is not loaded")
    return
  end

  local cmp = require("cmp")
  local luasnip = require("luasnip")

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

  keymap.luasnip()
end

return M
