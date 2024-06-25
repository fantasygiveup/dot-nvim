local M = {}

M.timer = function(cb, wait, duration)
  local wait = wait or 0
  local duration = duration or 0

  local timer = vim.loop.new_timer()
  timer:start(wait, duration, vim.schedule_wrap(cb))
end

return M
