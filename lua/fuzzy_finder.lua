local M = {}

M.config = function(use)
  use({
    "nvim-telescope/telescope.nvim",
    requires = {
      { "nvim-lua/plenary.nvim" },
      { "kyazdani42/nvim-web-devicons" },
      { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
    },
    config = M.finder_setup,
  })
  use({ "stevearc/dressing.nvim", config = M.dressing_setup })
end

M.finder_setup = function()
  local ok, telescope = pcall(require, "telescope")
  if not ok then
    return
  end

  telescope.setup({
    extensions = { fzf = { fuzzy = false } },
    defaults = {
      prompt_prefix = "🔭 ",
      -- Full screen, equal panels, prompt and content top.
      layout_config = {
        prompt_position = "top",
        width = 1000,
        height = 1000,
        preview_width = 0.5,
        anchor = "CENTER",
      },
      sorting_strategy = "ascending",
      vimgrep_arguments = require("vars").rg_opts,
    },
  })

  telescope.load_extension("fzf")

  -- Fzf-lua keymap.
  vim.keymap.set(
    "n",
    "<localleader>b",
    "<cmd>lua require'telescope.builtin'.buffers({sort_lastused = true})<cr>"
  )
  vim.keymap.set(
    "n",
    "<c-t>",
    "<cmd>lua require'telescope.builtin'.find_files({find_command = require'vars'.fzf_default_command})<cr>"
  )
  vim.keymap.set("n", "<leader>:", "<cmd>lua require'fzf-lua'.commands()<cr>")

  vim.keymap.set("n", "<leader>:", "<cmd>lua require'telescope.builtin'.commands()<cr>")
  vim.keymap.set("n", "<leader>?", "<cmd>lua require'telescope.builtin'.keymaps()<cr>")
  vim.keymap.set("n", "<localleader>~", "<cmd>lua require'telescope.builtin'.filetypes()<cr>")
  vim.keymap.set("n", "<localleader>r", "<cmd>lua require'telescope.builtin'.oldfiles()<cr>")
  vim.keymap.set("n", "<localleader>gg", "<cmd>lua require'telescope.builtin'.git_status()<cr>")
  vim.keymap.set("n", "<localleader>gb", "<cmd>lua require'telescope.builtin'.git_bcommits()<cr>")
  vim.keymap.set("n", "<localleader>gl", "<cmd>lua require'telescope.builtin'.git_commits()<cr>")
  vim.keymap.set(
    { "n" },
    "<leader>/",
    "<cmd>lua require'telescope.builtin'.grep_string({ search = '' })<cr>"
  )
  vim.keymap.set({ "v" }, "<leader>/", "<cmd>lua require'telescope.builtin'.grep_string()<cr>")
  vim.keymap.set(
    "n",
    "<c-s>",
    "<cmd>lua require'telescope.builtin'.grep_string({ cwd = require'vars'.notes_dir, search = '' })<cr>",
    { desc = "grep_notes" }
  )
end

M.dressing_setup = function()
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
