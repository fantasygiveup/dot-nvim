local M = {}

M.config = function()
  local ok, toggleterm = pcall(require, "toggleterm")
  if not ok then
    return
  end

  local ok, terminal = pcall(require, "toggleterm.terminal")
  if not ok then
    return
  end

  local ok, project = pcall(require, "project_nvim.project")
  if not ok then
    return
  end

  toggleterm.setup({
    start_in_insert = false, -- manually handle autoinsert in all cases (see below)
    float_opts = {
      border = "double",
    },
  })

  -- Remember the opened project assosiated with a terminal session.
  local opened_projects = {}
  vim.keymap.set("n", "<localleader>tt", function()
    local project_root = project.get_project_root()
    index = table.getn(opened_projects) + 1
    for n, p in ipairs(opened_projects) do
      if p == project_root then
        index = n
        break
      end
    end
    if index == table.getn(opened_projects) + 1 then
      table.insert(opened_projects, project_root)
    end
    toggleterm.toggle(index, 0, project_root, "float")
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

  local Terminal = terminal.Terminal
  vim.keymap.set("n", "<localleader>gg", function()
    local lazygit = Terminal:new({
      cmd = "lazygit",
      count = 100, -- use high number to no intersect with regular OpenTerm
      dir = "git_dir",
      direction = "float",
      on_open = function(term)
        vim.cmd("startinsert!")
        vim.api.nvim_buf_set_keymap(
          term.bufnr,
          "n",
          "q",
          "<cmd>close<CR>",
          { noremap = true, silent = true }
        )
      end,
      on_close = function(term)
        vim.cmd("startinsert!")
      end,
    })

    lazygit:toggle()
  end, { desc = "lazygit" })
end

return M
