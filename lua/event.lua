local function nvim_create_augroups(definitions)
  for desc, definition in pairs(definitions) do
    for _, spec in pairs(definition) do
      vim.api.nvim_create_autocmd(spec[1], {
        pattern = spec[2],
        callback = spec[3],
        desc = desc,
      })
    end
  end
end

local function zen_mode(status)
  if status == 1 then
    vim.opt_local.laststatus = 0
    vim.opt_local.cursorline = false
  else
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
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_win_get_buf(win)
  local buf_name = vim.api.nvim_buf_get_name(buf)
  if buf_name:find(pat, 1, true) == 1 then
    fn()
  end
end

local function load_basic_autocmds()
  local definitions = {
    bufs = {
      {
        { "BufRead", "BufNewFile" },
        "COMMIT_EDITMSG",
        function()
          vim.opt_local.spell = true
        end,
      },
      {
        { "BufRead, BufNewFile" },
        "gitconfig",
        function()
          vim.bo.filetype = "gitconfig"
        end,
      },
      {
        "FileType",
        "help",
        function()
          pcall(vim.cmd, "only")
        end,
      },
      {
        "BufWinEnter",
        "*",
        function()
          require("internal").restore_buf_cursor()
        end,
      },
      {
        "BufWritePre",
        "*.go",
        function()
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
      },
      {
        "BufWritePost",
        "*.go",
        function()
          require("formatter"):formatter()
        end,
      },
      {
        "BufWritePost",
        "*.lua",
        function()
          require("formatter"):formatter()
        end,
      },
    },

    wins = {
      {
        "VimResized",
        "*",
        function()
          vim.cmd("tabdo wincmd =")
        end,
      },
      -- Special case for term apps like glow, fzf or lf.
      {
        "WinClosed",
        "*",
        function()
          on_buf_pat("term://", on_win_close)
        end,
      },
      {
        "VimEnter",
        "*",
        function()
          if vim.o.diff then
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              vim.api.nvim_set_current_win(win)
              zen_mode(1)
            end
            vim.cmd("normal! gg")
            return
          end
          on_buf_pat("term://", turn_on_zen_mode)
        end,
      },
    },

    zen = {
      {
        "TermOpen",
        "*",
        function()
          zen_mode(1)
        end,
      },
      {
        "TermLeave",
        "*",
        function()
          zen_mode(0)
        end,
      },
    },

    path = {
      {
        { "BufWinEnter", "TermOpen", "TermLeave" },
        "*",
        function()
          pcall(function()
            require("project_nvim.project").on_buf_enter()
          end)
        end,
      },
    },
  }

  nvim_create_augroups(definitions)
end

load_basic_autocmds()
