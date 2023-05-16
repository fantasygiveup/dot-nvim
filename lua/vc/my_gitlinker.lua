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
  end, { desc = "vc_url_at_point" })

  vim.keymap.set("v", "<localleader>gu", function()
    gitlinker.get_buf_range_url("v", { action_callback = actions.copy_to_clipboard })
  end, { desc = "vc_url_range" })

  vim.keymap.set("n", "<localleader>gU", function()
    gitlinker.get_repo_url({ action_callback = actions.open_in_browser })
  end, { desc = "vc_open_in_browser" })
end

return M
