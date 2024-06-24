local gr = vim.api.nvim_create_augroup("GenericGroup", {})

local M = {}

M.config = function()
  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = gr,
    pattern = { "COMMIT_EDITMSG" },
    callback = function()
      vim.opt_local.spell = true
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
      if vim.o.diff then
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          vim.api.nvim_set_current_win(win)
          require("view.zen_mode").zen_window(1)
        end
        vim.cmd("normal! gg")
        return
      end
    end,
  })
end

return M
