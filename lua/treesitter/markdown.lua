local M = {}

local parser = require("treesitter.parser")

M.get_ts_parser = function(source)
  return parser.get_ts_parser(source, "markdown")
end

M.execute_query = function(query_string, callback, source, start, finish)
  return parser.execute_query(query_string, callback, source, "markdown", start, finish)
end

return M
