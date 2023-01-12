local M = {}

M.qf_toggle = function()
  local nr = vim.api.nvim_win_get_buf(0)
  vim.cmd("cwindow")
  local nr2 = vim.api.nvim_win_get_buf(0)
  if nr == nr2 then
    vim.cmd("cclose")
  end
end

M.fzf_search_notes = function()
  local cmd_opts = {
    cwd = require("global").notes_dir,
    search = "\\S",
    no_esc = true,
    prompt = "Notes> ",
    fzf_opts = { ["--nth"] = false },
    rg_opts = "--column --line-number --no-heading --color=always --colors='match:none' --smart-case --max-columns=512",
  }
  require("fzf-lua").grep_project(cmd_opts)
end

M.git_save_file_remote = function(file)
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
    { "git", "push" },
  }

  for _, cmd in ipairs(cmds) do
    vim.fn.system(cmd)
  end
  print(name .. " pushed to " .. remote)
end

-- gitlinker begin
M.git_url_at_point = function()
  require("gitlinker").get_buf_range_url(
    "n",
    { action_callback = require("gitlinker.actions").copy_to_clipboard }
  )
end

M.git_url_range = function()
  require("gitlinker").get_buf_range_url(
    "v",
    { action_callback = require("gitlinker.actions").copy_to_clipboard }
  )
end

M.git_url_in_browser = function()
  require("gitlinker").get_repo_url({
    action_callback = require("gitlinker.actions").open_in_browser,
  })
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

-- gitsigns begin
M.next_hunk = function()
  if vim.o.diff then
    pcall(vim.cmd, "normal! ]czz")
    return
  end
  require("gitsigns.actions").next_hunk()
end

M.prev_hunk = function()
  if vim.o.diff then
    pcall(vim.cmd, "normal! [czz")
    return
  end
  require("gitsigns.actions").prev_hunk()
end
-- gitsigns end

-- telescope begin
M.search_visual_selection = function()
  local pattern = require("utils").get_visual_selection()
  require("telescope.builtin").grep_string({ search = pattern })
end
-- telescope end

M.zen_mode = function(extra_width, direction)
  local extra_width = extra_width or 0
  local direction = direction or 0
  local zen_mode = require("zen-mode.view")

  local fn = zen_mode.toggle
  if direction > 0 then
    fn = zen_mode.open
  elseif direction < 0 then
    fn = zen_mode.close
  end

  local opts = {
    window = {
      width = vim.bo.textwidth + extra_width,
    },
  }

  fn(opts)
end

M.diagnostic_severity = function()
  local severity = require("global").diagnostic_severity
  if severity == vim.diagnostic.severity.ERROR then
    return { "error" }
  end
  if severity == vim.diagnostic.severity.WARN then
    return { "error", "warn" }
  end
  if severity == vim.diagnostic.severity.INFO then
    return { "error", "warn", "info" }
  end
  if severity == vim.diagnostic.severity.HINT then
    return { "error", "warn", "info", "hint" }
  end
end

return M
