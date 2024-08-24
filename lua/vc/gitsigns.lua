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
      add = { text = "" },
      change = { text = "" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "" },
    },
    signs_staged = {
      add = { text = "" },
      change = { text = "" },
      delete = { text = "" },
      topdelete = { text = "" },
      changedelete = { text = "" },
    },

    attach_to_untracked = false, -- don't highlight new files
  })

  vim.keymap.set("n", "<localleader>g?", "<cmd>lua require'gitsigns'.blame_line({full=true})<cr>")
  vim.keymap.set("n", "<leader>hp", "<cmd>lua require'gitsigns'.preview_hunk()<cr>")
  vim.keymap.set("n", "<leader>hu", "<cmd>lua require'gitsigns'.reset_hunk()<cr>")
  vim.keymap.set("n", "<leader>hs", "<cmd>lua require'gitsigns'.stage_hunk()<cr>")
  vim.keymap.set("n", "<leader>h#", "<cmd>lua require'gitsigns'.reset_buffer()<cr>")

  vim.keymap.set("n", "]c", function()
    if vim.o.diff then
      pcall(vim.cmd, "normal! ]czz")
      return
    end
    actions.next_hunk()
  end, { desc = "next_hunk" })

  vim.keymap.set("n", "[c", function()
    if vim.o.diff then
      pcall(vim.cmd, "normal! [czz")
      return
    end
    actions.prev_hunk()
  end, { desc = "prev_hunk" })
end

return M
