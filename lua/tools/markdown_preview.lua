local M = {}

M.config = function()
  vim.api.nvim_create_autocmd({ "FileType" }, {
    group = vim.api.nvim_create_augroup("MarkdownPreview", {}),
    pattern = { "markdown" },
    callback = function()
      vim.api.nvim_buf_set_keymap(
        0,
        "n",
        "<localleader>ww",
        "<cmd>MarkdownPreviewToggle<cr>",
        { silent = true, desc = "markdown_preview_browser" }
      )
    end,
  })
end

return M
