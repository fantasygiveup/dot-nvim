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
      ["core.dirman"] = { -- manages Neorg workspaces
        config = {
          workspaces = {
            notes = vars.org_dir .. vars.path_sep .. "notes",
            docs = vars.org_dir .. vars.path_sep .. "docs",
          },
          default_workspace = "notes",
        },
      },
      ["core.keybinds"] = { config = { neorg_leader = "<leader>" } },
    },
  })

  vim.keymap.set("n", "<leader>nw", ":Neorg workspace ", { desc = "neorg workspace" })
  vim.keymap.set("n", "<leader>ni", "<cmd>Neorg index<cr>", { desc = "neorg index" })

  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = vim.api.nvim_create_augroup("NorgGroup", {}),
    pattern = { "*.norg" },
    callback = function()
      vim.keymap.set(
        "n",
        "<leader>n<cr>",
        "<cmd>Neorg return<cr>",
        { desc = "neorg return", buffer = 0 }
      )

      vim.keymap.set(
        "n",
        "<leader>n<Space>",
        "<cmd>Neorg keybind norg core.qol.todo_items.todo.task_cycle<CR>",
        { desc = "neorg cycle task", buffer = 0 }
      )

      vim.keymap.set(
        "n",
        "<leader>nc",
        "<cmd>Neorg toggle-concealer<cr>",
        { desc = "neorg toggle concealer", buffer = 0 }
      )

      vim.keymap.set(
        "n",
        "<leader>nl",
        "<cmd>Neorg keybind norg core.pivot.toggle-list-type<cr>",
        { desc = "neorg toggle list type", buffer = 0 }
      )

      vim.keymap.set(
        "i",
        "<c-cr>",
        "<cmd>Neorg keybind all core.itero.next-iteration<cr>",
        { desc = "neorg repeat last", buffer = 0 }
      )

      vim.keymap.set(
        "n",
        "<leader>ni",
        "<cmd>Neorg inject-metadata<cr>",
        { desc = "neorg inject metadata", buffer = 0 }
      )
    end,
  })
end

return M
