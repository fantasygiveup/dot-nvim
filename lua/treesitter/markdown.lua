local M = {}

local parser = require("treesitter.parser")

M.get_ts_parser = function(source)
  return parser.get_ts_parser(source, "markdown")
end

M.get_document_root = function(src)
  return parser.get_document_root(src, "markdown")
end

M.get_first_node_on_line = function(buf, line, stop_type)
  return parser.get_first_node_on_line(buf, line, stop_type, "markdown")
end

M.get_node_text = function(node, source)
  return parser.get_node_text(node, source)
end

M.execute_query = function(query_string, callback, source, start, finish)
  return parser.execute_query(query_string, callback, source, "markdown", start, finish)
end

return M
