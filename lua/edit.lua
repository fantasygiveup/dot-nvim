local M = {}

M.setup = function(use)
  use({ "numToStr/Comment.nvim", config = M.comment_nvim_setup })
  use({ "kylechui/nvim-surround", config = M.nvim_surround_setup })
  use({ "windwp/nvim-autopairs", config = M.autopairs_setup })
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

return M
