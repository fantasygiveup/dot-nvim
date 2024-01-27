-- Documentation --
-- https://github.com/nvim-neorg/neorg/wiki/User-Keybinds
--
local M = {}

M.config = function()
  local ok, neorg = pcall(require, "neorg")
  if not ok then
    return
  end

  local vars = require("vars")

  neorg.setup({
    load = {
      ["core.defaults"] = {}, -- loads default behaviour
      ["core.concealer"] = {}, -- adds pretty icons to your documents
      ["core.pivot"] = {}, -- toggle list types (ordered to unordered and vise versa)
      ["core.itero"] = {}, -- repeat same operation
      ["core.summary"] = {}, -- generate summary (you do not need to maintain index.norg anymore!)
      ["core.dirman"] = { -- manages Neorg workspaces
        config = {
          workspaces = {
            org = vars.org_dir,
          },
          default_workspace = "org",
        },
      },
      ["core.keybinds"] = { config = { neorg_leader = "<leader>" } },
    },
  })

  require("keymap").neorg()
end

return M
