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

local function git_save_file_remote(file)
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
  qf_toggle = qf_toggle,
  git_save_file_remote = git_save_file_remote,
}
