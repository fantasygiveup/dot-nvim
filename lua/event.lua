local api = vim.api
local gen_group = api.nvim_create_augroup("GenericGroup", {})

local function zen_mode(status)
  if status == 1 then
    vim.opt_local.laststatus = 0
    vim.opt_local.cursorline = false
    vim.opt_local.number = false
  else
    vim.opt_local.number = true
    vim.opt_local.cursorline = true
    vim.opt_local.laststatus = 3
  end
end

local function turn_on_zen_mode()
  zen_mode(1)
end
local function turn_off_zen_mode()
  zen_mode(0)
end

local function on_win_close()
  turn_off_zen_mode()
end

local function on_buf_pat(pat, fn)
  local win = api.nvim_get_current_win()
  local buf = api.nvim_win_get_buf(win)
  local buf_name = api.nvim_buf_get_name(buf)
  if buf_name:find(pat, 1, true) == 1 then
    fn()
  end
end

api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = gen_group,
  pattern = { "COMMIT_EDITMSG" },
  callback = function()
    vim.opt_local.spell = true
  end,
})

api.nvim_create_autocmd({ "BufRead, BufNewFile" }, {
  group = gen_group,
  pattern = { "gitconfig" },
  callback = function()
    vim.bo.filetype = "gitconfig"
  end,
})

api.nvim_create_autocmd({ "FileType" }, {
  group = gen_group,
  pattern = { "help" },
  callback = function()
    pcall(vim.cmd, "only")
  end,
})

api.nvim_create_autocmd({ "BufWinEnter" }, {
  group = gen_group,
  pattern = { "*" },
  callback = function()
    require("internal").restore_buf_cursor()
  end,
})

api.nvim_create_autocmd({ "VimResized" }, {
  group = gen_group,
  pattern = { "*" },
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- Special case for term apps like glow, fzf or lf.
api.nvim_create_autocmd({ "WinClosed" }, {
  group = gen_group,
  pattern = { "*" },
  callback = function()
    on_buf_pat("term://", on_win_close)
  end,
})

api.nvim_create_autocmd({ "VimEnter" }, {
  group = gen_group,
  pattern = { "*" },
  callback = function()
    if vim.o.diff then
      for _, win in ipairs(api.nvim_list_wins()) do
        api.nvim_set_current_win(win)
        zen_mode(1)
      end
      vim.cmd("normal! gg")
      return
    end
    on_buf_pat("term://", turn_on_zen_mode)
  end,
})

api.nvim_create_autocmd({ "TermOpen" }, {
  group = gen_group,
  pattern = { "*" },
  callback = function()
    zen_mode(1)
  end,
})

api.nvim_create_autocmd({ "TermLeave" }, {
  group = gen_group,
  pattern = { "*" },
  callback = function()
    zen_mode(0)
  end,
})

--- Code format.

local fmt_group = api.nvim_create_augroup("FormatGroup", {})

api.nvim_create_autocmd({ "BufWritePre" }, {
  group = fmt_group,
  pattern = { "*.go" },
  callback = function()
    vim.lsp.buf.format()
  end,
})

api.nvim_create_autocmd({ "BufWritePost" }, {
  group = fmt_group,
  pattern = {
    "*.lua",
    "*.yaml",
    "*.yml",
    "*.js",
    "*.json",
    "*.py",
    "*.c",
    "*.cpp",
    "*.cc",
    "*.C",
    "*.cxx",
    "*.c++",
    "*.h",
    "*.hh",
    "*.H",
    "*.hxx",
    "*.hpp",
    "*.h++",
  },
  callback = function()
    require("formatter"):formatter()
  end,
})
