-- Decrypt (buffer read) end encrypt (buffer write) gpg file using system local gpg settings. Works
-- the best with gpg-agent enabled. It is a limited alternative to
-- https://github.com/jamessan/vim-gnupg but written in lua.

local api = vim.api
local group = api.nvim_create_augroup("MyEcryptedGroup", {})

api.nvim_create_autocmd({ "BufReadPre", "FileReadPre" }, {
  group = group,
  pattern = { "*.gpg" },
  callback = function()
    if not vim.o.backupskip or not string.find(vim.o.backupskip, "*.gpg") then
      vim.o.backupskip = vim.o.backupskip .. ",.*gpg"
    end
    vim.opt_local.swapfile = false
    vim.opt_local.bin = true
    vim.opt_local.shada = "" -- disabling saving content to .viminfo
  end,
})

api.nvim_create_autocmd({ "BufReadPost", "FileReadPost" }, {
  group = group,
  pattern = { "*.gpg" },
  callback = function()
    vim.fn.execute([[%!gpg --quiet --decrypt --default-recipient-self]])
    vim.opt_local.bin = false
  end,
})

api.nvim_create_autocmd({ "BufWritePre", "FileWritePre" }, {
  group = group,
  pattern = { "*.gpg" },
  callback = function()
    vim.opt_local.bin = true
    vim.fn.execute([[%!gpg --encrypt --default-recipient-self]])
  end,
})

api.nvim_create_autocmd({ "BufWritePost", "FileWritePost" }, {
  group = group,
  pattern = { "*.gpg" },
  callback = function()
    vim.fn.execute([[silent undo]])
    vim.opt_local.bin = false
  end,
})
