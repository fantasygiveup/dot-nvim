local M = {}

M.qf_toggle = function()
  local nr = vim.api.nvim_win_get_buf(0)
  vim.cmd("cwindow")
  local nr2 = vim.api.nvim_win_get_buf(0)
  if nr == nr2 then
    vim.cmd("cclose")
  end
end

M.fzf_grep_project = function(opts)
  local opts = opts or {}
  opts.rg_opts =
    "--column --line-number --no-heading --color=always --colors='match:none' --smart-case --max-columns=512"
  opts.fzf_opts = { ["--nth"] = false }
  opts.no_esc = true
  opts.search = opts.search or "\\S"

  require("fzf-lua").grep_project(opts)
end

M.fzf_grep_notes = function()
  M.fzf_grep_project({ prompt = "Notes> ", cwd = require("global").notes_dir })
end

-- delete buffers begin
M.del_buf_others = function()
  require("close_buffers").wipe({ type = "other", force = true })
  print("Close other buffers")
end

M.del_buf_all = function()
  require("close_buffers").wipe({ type = "all", force = true })
  print("Close all buffers")
end

M.del_buf_current_project = function()
  local project_root = require("project_nvim.project").get_project_root()
  require("close_buffers").wipe({ regex = project_root, force = true })
  print(string.format("Close buffers of %s", vim.fn.fnamemodify(project_root, ":t")))
end
-- delete buffers end

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
