local M = {}

local vars = require("vars")

M.config = function()
  require("zk").setup({
    picker = "fzf_lua",
    lsp = {
      config = {
        on_attach = function(client, bufnr)
          require("keymap").lsp_diagnostic(bufnr)
          require("keymap").lsp_flow()
          require("keymap").zettelkasten_buffer(bufnr)
        end,
      },
    },
  })

  local commands = require("zk.commands")

  -- Select notes or edit a new one.
  commands.add("ZkEditOrNew", function(options)
    M.edit_or_new(options, { title = "Zk Notes" })
  end)

  commands.add("ZkInsertLinkNormalMode", function(options)
    M.insert_link(false, options, function(err, res)
      if not res then
        error(err)
      end
    end)
  end, { title = "Insert Zk link Normal Mode" })

  commands.add("ZkInsertLinkInsertMode", function(options)
    M.insert_link(false, options, function(err, res)
      if not res then
        error(err)
      else
        vim.cmd("startinsert")
      end
    end)
  end, { title = "Insert Zk link Insert Mode" })

  require("keymap").zettelkasten()
end

function M.edit_or_new(options, picker_options)
  local zk = require("zk")
  local commands = require("zk.commands")

  local picker_options = picker_options or {}
  picker_options.fzf_lua = {
    actions = {
      ["ctrl-e"] = function(selected, opts)
        options = vim.tbl_extend("force", { title = opts.last_query }, options or {})
        commands.get("ZkNew")(options)
      end,
    },
  }

  zk.pick_notes(options, picker_options, function(notes)
    if picker_options and picker_options.multi_select == false then
      notes = { notes }
    end
    for _, note in ipairs(notes) do
      vim.cmd("e " .. note.absPath)
    end
  end)
end

function M.insert_link(selected, opts, cb)
  local zk = require("zk")
  local api = require("zk.api")
  local util = require("zk.util")

  opts = vim.tbl_extend("force", {}, opts or {})

  if not selected then
    location = util.get_lsp_location_from_caret()
  else
    local selected_text = util.get_selected_text()
    if opts["matchSelected"] then
      opts = vim.tbl_extend("force", { match = { selected_text } }, opts or {})
    end
  end

  zk.pick_notes(opts, { title = "Zk Insert link", multi_select = false }, function(note)
    assert(note ~= nil, "Picker failed before link insertion: note is nil")

    local link_opts = {}

    if selected and selected_text ~= nil then
      link_opts.title = selected_text
    end

    api.link(note.path, location, nil, link_opts, cb)
  end)
end

M.todo_toggle = function(bufnr)
  local ts_markdown = require("treesitter.markdown")
  return ts_markdown.todo_section_toggle(bufnr)
end

--- Return to the last no zettelkasten buffer.
M.return_back = function()
  local buffers = vim.api.nvim_list_bufs()

  for _, buffer in ipairs(buffers) do
    if vim.fn.buflisted(buffer) == 1 then
      local filetype = vim.api.nvim_buf_get_option(buffer, "filetype")

      if string.match(filetype, "zettelkasten") then
        vim.api.nvim_buf_delete(buffer, {})
      end
    end
  end
end

return M
