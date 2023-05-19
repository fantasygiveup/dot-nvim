local M = {}

M.config = function()
  local ok, dressing = pcall(require, "dressing")
  if not ok then
    return
  end

  local ok, telescope = pcall(require, "telescope")
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

  telescope.setup({
    extensions = { fzf = { fuzzy = false } },
    defaults = {
      mappings = {
        i = {
          ["<c-a>"] = "toggle_all",
        },
      },
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

  vim.keymap.set("n", "<leader>:", "<cmd>lua require'telescope.builtin'.commands()<cr>")
  vim.keymap.set("n", "<leader>?", "<cmd>lua require'telescope.builtin'.keymaps()<cr>")
  vim.keymap.set("n", "<localleader>~", "<cmd>lua require'telescope.builtin'.filetypes()<cr>")
  vim.keymap.set("n", "<localleader>r", "<cmd>lua require'telescope.builtin'.oldfiles()<cr>")
  vim.keymap.set("n", "<localleader>gs", "<cmd>lua require'telescope.builtin'.git_status()<cr>")
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

  --
  -- vim.keymap.set("n", "<localleader>b", "<cmd>lua require'fzf-lua'.buffers()<cr>")
  -- vim.keymap.set(
  --   "n",
  --   "<c-t>",
  --   "<cmd>lua require'fzf-lua'.files({ cmd = vim.env.FZF_DEFAULT_COMMAND })<cr>"
  -- )
  -- vim.keymap.set("n", "<leader>?", "<cmd>lua require'fzf-lua'.keymaps()<cr>")
  -- vim.keymap.set("n", "<localleader>~", "<cmd>lua require'fzf-lua'.filetypes()<cr>")
  -- vim.keymap.set("n", "<localleader>r", "<cmd>lua require'fzf-lua'.oldfiles()<cr>")
  -- vim.keymap.set("n", "<localleader>gb", "<cmd>lua require'fzf-lua'.git_bcommits()<cr>")
  -- vim.keymap.set("n", "<localleader>gl", "<cmd>lua require'fzf-lua'.git_commits()<cr>")
  -- vim.keymap.set(
  --   "v",
  --   "<leader>/",
  --   "<cmd>lua require'fzf-lua'.grep_visual({ rg_opts = require'vars'.rg_opts })<cr>"
  -- )
  --
  -- local function grep_project(opts)
  --   local opts = opts or {}
  --   opts.rg_opts = require("vars").rg_opts
  --   opts.fzf_opts = { ["--nth"] = false }
  --   opts.no_esc = true
  --   opts.search = opts.search or ""
  --   fzf_lua.grep_project(opts)
  -- end
  --
  -- vim.keymap.set("n", "<leader>/", grep_project, { desc = "grep_project" })
  -- vim.keymap.set("n", "<c-s>", function()
  --   grep_project({ prompt = "Notes> ", cwd = require("vars").notes_dir })
  -- end, { desc = "grep_notes" })
end

return M
