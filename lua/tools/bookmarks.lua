local M = {}

M.config = function()
  require("bookmarks").setup({})

  vim.api.nvim_create_autocmd({ "VimEnter", "BufEnter" }, {
    group = vim.api.nvim_create_augroup("BookmarksGroup", {}),
    pattern = { "*" },
    callback = M.find_or_create_project_bookmark_group,
  })

  require("keymap").bookmarks()
end

M.find_or_create_project_bookmark_group = function()
  local project_root = require("project_nvim.project").get_project_root()
  if not project_root then
    return
  end

  local vars = require("vars")
  local project_name = string.gsub(project_root, "^" .. vars.home .. vars.path_sep, "")
  local Service = require("bookmarks.domain.service")
  local Repo = require("bookmarks.domain.repo")
  local bookmark_list = nil

  for _, bl in ipairs(Repo.find_lists()) do
    if bl.name == project_name then
      bookmark_list = bl
      break
    end
  end

  if not bookmark_list then
    bookmark_list = Service.create_list(project_name)
  end
  Service.set_active_list(bookmark_list.id)
  require("bookmarks.sign").safe_refresh_signs()
end

M.toggle_bookmark = function()
  local Service = require("bookmarks.domain.service")
  local Sign = require("bookmarks.sign")
  local Tree = require("bookmarks.tree.operate")

  local b = Service.find_bookmark_by_location()
  vim.ui.input(
    { prompt = "[Bookmarks Toggle]", default = b and b.name or "", relative = "win" },
    function(input)
      if input then
        Service.toggle_mark(input)
        Sign.safe_refresh_signs()
        pcall(Tree.refresh)
      end
    end
  )
end

return M
