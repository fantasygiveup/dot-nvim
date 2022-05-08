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

local function load_basic_autocmds()
  local definitions = {
    bufs = {
      { { "BufRead", "BufNewFile" }, "COMMIT_EDITMSG", function() vim.opt_local.spell = true end },
      { { "BufRead, BufNewFile" } , "gitconfig", function() vim.bo.filetype = "gitconfig" end },
      { "FileType", "help", function() pcall(vim.cmd, "only") end },
      { "BufWinEnter", "*", function() require"internal".restore_buf_cursor() end },
      { "BufEnter", "*", function ()
        if vim.bo.filetype ~= "help" then
          pcall(vim.cmd, "ProjectRootCD")
        end
      end },
    },

    wins = {
      { "VimResized", "*", function() vim.cmd("tabdo wincmd =") end },
    },

    terminal = {
      { "TermOpen", "*", function()
        vim.opt_local.laststatus = 0
        vim.opt_local.signcolumn = "no"
        vim.opt_local.relativenumber = false
        vim.opt_local.number = false
      end },
      { "TermClose", "*", function()
        vim.opt_local.laststatus = 3
        vim.opt_local.signcolumn = "yes"
        vim.opt_local.relativenumber = true
        vim.opt_local.number = true
      end },
    },
  }

  nvim_create_augroups(definitions)
end

load_basic_autocmds()
