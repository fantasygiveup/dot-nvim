local M = {}

local function open_buffer_file(path)
  if vim.api.nvim_buf_get_name(0) == path then
    return
  end

  local ok, _ = pcall(vim.cmd, "e " .. path)
  if not ok then
    error("Could not open file: " .. path)
  end

  return ok
end

local function append_to_file(path, s)
  local fd = io.open(path, "r+")
  if not fd then
    error("Unable to open " .. path)
    return
  end

  -- Append a new line if it's not already appended.
  local maybe_eol = "\n"
  local eof = fd:seek("end")
  fd:seek("set", eof - 1)
  if fd:read(1) == maybe_eol then
    maybe_eol = ""
  end
  fd:seek("end")

  fd:write(string.format("%s%s", maybe_eol, s))
  fd:close()
  return 1
end

local function diary_new_entry(title)
  if not title or title == "" then
    return
  end

  local day = os.date("%Y-%m-%d")
  local weekday = os.date("%A")
  local new_entry = string.format("\n# %s %s: %s\n\n", day, weekday, title)

  local file_path = require("vars").diary

  if append_to_file(file_path, new_entry) then
    open_buffer_file(file_path)
    vim.cmd(":edit")
    win_scroll_last_line()
    pcall(vim.cmd, "normal! zo") -- open the fold
    require("frontend").zen_mode(5, 1)
  end
end

M.diary_open_file = function()
  open_buffer_file(require("vars").diary)
  require("frontend").zen_mode(5, 1)
end

M.diary_new_entry = function()
  vim.ui.input({ prompt = "New Diary", relative = "win" }, diary_new_entry)
end

M.todos_open_file = function()
  if open_buffer_file(require("vars").todos) then
    require("frontend").zen_mode(5, 1)
  end
end

local function win_scroll_last_line(win, bufnr)
  local win = win or 0
  local bufnr = bufnr or 0
  local buf_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, true)
  vim.api.nvim_win_set_cursor(win, { #buf_lines, 0 })
end

local function todos_new_entry(title)
  if not title or title == "" then
    return
  end

  local file_path = require("vars").todos
  local new_entry = string.format("- [ ] %s", title)

  if append_to_file(file_path, new_entry) then
    print("New todo: " .. title)

    if vim.api.nvim_buf_get_name(0) == file_path then
      vim.cmd(":edit")
      win_scroll_last_line()
    end
  end
end

M.load = function()
  vim.keymap.set("n", "<leader>od", function()
    vim.ui.input({ prompt = "New Diary", relative = "win" }, diary_new_entry)
  end, { desc = "diary_new_entry" })

  vim.keymap.set("n", "<leader>oo", function()
    open_buffer_file(require("vars").diary)
    require("frontend").zen_mode(5, 1)
  end, { desc = "diary_overview" })

  vim.keymap.set("n", "<leader>ot", function()
    vim.ui.input({ prompt = "New Todo", relative = "win" }, todos_new_entry)
  end, { desc = "todos_new_entry" })

  vim.keymap.set("n", "<leader>ol", function()
    if open_buffer_file(require("vars").todos) then
      require("frontend").zen_mode(5, 1)
    end
  end, { desc = "todos_list" })
end

return M
