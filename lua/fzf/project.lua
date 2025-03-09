local M = {}

M.navigate = function()
  local fzf_lua = require("fzf-lua")
  local vars = require("vars")
  local preview_cmd = "tree -C -L 1 " .. vim.env.FZF_PROJECT_ROOT_DIRECTORY .. "/{}"
  local prompt = "Project> "
  local fd_cmd = "fd --hidden --case-sensitive --base-directory "
    .. vim.env.FZF_PROJECT_ROOT_DIRECTORY
    .. " "
    .. vim.env.FZF_PROJECT_FD_IGNORE_FILTER
    .. " --relative-path --prune "
    .. vim.env.FZF_PROJECT_SEARCH_PATTERN

  fzf_lua.fzf_exec(fd_cmd .. " | sort -u | xargs dirname | awk '!x[$0]++'", {
    preview = preview_cmd,
    prompt = prompt,
    actions = {
      ["default"] = function(selected, opts)
        if #selected < 1 then
          return
        end
        fzf_lua.files({
          cwd = vim.env.HOME .. vars.path_sep .. selected[1],
        })
      end,
    },
  })
end

M.init = function()
  require("keymap").fzf_project()
end

return M
