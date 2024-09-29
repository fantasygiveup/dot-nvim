local M = {}

M.config = function()
  local ok, gitsigns = pcall(require, "gitsigns")
  if not ok then
    return
  end

  local ok, actions = pcall(require, "gitsigns.actions")
  if not ok then
    return
  end

  gitsigns.setup({
    on_attach = function(bufnr)
      if vim.o.diff or vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":e") == "gpg" then
        return false
      end
      return true
    end,
    keymaps = nil,
    signs = {
      add = { text = "" },
      change = { text = "" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "" },
    },
    signs_staged = {
      add = { text = "" },
      change = { text = "" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "" },
    },

    attach_to_untracked = false, -- don't highlight new files
  })

  require("keymap").gitsigns()
end

return M
