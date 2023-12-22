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
      ["core.defaults"] = {}, -- Loads default behaviour
      ["core.concealer"] = {}, -- Adds pretty icons to your documents
      ["core.dirman"] = { -- Manages Neorg workspaces
        config = {
          workspaces = {
            notes = vars.org_dir .. vars.path_sep .. "notes",
            docs = vars.org_dir .. vars.path_sep .. "docs",
          },
          default_workspace = "notes",
        },
      },
      ["core.keybinds"] = {
        config = {
          neorg_leader = "<leader>",
        },
      },
    },
  })

  vim.keymap.set("n", "<leader>nw", ":Neorg workspace ", { desc = "neorg workspace" })
  vim.keymap.set("n", "<leader>ni", "<cmd>Neorg index<cr>", { desc = "neorg index" })
  vim.keymap.set("n", "<leader>nr", "<cmd>Neorg return<cr>", { desc = "neorg return" })
end

return M
