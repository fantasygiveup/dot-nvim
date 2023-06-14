local M = {}

-- git_save_file_remote.
M.config = function()
  vim.keymap.set("n", "<localleader>gc", function()
    local file = vim.api.nvim_buf_get_name(0)
    if file == nil or file == "" then
      print("Not a file")
      return
    end

    local ok, project = pcall(require, "project_nvim.project")
    if not ok then
      return
    end

    local project_root = project.get_project_root()
    if not project_root then
      return
    end
    project_root = vim.fn.fnamemodify(project_root, ":t")

    local include_project_patterns = { "dotfiles", "docs", "org" }

    local found = false
    for _, pat in ipairs(include_project_patterns) do
      if project_root:sub(-#pat) == pat then
        found = true
      end
    end

    local name = vim.fn.fnamemodify(file, ":t")
    if not found then
      print("Not allowed for <" .. project_root .. ">")
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
  end, { desc = "git_save_file_remote" })
end

return M
