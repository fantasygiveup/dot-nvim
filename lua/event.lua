local gr = vim.api.nvim_create_augroup("GenericGroup", {})

local M = {}

local function zen(enable)
  if enable == 1 then
    vim.opt_local.laststatus = 0
    vim.opt_local.cursorline = false
    vim.opt_local.number = false
  else
    vim.opt_local.number = true
    vim.opt_local.cursorline = true
    vim.opt_local.laststatus = 3
  end
end

M.config = function()
  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = gr,
    pattern = { "COMMIT_EDITMSG" },
    callback = function()
      vim.opt_local.spell = true
    end,
  })

  vim.api.nvim_create_autocmd({ "BufRead, BufNewFile" }, {
    group = gr,
    pattern = { "gitconfig" },
    callback = function()
      vim.bo.filetype = "gitconfig"
    end,
  })

  vim.api.nvim_create_autocmd({ "FileType" }, {
    group = gr,
    pattern = { "help" },
    callback = function()
      pcall(vim.cmd, "only")
    end,
  })

  vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
    group = gr,
    pattern = { "*" },
    callback = function()
      require("utils.cursor").restore_buffer_pos()
    end,
  })

  vim.api.nvim_create_autocmd({ "VimResized" }, {
    group = gr,
    pattern = { "*" },
    callback = function()
      vim.cmd("tabdo wincmd =")
    end,
  })

  vim.api.nvim_create_autocmd({ "VimEnter" }, {
    group = gr,
    pattern = { "*" },
    callback = function()
      vim.api.nvim_set_hl(0, "@visual", { link = "Visual" }) -- custom markdown tree-sitter highlight

      if vim.o.diff then
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          vim.api.nvim_set_current_win(win)
          zen(1)
        end
        vim.cmd("normal! gg")
        return
      end
    end,
  })
end

return M
