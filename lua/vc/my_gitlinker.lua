local M = {}

M.config = function()
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
  end, { desc = "copy git line to clipboard" })

  vim.keymap.set("v", "<localleader>gu", function()
    gitlinker.get_buf_range_url("v", { action_callback = actions.copy_to_clipboard })
  end, { desc = "copy git range to clipboard" })

  vim.keymap.set("n", "<localleader>gU", function()
    gitlinker.get_repo_url({ action_callback = actions.open_in_browser })
  end, { desc = "open git line in browser" })

  vim.keymap.set("v", "<localleader>gU", function()
    gitlinker.get_buf_range_url("v", { action_callback = actions.open_in_browser })
  end, { desc = "open selected git range in browser" })
end

return M
