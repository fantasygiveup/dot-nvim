local M = {}

M.setup = function(use)
  use({ "rest-nvim/rest.nvim", config = M.rest_nvim })
end

M.rest_nvim = function()
  local ok, rest_nvim = pcall(require, "rest-nvim")
  if not ok then
    return
  end
  rest_nvim.setup({})

  local opts = { silent = true }

  local gr = vim.api.nvim_create_augroup("RestClient", {})
  vim.api.nvim_create_autocmd({ "FileType" }, {
    group = gr,
    pattern = { "http" },
    callback = function()
      vim.api.nvim_buf_set_keymap(0, "n", "<localleader>cc", "<Plug>RestNvim", opts)
      vim.api.nvim_buf_set_keymap(0, "n", "<localleader>cp", "<Plug>RestNvimPreview", opts)
      vim.api.nvim_buf_set_keymap(0, "n", "<localleader>cr", "<Plug>RestNvimLast", opts)
    end,
  })

  local gr = vim.api.nvim_create_augroup("RestClientResult", {})
  vim.api.nvim_create_autocmd({ "FileType" }, {
    group = gr,
    pattern = { "httpResult" },
    callback = function()
      vim.api.nvim_buf_set_keymap(0, "n", "q", "<cmd>bd<cr>", opts)
    end,
  })
end

return M
