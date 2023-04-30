local M = {}

M.config = function(use)
  use({ "akinsho/toggleterm.nvim", config = M.toggleterm_setup })
end

M.toggleterm_setup = function()
  local ok, toggleterm = pcall(require, "toggleterm")
  if not ok then
    return
  end

  local ok, project = pcall(require, "project_nvim.project")
  if not ok then
    return
  end

  toggleterm.setup({
    start_in_insert = false, -- manually handle autoinsert in all cases (see below)
  })

  vim.keymap.set("n", "<localleader>tt", function()
    local project_root = project.get_project_root()
    toggleterm.toggle(0, 0, project_root, "float")
  end, { desc = "toggle_term_project" })

  local gr = vim.api.nvim_create_augroup("TermToggle", {})
  vim.api.nvim_create_autocmd({ "TermOpen" }, {
    group = gr,
    pattern = { "*#toggleterm#*" },
    callback = function()
      local opts = { buffer = 0 }
      vim.keymap.set("t", "<esc>", [[<C-\><C-n>:ToggleTerm<cr>]], opts)
    end,
  })

  vim.api.nvim_create_autocmd({ "TermOpen", "BufWinEnter", "WinEnter" }, {
    group = gr,
    pattern = { "*#toggleterm#*" },
    callback = function()
      vim.cmd("startinsert")
    end,
  })
end

return M
