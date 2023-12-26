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

  vim.keymap.set("n", "<leader>nw", ":Neorg workspace ", { desc = "neorg workspace" })
  vim.keymap.set("n", "<leader>ni", "<cmd>Neorg index<cr>", { desc = "neorg index" })
  vim.keymap.set(
    "n",
    "<leader>nt",
    "<cmd>e " .. vars.org_dir .. vars.path_sep .. "todos.norg" .. " <cr>",
    { desc = "open todo file" }
  )
  vim.keymap.set(
    "n",
    "<leader>ns",
    "<cmd>e " .. vars.org_dir .. vars.path_sep .. "scratchpad.norg" .. " <cr>",
    { desc = "open scratchpad file" }
  )

  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = vim.api.nvim_create_augroup("NorgGroup", {}),
    pattern = { "*.norg" },
    callback = function()
      vim.keymap.set(
        "n",
        "<leader><cr>",
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
        { "i", "n" },
        "<c-cr>",
        "<cmd>Neorg keybind all core.itero.next-iteration<cr>",
        { desc = "neorg repeat last", buffer = 0 }
      )

      vim.keymap.set(
        "n",
        "<leader>nh",
        "<cmd>Neorg inject-metadata<cr>",
        { desc = "neorg insert header", buffer = 0 }
      )
    end,
  })
end

return M
