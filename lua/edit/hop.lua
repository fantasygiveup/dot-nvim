local M = {}

M.config = function()
  local ok, hop = pcall(require, "hop")
  if not ok then
    return
  end

  hop.setup({})

  vim.keymap.set("", "<a-t>", function()
    hop.hint_words({})
  end, { remap = true, desc = "hop_words" })
end

return M
