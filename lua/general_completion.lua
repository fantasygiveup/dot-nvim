local M = {}

M.setup = function(use)
  use({ "ibhagwan/fzf-lua", requires = { "kyazdani42/nvim-web-devicons" }, config = M.finder })
  use({ "stevearc/dressing.nvim", config = M.dressing })
end

M.finder = function()
  local ok, fzf_lua = pcall(require, "fzf-lua")
  if not ok then
    return
  end

  fzf_lua.setup({
    winopts = {
      fullscreen = true,
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
        ["<C-f>"] = "preview-page-down",
        ["<C-b>"] = "preview-page-up",
      },
      fzf = {},
    },
  })

  -- Fzf-lua keymap.
  vim.keymap.set("n", "<localleader>b", "<cmd>lua require'fzf-lua'.buffers()<cr>")
  vim.keymap.set(
    "n",
    "<c-t>",
    "<cmd>lua require'fzf-lua'.files({ cmd = vim.env.FZF_DEFAULT_COMMAND })<cr>"
  )
  vim.keymap.set("n", "<leader>:", "<cmd>lua require'fzf-lua'.commands()<cr>")
  vim.keymap.set("n", "<leader>?", "<cmd>lua require'fzf-lua'.keymaps()<cr>")
  vim.keymap.set("n", "<localleader>~", "<cmd>lua require'fzf-lua'.filetypes()<cr>")
  vim.keymap.set("n", "<localleader>r", "<cmd>lua require'fzf-lua'.oldfiles()<cr>")
  vim.keymap.set("n", "<localleader>gg", "<cmd>lua require'fzf-lua'.git_status()<cr>")
  vim.keymap.set("n", "<localleader>gb", "<cmd>lua require'fzf-lua'.git_bcommits()<cr>")
  vim.keymap.set("n", "<localleader>gl", "<cmd>lua require'fzf-lua'.git_commits()<cr>")
  vim.keymap.set("n", "<leader>/", "<cmd>lua require'internal'.fzf_grep_project()<cr>")
  vim.keymap.set("v", "<leader>/", "<cmd>lua require'fzf-lua'.grep_visual()<cr>")
  vim.keymap.set("n", "<c-s>", "<cmd>lua require'internal'.fzf_grep_notes()<cr>")
end

M.dressing = function()
  local ok, dressing = pcall(require, "dressing")
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
end

return M
