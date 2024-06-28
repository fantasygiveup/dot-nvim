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

  -- Create a new note using vim.ui.input api.
  commands.add("ZkNewInput", function(options)
    vim.ui.input({ prompt = "Zk New", relative = "win" }, function(title)
      if not title or title == "" then
        return
      end
      options = vim.tbl_extend("force", { title = title }, options or {})
      commands.get("ZkNew")(options)
    end)
  end)

  require("keymap").zettelkasten()

  vim.api.nvim_create_autocmd({ "FileType" }, {
    group = vim.api.nvim_create_augroup("ZettelkastenGroup", {}),
    pattern = { "markdown" },
    callback = function()
      if require("zk.util").notebook_root(vim.fn.expand("%:p")) ~= nil then
        require("keymap").zettelkasten_bufnr(0)
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

  zk.pick_notes(options, picker_options, function(notes)
    -- Create a new note if no selection.
    if #notes == 0 then
      local title = require("fzf-lua").get_last_query()
      options = vim.tbl_extend("force", { title = title }, options or {})
      commands.get("ZkNew")(options)
      return
    end

    if picker_options and picker_options.multi_select == false then
      notes = { notes }
    end
    for _, note in ipairs(notes) do
      vim.cmd("e " .. note.absPath)
    end
  end)
end

local function open_buffer_file(path)
  if vim.api.nvim_buf_get_name(0) == path then
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

local function fleeting_new_entry(title)
  if not title or title == "" then
    return
  end

  local day = os.date("%Y-%m-%d")
  local weekday = os.date("%A")
  local new_entry = string.format("\n# %s %s: %s\n\n", day, weekday, title)

  local file_path = require("vars").fleeting_notes

  if append_to_file(file_path, new_entry) then
    open_buffer_file(file_path)
    vim.cmd(":edit")
    win_scroll_last_line()
    pcall(vim.cmd, "normal! zo") -- open the fold
  end
end

M.fleeting_open_file = function()
  open_buffer_file(require("vars").fleeting_notes)
end

M.fleeting_toggle_entry = function(bufnr)
  local bufnr = bufnr or 0

  if not vim.api.nvim_buf_is_valid(bufnr) then
    error("zettelkasten: buffer is not valid")
    return
  end

  local ts_markdown = require("treesitter.markdown")

  local cursor_position = vim.api.nvim_win_get_cursor(bufnr)
  local node = ts_markdown.get_first_node_on_line(bufnr, cursor_position[1] - 1)
  print(vim.inspect(ts_markdown.get_node_text(node)))
end

M.fleeting_new_entry = function()
  vim.ui.input({ prompt = "New fleeting", relative = "win" }, fleeting_new_entry)
end

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

return M
