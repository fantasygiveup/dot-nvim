local M = {}

local utils = require("utils")

M.diary_open_file = function()
  utils.open_buffer_file(require("global").diary)
  require("internal").zen_mode(5, 1)
end

local function diary_new_entry(title)
  if not title or title == "" then
    return
  end

  local ok = utils.open_buffer_file()
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

  require("internal").zen_mode(5, 1)
end

M.diary_new_entry = function()
  vim.ui.input({ prompt = "New Diary", relative = "win" }, diary_new_entry)
end

M.todos_open_file = function()
  if utils.open_buffer_file(require("global").todos) then
    require("internal").zen_mode(5, 1)
  end
end

local function todos_new_entry(title)
  if not title or title == "" then
    return
  end

  local todos_path = require("global").todos
  local fd = io.open(todos_path, "r+")
  if not fd then
    error("Unable to open " .. todos_path)
  end

  -- Append a new line if it's not already appended.
  local maybe_eol = "\n"
  local eof = fd:seek("end")
  fd:seek("set", eof - 1)
  if fd:read(1) == maybe_eol then
    maybe_eol = ""
  end
  fd:seek("end")

  fd:write(string.format("%s- [ ] %s", maybe_eol, title))
  fd:close()

  print("New todo: " .. title)

  if vim.api.nvim_buf_get_name(0) == todos_path then
    vim.cmd(":edit")
  end
end

M.todos_new_entry = function()
  vim.ui.input({ prompt = "New Todo", relative = "win" }, todos_new_entry)
end

return M
