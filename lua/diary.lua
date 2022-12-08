local M = {}

local function new_entry(title)
  if not title or title == "" then
    return
  end

  local file_name = require("global").diary

  local ok, _ = pcall(vim.cmd, "e " .. file_name)
  if not ok then
    error("Could not open file: " .. file_name)
    return
  end

  local buf_lines = vim.api.nvim_buf_get_lines(0, 0, -1, true) -- get the whole buffer

  local day = os.date("%Y-%m-%d")
  local weekday = os.date("%A")

  local new_md_entry = {}
  table.insert(new_md_entry, "")
  table.insert(new_md_entry, string.format("# %s %s: %s", day, weekday, title))
  table.insert(new_md_entry, "")
  table.insert(new_md_entry, "")

  vim.api.nvim_buf_set_lines(0, -1, -1, true, new_md_entry)
  vim.api.nvim_win_set_cursor(0, { #buf_lines + #new_md_entry, 0 }) -- move down

  vim.cmd(":normal! zo") -- open the fold

  local zen_mode = require("internal").zen_mode_textwidth
  zen_mode(5)
end

M.new_entry = function()
  vim.ui.input({ prompt = "New Diary", relative = "win" }, new_entry)
end

return M
