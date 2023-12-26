local M = {}

M.config = function()
  local ok, noice = pcall(require, "noice")
  if not ok then
    return
  end

  noice.setup({
    lsp = {
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    -- you can enable a preset for easier configuration
    presets = {
      bottom_search = true, -- use a classic bottom cmdline for search
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = false, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = false, -- add a border to hover docs and signature help
    },
    -- Filter messages.
    routes = {
      -- Write to file.
      {
        filter = {
          event = "msg_show",
          kind = "",
          find = "%dB written",
        },
        opts = { skip = true },
      },
      -- Yank.
      {
        filter = {
          event = "msg_show",
          kind = "",
          find = "%d lines yanked",
        },
        opts = { skip = true },
      },
      -- Paste.
      {
        filter = {
          event = "msg_show",
          kind = "",
          find = "%d lines changed",
        },
        opts = { skip = true },
      },
      -- Undo|Redo.
      {
        filter = {
          event = "msg_show",
          kind = "",
          find = "%d fewer lines",
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "msg_show",
          kind = "",
          find = "%d more line",
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "msg_show",
          kind = "",
          find = "%d line less",
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "msg_show",
          kind = "",
          find = "%d changes; before #%d",
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "msg_show",
          kind = "",
          find = "%d changes; after #%d",
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "msg_show",
          kind = "",
          find = "%d change; before #%d",
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = "msg_show",
          kind = "",
          find = "%d change; after #%d",
        },
        opts = { skip = true },
      },
    },
  })
end

return M
