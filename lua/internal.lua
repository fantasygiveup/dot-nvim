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

M.make_build = function()
  local build_cmd = "!make build"
  local ok, fname = pcall(vim.api.nvim_buf_get_name, 0)
  if ok then
    build_cmd = build_cmd .. " MAKEFILE_FILENAME=" .. fname
  end
  vim.cmd(build_cmd)
end

M.search_notes = function()
  local cmd_opts = {
    cwd = require("global").notes_dir,
    search = "\\S",
    no_esc = true,
    fzf_opts = { ["--nth"] = false },
  }
  require("fzf-lua").grep_project(cmd_opts)
end

-- gitlinker begin
local gitlinker = require("gitlinker")
local gitlinker_actions = require("gitlinker.actions")

M.git_url_at_point = function()
  gitlinker.get_buf_range_url("n", { action_callback = gitlinker_actions.copy_to_clipboard })
end

M.git_url_range = function()
  gitlinker.get_buf_range_url("v", { action_callback = gitlinker_actions.copy_to_clipboard })
end

M.git_url_in_browser = function()
  gitlinker.get_repo_url({ action_callback = gitlinker_actions.open_in_browser })
end
-- gitlinker end

-- delete buffers begin
M.del_buf_others = function()
  require("close_buffers").wipe({ type = "other", force = true })
end

M.del_buf_all = function()
  require("close_buffers").wipe({ type = "all", force = true })
end

M.del_buf_current_project = function()
  local project_root = require("project_nvim.project").get_project_root()
  require("close_buffers").wipe({ regex = project_root, force = true })
end
-- delete buffers end

return M
