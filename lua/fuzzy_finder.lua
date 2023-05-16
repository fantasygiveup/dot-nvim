local M = {}

M.config = function()
  local ok, dressing = pcall(require, "dressing")
  if not ok then
    return
  end

  local ok, fzf_lua = pcall(require, "fzf-lua")
  if not ok then
    return
  end

  dressing.setup({
    input = {
      get_config = function(opts)
        return opts
      end,
    },
  })

  fzf_lua.setup({
    winopts = {
      fullscreen = true,
      number = false,
      preview = {
        vertical = "down:50%",
        horizontal = "right:50%",
        flip_columns = 160,
        scrollbar = false,
      },
    },
    keymap = {
      builtin = {
        ["<A-p>"] = "toggle-preview",
        ["<C-d>"] = "preview-page-down",
        ["<C-u>"] = "preview-page-up",
        ["<F1>"] = "toggle-help",
        ["<F2>"] = "toggle-fullscreen",
      },
      fzf = {},
    },
  })

  vim.keymap.set("n", "<localleader>b", "<cmd>lua require'fzf-lua'.buffers()<cr>")
  vim.keymap.set(
    "n",
    "<c-t>",
    "<cmd>lua require'fzf-lua'.files({ cmd = vim.env.FZF_DEFAULT_COMMAND })<cr>"
  )
  vim.keymap.set("n", "<leader>?", "<cmd>lua require'fzf-lua'.keymaps()<cr>")
  vim.keymap.set("n", "<localleader>~", "<cmd>lua require'fzf-lua'.filetypes()<cr>")
  vim.keymap.set("n", "<localleader>r", "<cmd>lua require'fzf-lua'.oldfiles()<cr>")
  vim.keymap.set("n", "<localleader>gb", "<cmd>lua require'fzf-lua'.git_bcommits()<cr>")
  vim.keymap.set("n", "<localleader>gl", "<cmd>lua require'fzf-lua'.git_commits()<cr>")
  vim.keymap.set(
    "v",
    "<leader>/",
    "<cmd>lua require'fzf-lua'.grep_visual({ rg_opts = require'vars'.rg_opts })<cr>"
  )

  local function grep_project(opts)
    local opts = opts or {}
    opts.rg_opts = require("vars").rg_opts
    opts.fzf_opts = { ["--nth"] = false }
    opts.no_esc = true
    opts.search = opts.search or ""
    fzf_lua.grep_project(opts)
  end

  vim.keymap.set("n", "<leader>/", grep_project, { desc = "grep_project" })
  vim.keymap.set("n", "<c-s>", function()
    grep_project({ prompt = "Notes> ", cwd = require("vars").notes_dir })
  end, { desc = "grep_notes" })
end

return M
