local M = {}

local api = vim.api

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
M.restore_buf_cursor = function()
  if vim.fn.line([[`"]]) <= vim.fn.line([[$]]) then
    vim.cmd([[try | exec 'normal! g`"zz' | catch | endtry]])
  end

  unfold()
end

M.qf_toggle = function()
  local nr = api.nvim_win_get_buf(0)
  vim.cmd("cwindow")
  local nr2 = api.nvim_win_get_buf(0)
  if nr == nr2 then
    vim.cmd("cclose")
  end
end

M.git_save_file_remote = function(file)
  file = file or api.nvim_buf_get_name(0)
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
    { "git", "push" },
  }

  for _, cmd in ipairs(cmds) do
    vim.fn.system(cmd)
  end
  print(name .. " pushed to " .. remote)
end

M.int2rgb = function(color)
  local bit = require("bit")
  local r = bit.rshift(bit.band(color, 0xFF0000), 16)
  local g = bit.rshift(bit.band(color, 0x00FF00), 8)
  local b = bit.band(color, 0x0000FF)
  return string.format("#%02x%02x%02x", r, g, b)
end

return M
