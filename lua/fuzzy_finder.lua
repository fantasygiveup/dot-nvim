local M = {}

M.config = function()
  local ok, dressing = pcall(require, "dressing")
  if not ok then
    return
  end

  -- Allow to pass options, e.g. center widget screen.
  dressing.setup({
    input = {
      get_config = function(opts)
        return opts
      end,
    },
  })

  local ok, fzf_lua = pcall(require, "fzf-lua")
  if not ok then
    return
  end

  fzf_lua.setup({
    winopts = {
      fullscreen = true,
      number = false,
      preview = {
        vertical = "down:50%",
        horizontal = "right:50%",
        flip_columns = 160,
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

  vim.keymap.set("n", "<leader><", function()
    fzf_lua.buffers()
  end, { desc = "buffers" })

  vim.keymap.set("n", "<c-t>", function()
    fzf_lua.files({ cmd = vim.env.FZF_DEFAULT_COMMAND })
  end, { desc = "files" })

  vim.keymap.set("n", "<leader>?", function()
    fzf_lua.keymaps()
  end, { desc = "keymaps" })

  vim.keymap.set("n", "<localleader>~", function()
    fzf_lua.filetypes()
  end, { desc = "filetypes" })

  vim.keymap.set("n", "<localleader>r", function()
    fzf_lua.oldfiles()
  end, { desc = "oldfiles" })

  vim.keymap.set("n", "<localleader>gs", function()
    fzf_lua.git_status()
  end, { desc = "git_status" })

  vim.keymap.set("n", "<localleader>gb", function()
    fzf_lua.git_bcommits()
  end, { desc = "git_bcommits" })

  vim.keymap.set("n", "<localleader>gl", function()
    fzf_lua.git_commits()
  end, { desc = "git_commits" })

  vim.keymap.set("v", "<leader>/", function()
    fzf_lua.grep_visual({ rg_opts = require("vars").rg_opts })
  end, { desc = "grep_visual" })

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
    local vars = require("vars")
    grep_project({ prompt = "Notes> ", cwd = vars.org_dir })
  end, { desc = "grep_notes" })

  vim.keymap.set("n", "<leader>lw", function()
    fzf_lua.lsp_document_symbols()
  end, { desc = "lsp document symbols" })
end

return M
