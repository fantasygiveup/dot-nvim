local M = {}

local vars = require("vars")

M.config = function()
  local ok, zk = pcall(require, "zk")
  if not ok then
    return
  end

  zk.setup({ picker = "fzf_lua" })

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

  vim.api.nvim_create_autocmd({ "FileType" }, {
    group = vim.api.nvim_create_augroup("ZettelkastenGroup", {}),
    pattern = { "markdown" },
    callback = function()
      if require("zk.util").notebook_root(vim.fn.expand("%:p")) ~= nil then
        local buf = vim.api.nvim_get_current_buf()
        local filetype = vim.api.nvim_buf_get_option(buf, "filetype")
        vim.api.nvim_buf_set_option(buf, "filetype", filetype .. ".zettelkasten") -- set file type zettelkasten

        require("keymap").zettelkasten_buffer(buf)

        require("utils.async").timer(function()
          require("view.zen_mode").zen_mode(0, 1)
        end)
      end
    end,
  })
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

  local location = util.get_lsp_location_from_selection()
  local selected_text = util.get_text_in_range(util.get_selected_range())

  if not selected then
    location = util.get_lsp_location_from_caret()
  else
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

local function open_buffer_file(path)
  if vim.api.nvim_buf_get_name(0) == path then
    vim.cmd("edit")
    return
  end

  local ok, _ = pcall(vim.cmd, "e " .. path)
  if not ok then
    error("Could not open file: " .. path)
  end

  return ok
end

local function append_to_file(path, s)
  local fd = io.open(path, "r+")
  if not fd then
    error("Unable to open " .. path)
    return
  end

  -- Append a new line if it's not already appended.
  local maybe_eol = "\n"
  local eof = fd:seek("end")
  fd:seek("set", eof - 1)
  if fd:read(1) == maybe_eol then
    maybe_eol = ""
  end
  fd:seek("end")

  fd:write(string.format("%s%s", maybe_eol, s))
  fd:close()
  return 1
end

local function win_scroll_last_line(win, bufnr)
  local win = win or 0
  local bufnr = bufnr or 0
  local buf_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, true)
  vim.api.nvim_win_set_cursor(win, { #buf_lines, 0 })
end

local function fleeting_new_entry()
  local now = string.format("%s", os.date("%Y-%m-%d %a %H:%M"))
  local new_entry = string.format("\n# [%s]  ", now) -- two spaces for a room to edit the line

  local file_path = require("vars").fleeting_notes

  if append_to_file(file_path, new_entry) then
    open_buffer_file(file_path)
    win_scroll_last_line()
    pcall(vim.cmd, "normal! zo") -- [zo]open the fold and [zz]recenter
    vim.cmd(":execute 'normal! A' | startinsert")
  end
end

M.fleeting_open_file = function()
  open_buffer_file(require("vars").fleeting_notes)
end

M.fleeting_todo = function(bufnr)
  local ts_markdown = require("treesitter.markdown")
  return ts_markdown.todo_heading(bufnr)
end

M.fleeting_new_entry = fleeting_new_entry

M.todos_open_file = function()
  if open_buffer_file(require("vars").todos) then
  end
end

M.todos_new_entry = function(title)
  if not title or title == "" then
    return
  end

  local file_path = require("vars").todos
  local new_entry = string.format("- [ ] %s", title)

  if append_to_file(file_path, new_entry) then
    print("New todo: " .. title)

    if vim.api.nvim_buf_get_name(0) == file_path then
      vim.cmd(":edit")
      win_scroll_last_line()
    end
  end
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
