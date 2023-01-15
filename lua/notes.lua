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

  local day = os.date("%Y-%m-%d")
  local weekday = os.date("%A")
  local new_entry = string.format("\n# %s %s: %s\n\n", day, weekday, title)

  local file_path = require("global").diary

  if utils.append_to_file(file_path, new_entry) then
    utils.open_buffer_file(file_path)
    vim.cmd(":edit")
    utils.win_scroll_last_line()
    pcall(vim.cmd, "normal! zo") -- open the fold
    require("internal").zen_mode(5, 1)
  end
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

  local file_path = require("global").todos
  local new_entry = string.format("- [ ] %s", title)

  if utils.append_to_file(file_path, new_entry) then
    print("New todo: " .. title)

    if vim.api.nvim_buf_get_name(0) == file_path then
      vim.cmd(":edit")
      utils.win_scroll_last_line()
    end
  end
end

M.todos_new_entry = function()
  vim.ui.input({ prompt = "New Todo", relative = "win" }, todos_new_entry)
end

return M
