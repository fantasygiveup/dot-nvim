local M = {}

M.setup = function(use)
  use({
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
    setup = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
    config = M.markdown_preview_setup,
  })
end

M.markdown_preview_setup = function()
  vim.api.nvim_create_autocmd({ "FileType" }, {
    group = vim.api.nvim_create_augroup("RestClient", {}),
    pattern = { "markdown" },
    callback = function()
      vim.api.nvim_buf_set_keymap(
        0,
        "n",
        ",ww",
        "<cmd>MarkdownPreviewToggle<cr>",
        { silent = true, desc = "markdown_preview_browser" }
      )
    end,
  })
end

return M
