local M = {}

M.config = function()
  local ok, yanky = pcall(require, "yanky")
  if not ok then
    return
  end

  yanky.setup({
    ring = {
      storage = "memory",
    },
    highlight = {
      on_put = false,
      on_yank = false,
    },
  })

  vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
  vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
  vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
  vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")
  vim.keymap.set("n", "<c-n>", "<Plug>(YankyCycleForward)")
  vim.keymap.set("n", "<c-p>", "<Plug>(YankyCycleBackward)")
end

return M
