local api = vim.api
local group = api.nvim_create_augroup("MyGroup", {})

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
  group = group,
  pattern = { "COMMIT_EDITMSG" },
  callback = function()
    vim.opt_local.spell = true
  end,
})

api.nvim_create_autocmd({ "BufRead, BufNewFile" }, {
  group = group,
  pattern = { "gitconfig" },
  callback = function()
    vim.bo.filetype = "gitconfig"
  end,
})

api.nvim_create_autocmd({ "FileType" }, {
  group = group,
  pattern = { "help" },
  callback = function()
    pcall(vim.cmd, "only")
  end,
})

api.nvim_create_autocmd({ "BufWinEnter" }, {
  group = group,
  pattern = { "*" },
  callback = function()
    require("internal").restore_buf_cursor()
  end,
})

api.nvim_create_autocmd({ "BufWritePre" }, {
  group = group,
  pattern = { "*.go" },
  callback = function()
    local params = vim.lsp.util.make_range_params(nil, vim.lsp.util._get_offset_encoding())
    params.context = { only = { "source.organizeImports" } }

    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
    for _, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          vim.lsp.util.apply_workspace_edit(r.edit, vim.lsp.util._get_offset_encoding())
        else
          vim.lsp.buf.execute_command(r.command)
        end
      end
    end
  end,
})

api.nvim_create_autocmd({ "BufWritePre" }, {
  group = group,
  pattern = {
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
    vim.lsp.buf.formatting()
  end,
})

api.nvim_create_autocmd({ "BufWritePost" }, {
  group = group,
  pattern = { "*.go,*.lua,*.yaml,*.yml,*.js,*.json,*.py" },
  callback = function()
    require("formatter"):formatter()
  end,
})

api.nvim_create_autocmd({ "VimResized" }, {
  group = group,
  pattern = { "*" },
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- Special case for term apps like glow, fzf or lf.
api.nvim_create_autocmd({ "WinClosed" }, {
  group = group,
  pattern = { "*" },
  callback = function()
    on_buf_pat("term://", on_win_close)
  end,
})

api.nvim_create_autocmd({ "VimEnter" }, {
  group = group,
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
  group = group,
  pattern = { "*" },
  callback = function()
    zen_mode(1)
  end,
})

api.nvim_create_autocmd({ "TermLeave" }, {
  group = group,
  pattern = { "*" },
  callback = function()
    zen_mode(0)
  end,
})

api.nvim_create_autocmd({ "BufWinEnter", "TermOpen", "TermLeave" }, {
  group = group,
  pattern = { "*" },
  callback = function()
    pcall(function()
      require("project_nvim.project").on_buf_enter()
    end)
  end,
})
