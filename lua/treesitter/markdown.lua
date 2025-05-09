local M = {}

local ts = require("nvim-treesitter.ts_utils")
local ts_parser = require("treesitter.parser")

local toggle_checkbox = function()
  local node = ts.get_node_at_cursor(nil, true)
  local item = ts_parser.find_parent_node(node, "list_item")
  if not item then
    return
  end

  local unchecked = ts_parser.find_child_node(item, "task_list_marker_unchecked")
  local checked = ts_parser.find_child_node(item, "task_list_marker_checked")
  local box = checked or unchecked

  if box then
    ts_parser.set_node_text(box, {})
    local marker = item:child()
    ts_parser.set_node_text(marker, ts_parser.get_node_text(marker):sub(1, 1))
    return
  end

  local content = ts_parser.find_child_node(item, "paragraph")
  if not content then
    return
  end
  local text = ts_parser.get_node_text(content)

  text[1] = "[ ] " .. text[1]
  ts_parser.set_node_text(content, text)
end

M.toggle_checkbox = function(opts)
  local opts = opts or {}

  if not opts.create then
    opts.create = true
  end

  local node = ts.get_node_at_cursor(nil, true)
  local item = ts_parser.find_parent_node(node, "list_item")
  if not item then
    return
  end

  local unchecked = ts_parser.find_child_node(item, "task_list_marker_unchecked")
  if unchecked then
    ts_parser.set_node_text(unchecked, "[x]")
    return
  end

  local checked = ts_parser.find_child_node(item, "task_list_marker_checked")
  if checked then
    if opts.remove then
      toggle_checkbox()
    else
      ts_parser.set_node_text(checked, "[ ]")
    end
    return
  end

  if opts.create then
    toggle_checkbox()
  end
end

local todo_states = { "TODO", "DONE" }

local next_todo_state = function(current)
  local index

  for i, state in ipairs(todo_states) do
    if string.match(current, state) then
      index = i
      break
    end
  end

  if index == #todo_states then
    return
  end

  return todo_states[index + 1]
end

M.todo_section_toggle = function(bufnr)
  local node = ts.get_node_at_cursor(nil, true)
  local item = ts_parser.find_parent_node(node, "atx_heading")
  if not item then
    return
  end

  local content = ts_parser.find_child_node(item, "inline")
  if not content then
    return
  end

  local text = ts_parser.get_node_text(content, bufnr)[1]
  if not text then
    return
  end

  local b_pos, e_pos, current_state
  for _, state in ipairs(todo_states) do
    b_pos, e_pos, current_state = text:find("^%s*(" .. state .. "%s+)")
    if current_state then
      break
    end
  end

  if not current_state then
    text = todo_states[1] .. " " .. text
    ts_parser.set_node_text(content, text)
    return
  end

  text = string.sub(text, e_pos + 1)
  local next_state = next_todo_state(current_state)

  if next_state then
    text = next_state .. " " .. text
  end
  ts_parser.set_node_text(content, text)
end

M.init = function()
  vim.api.nvim_create_autocmd({ "FileType" }, {
    group = vim.api.nvim_create_augroup("MarkdownTreesitterGroup", {}),
    pattern = "markdown",
    callback = function()
      require("keymap").markdown_ts_buffer(0)
    end,
  })
end

return M
