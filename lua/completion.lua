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
    mapping = cmp.mapping.preset.insert({
      ["<C-n>"] = cmp.mapping.select_next_item({ behavior = "select", count = 1 }),
      ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = "select", count = 1 }),
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-q>"] = cmp.mapping.abort(),
      ["<C-e>"] = cmp.mapping.confirm({ select = true }),
      ["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
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
end

return M
