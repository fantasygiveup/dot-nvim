local M = {}

M.config = function(use)
  use({ "ruifm/gitlinker.nvim", requires = "nvim-lua/plenary.nvim", config = M.gitlinker_setup })
  use({ "lewis6991/gitsigns.nvim", requires = "nvim-lua/plenary.nvim", config = M.gitsigns_setup })
end

M.gitlinker_setup = function()
  local ok, gitlinker = pcall(require, "gitlinker")
  if not ok then
    return
  end

  local ok, actions = pcall(require, "gitlinker.actions")
  if not ok then
    return
  end

  gitlinker.setup({
    mappings = nil, -- don't use default mappings
  })

  vim.keymap.set("n", "<localleader>gu", function()
    gitlinker.get_buf_range_url("n", { action_callback = actions.copy_to_clipboard })
  end, { desc = "vc_url_at_point" })

  vim.keymap.set("v", "<localleader>gu", function()
    gitlinker.get_buf_range_url("v", { action_callback = actions.copy_to_clipboard })
  end, { desc = "vc_url_range" })

  vim.keymap.set("n", "<localleader>gU", function()
    gitlinker.get_repo_url({ action_callback = actions.open_in_browser })
  end, { desc = "vc_open_in_browser" })
end

M.gitsigns_setup = function()
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
    keymaps = {},
    signs = {
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

M.setup = function()
  -- vc_save_file_remote.
  vim.keymap.set("n", "<localleader>gc", function()
    local file = vim.api.nvim_buf_get_name(0)
    if file == nil or file == "" then
      print("Not a file")
      return
    end

    local diff = vim.fn.system("git diff " .. file):gsub("\n", "")
    if vim.v.shell_error ~= 0 then
      print("Not in git")
      return
    end
    if diff == "" then
      print("Not modified")
      return
    end

    local remote = vim.fn.system("git config --get remote.origin.url"):gsub("\n", "")
    local name = vim.fn.fnamemodify(file, ":t")
    local cmds = {
      { "git", "add", file },
      { "git", "commit", "-m", "Update " .. name },
      { "git", "push" },
    }

    for _, cmd in ipairs(cmds) do
      vim.fn.system(cmd)
    end
    print(name .. " pushed to " .. remote)
  end, { desc = "vc_save_file_remote" })
end

return M
