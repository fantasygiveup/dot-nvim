local M = {}

M.config = function()
  local ok, todo_comments = pcall(require, "todo-comments")
  if not ok then
    return
  end

  todo_comments.setup({
    signs = false,
    highlight = {
      keyword = "fg",
      after = "",
      pattern = [[.*<(KEYWORDS)\s*(\(.*\))?\s*:?]],
      comments_only = false,
    },
    keywords = {
      TODO = { icon = "󱦟 ", color = "hint" },
      DONE = { icon = " ", color = "info" },
    },
  })
end

return M
