local M = {}

M.config = function()
  require("zk").setup({
    picker = "telescope",
    lsp = {
      config = {
        on_attach = function(client, bufnr)
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
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  local picker_options = picker_options or {}
  picker_options.telescope = {
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function(opts)
        local current_picker = action_state.get_current_picker(prompt_bufnr)
        local prompt = current_picker:_get_prompt()
        local selected_entry = action_state.get_selected_entry()
        if selected_entry ~= nil then
          vim.cmd("edit! " .. selected_entry.path)
        else
          options = vim.tbl_extend("force", { title = prompt }, options or {})
          commands.get("ZkNew")(options)
        end
      end)

      -- Create a new entry.
      map("i", "<c-e>", function(prompt_bufnr)
        local current_picker = action_state.get_current_picker(prompt_bufnr)
        local prompt = current_picker:_get_prompt()
        options = vim.tbl_extend("force", { title = prompt }, options or {})
        commands.get("ZkNew")(options)
      end)

      return true
    end,
  }

  zk.pick_notes(options, picker_options)
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
