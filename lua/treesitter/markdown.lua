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

M.init = function()
  require("keymap").markdown()
end

return M
