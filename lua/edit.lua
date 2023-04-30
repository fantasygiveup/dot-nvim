local M = {}

M.config = function(use)
  use({ "numToStr/Comment.nvim", config = M.comment_nvim_setup })
  use({ "kylechui/nvim-surround", config = M.nvim_surround_setup })
  use({ "windwp/nvim-autopairs", config = M.autopairs_setup })
  use({ "gbprod/yanky.nvim", config = M.yanky_setup })
  use({ "phaazon/hop.nvim", branch = "v2", config = M.hop_setup }) -- similar to emacs ace-jump-mode
end

M.comment_nvim_setup = function()
  local ok, comment = pcall(require, "Comment")
  if not ok then
    return
  end
  comment.setup({})
end

M.nvim_surround_setup = function()
  local ok, nvim_surround = pcall(require, "nvim-surround")
  if not ok then
    return
  end
  nvim_surround.setup({})
end

M.autopairs_setup = function()
  local ok, nvim_autopairs = pcall(require, "nvim-autopairs")
  if not ok then
    return
  end
  nvim_autopairs.setup({})
end

M.yanky_setup = function()
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

M.hop_setup = function()
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
