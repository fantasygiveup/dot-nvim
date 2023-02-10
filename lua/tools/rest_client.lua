local M = {}

M.config = function(use)
  use({ "rest-nvim/rest.nvim", ft = { "http" }, config = M.rest_nvim_setup })
end

M.rest_nvim_setup = function()
  local ok, rest_nvim = pcall(require, "rest-nvim")
  if not ok then
    return
  end
  rest_nvim.setup({})

  local opts = { silent = true }

  vim.api.nvim_create_autocmd({ "FileType" }, {
      group = vim.api.nvim_create_augroup("RestClient", {}),
      pattern = { "http" },
      callback = function()
        vim.api.nvim_buf_set_keymap(0, "n", "<localleader>cc", "<Plug>RestNvim", opts)
        vim.api.nvim_buf_set_keymap(0, "n", "<localleader>cp", "<Plug>RestNvimPreview", opts)
        vim.api.nvim_buf_set_keymap(0, "n", "<localleader>cr", "<Plug>RestNvimLast", opts)
      end,
  })

  vim.api.nvim_create_autocmd({ "FileType" }, {
      group = vim.api.nvim_create_augroup("RestClientResult", {}),
      pattern = { "httpResult" },
      callback = function()
        vim.api.nvim_buf_set_keymap(0, "n", "q", "<cmd>bd<cr>", opts)
      end,
  })
end

return M
