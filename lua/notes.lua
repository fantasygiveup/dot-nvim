local M = {}

local function open_file(path)
  if vim.api.nvim_buf_get_name(0) == path then
    return
  end

  local ok, _ = pcall(vim.cmd, "e " .. path)
  if not ok then
    error("Could not open file: " .. path)
  end

  return ok
end

M.diary_open_file = function()
  open_file(require("global").diary)
  require("internal").zen_mode(5)
end

local function diary_new_entry(title)
  if not title or title == "" then
    return
  end

  local ok = M.diary_open_file()
  if not ok then
    return
  end

  local buf_lines = vim.api.nvim_buf_get_lines(0, 0, -1, true) -- get the whole buffer

  local day = os.date("%Y-%m-%d")
  local weekday = os.date("%A")

  local new_entry = {}
  table.insert(new_entry, "")
  table.insert(new_entry, string.format("# %s %s: %s", day, weekday, title))
  table.insert(new_entry, "")
  table.insert(new_entry, "")

  vim.api.nvim_buf_set_lines(0, -1, -1, true, new_entry)
  vim.api.nvim_win_set_cursor(0, { #buf_lines + #new_entry, 0 }) -- move down

  pcall(vim.cmd, "normal! zo") -- open the fold

  require("internal").zen_mode(5)
end

M.diary_new_entry = function()
  vim.ui.input({ prompt = "New Diary", relative = "win" }, diary_new_entry)
end

M.todo_open_file = function()
  return open_file(require("global").todos)
end

local function todo_new_entry(title)
  if not title or title == "" then
    return
  end

  local ok = M.todo_open_file()
  if not ok then
    return
  end

  local buf_lines = vim.api.nvim_buf_get_lines(0, 0, -1, true) -- get the whole buffer

  local new_entry = {}
  table.insert(new_entry, string.format("- [ ] %s", title))

  vim.api.nvim_buf_set_lines(0, -1, -1, true, new_entry)
  vim.api.nvim_win_set_cursor(0, { #buf_lines + #new_entry, 0 }) -- move down

  pcall(vim.cmd, "normal! zo") -- open the fold

  require("internal").zen_mode(5, 1)
end

M.todo_new_entry = function()
  vim.ui.input({ prompt = "New Todo", relative = "win" }, todo_new_entry)
end

return M
