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

  local toggleterm_float_opts = function()
    return {
      border = "curved",
      width = vim.o.columns,
      height = vim.o.lines - 4,
    }
  end

  toggleterm.setup({
    start_in_insert = false, -- manually handle autoinsert in all cases (see below)
    float_opts = toggleterm_float_opts(),
    shell = "zsh",
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
      vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
      vim.keymap.set("n", "<esc>", [[:ToggleTerm<cr>]], opts)
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
      count = 100, -- use high value to no intersect with regular OpenTerm cmd
      dir = "git_dir",
      direction = "float",
      float_opts = toggleterm_float_opts(),
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

  -- `lf` file manager.
  -- Some parts are taken from https://github.com/lmburns/lf.nvim.
  -- TODO(idanko): consider to move to a mudule.

  vim.g.lf_netrw = 1
  vim.g.lf_replace_netrw = 1
  vim.g.loaded_netrwPlugin = 1
  vim.g.loaded_netrw = 1

  local function open_lf(filename)
    local filename = filename or vim.api.nvim_buf_get_name(0)
    local lf_temp_path = "/tmp/lfpickerpath"
    local lfpicker = Terminal:new({
      cmd = "lf -selection-path " .. lf_temp_path .. " " .. filename,
      count = 101, -- use high value to no intersect with regular OpenTerm cmd
      direction = "float",
      float_opts = toggleterm_float_opts(),
      on_close = function(term)
        local file = io.open(lf_temp_path, "r")
        if file == nil then
          return
        end
        local name = file:read("*a")
        file:close()
        os.remove(lf_temp_path)

        require("utils.async").timer(function()
          vim.cmd("edit " .. name)
        end)
      end,
    })

    lfpicker:toggle()
  end

  vim.keymap.set("n", "-", open_lf, { desc = "lf" })

  -- Replace netrw.

  ---Make `Lf` become the file manager that opens whenever a directory buffer is loaded
  ---@param bufnr integer
  ---@return boolean
  local function become_dir_fman(bufnr)
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    if bufname == "" then
      return false
    end
    local stat = vim.loop.fs_stat(bufname)
    if type(stat) ~= "table" or (type(stat) == "table" and stat.type ~= "directory") then
      return false
    end

    return true
  end

  local gr = vim.api.nvim_create_augroup("Lf_ReplaceNetrw", { clear = true })
  vim.api.nvim_create_autocmd("VimEnter", {
    desc = "Override the default file manager (i.e., netrw)",
    group = gr,
    pattern = "*",
    nested = true,
    callback = function(a)
      if vim.fn.exists("#FileExplorer") then
        vim.api.nvim_create_augroup("FileExplorer", { clear = true })
      end
    end,
  })

  vim.api.nvim_create_autocmd("BufEnter", {
    desc = "After overriding default file manager, open Lf",
    group = gr,
    pattern = "*",
    once = true,
    callback = function(a)
      if become_dir_fman(a.buf) then
        vim.defer_fn(function()
          open_lf(a.file)
        end, 1)
      end
    end,
  })
end

return M
