local function visual_selection_range()
  local _, csrow, cscol, _ = unpack(vim.fn.getpos("'<"))
  local _, cerow, cecol, _ = unpack(vim.fn.getpos("'>"))
  if csrow < cerow or (csrow == cerow and cscol <= cecol) then
    return csrow - 1, cscol - 1, cerow - 1, cecol
  else
    return cerow - 1, cecol - 1, csrow - 1, cscol
  end
end

local function visual_selection()
  local csrow, cscol, cerow, cecol = visual_selection_range()
  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, csrow, cerow+1, false)
  if #lines == 0 then
    return ''
  elseif #lines == 1 then
    lines[1] = string.sub(lines[1], cscol+1, cecol)
  else
    lines[1] = string.sub(lines[1], cscol+1, string.len(lines[1]))
    lines[#lines] = string.sub(lines[#lines], 1, cecol)
  end
  return table.concat(lines, "\n")
end

local function search_visual_selected()
  local pattern = visual_selection()
  -- -w: exact word match.
  require("telescope.builtin").grep_string({search = pattern})
end

local function unfold()
  local cl = vim.fn.line(".")

  if not vim.o.foldenable or cl <= 1 then
    return
  end

  local cf = vim.fn.foldlevel(cl)
  local uf = vim.fn.foldlevel(cl - 1)
  local min = math.min(cf, uf)

  if min > 0 then
    vim.cmd("normal! " .. tostring(min) .. "zo")
  end
end

-- restore_buf_cursor jumps to the last visited file's position.
local function restore_buf_cursor()
  if vim.fn.line([[`"]]) <= vim.fn.line([[$]]) then
    vim.cmd([[try | exec 'normal! g`"zz' | catch | endtry]])
  end

  unfold()
end

local function qf_toggle()
  local nr = vim.api.nvim_win_get_buf(0)
  vim.cmd("cwindow")
  local nr2 = vim.api.nvim_win_get_buf(0)
  if nr == nr2 then
    vim.cmd("cclose")
  end
end

local function git_sync_file_change(file)
  file = file or vim.api.nvim_buf_get_name(0)
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
    { "git", "push" }
  }

  for _, cmd in ipairs(cmds) do
    vim.fn.system(cmd)
  end
  print(name .. " pushed to " .. remote)
end

return {
  restore_buf_cursor = restore_buf_cursor,
  search_visual_selected = search_visual_selected,
  qf_toggle = qf_toggle,
  git_sync_file_change = git_sync_file_change,
}
