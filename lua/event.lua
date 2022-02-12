local function nvim_create_augroups(definitions)
  for group_name, definition in pairs(definitions) do
    vim.api.nvim_command("augroup "..group_name)
    vim.api.nvim_command("autocmd!")
    for _, def in ipairs(definition) do
      local command = table.concat(vim.tbl_flatten({ "autocmd", def }), " ")
      vim.api.nvim_command(command)
    end
    vim.api.nvim_command("augroup END")
  end
end

local function load_basic_autocmds()
  local definitions = {
    bufs = {
      { "BufRead,BufNewFile", "COMMIT_EDITMSG", "setlocal spell" },
      { "BufRead,BufNewFile", "gitconfig", "setfiletype gitconfig" },
      { "FileType", "help", "only" },
      { "BufWinEnter", "*", "lua require'internal'.restore_buf_cursor()" },
    },

    wins = {
      { "VimResized", "*", "tabdo wincmd =" },
    },

    terminal = {
      { "TermOpen", "*", [[setlocal laststatus=0 signcolumn=no |
      autocmd BufLeave <buffer> setlocal signcolumn=yes laststatus=2]] },
    },
  }

  nvim_create_augroups(definitions)
end

load_basic_autocmds()
