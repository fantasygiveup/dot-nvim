local M = {}

-- Shamelessly stolen from https://github.com/nvim-neorg/neorg/blob/main/lua/neorg/modules/core/integrations/treesitter/module.lua.

---Create a norg TS parser from the given source
---@param source string | number | PathlibPath file path or buf number or 0 for current buffer
---@param filetype string vim's filetype for current buffer
---@return vim.treesitter.LanguageTree? norg_parser
---@return string | number iter_src the corresponding source that you must pass to
---`iter_query()`, either the full file text, or the buffer number
M.get_ts_parser = function(source, filetype)
  local ts_parser
  local iter_src
  if type(source) ~= "string" and type(source) ~= "number" then
    source = tostring(source)
  end
  if type(source) == "string" then
    -- check if the file is open; use the buffer contents if it is
    if vim.fn.bufnr(source) ~= -1 then ---@diagnostic disable-line
      source = vim.uri_to_bufnr(vim.uri_from_fname(source))
    else
      iter_src = io.open(source, "r"):read("*a")
      ts_parser = vim.treesitter.get_string_parser(iter_src, filetype)
    end
  end
  if type(source) == "number" then
    if source == 0 then
      source = vim.api.nvim_get_current_buf()
    end
    ts_parser = vim.treesitter.get_parser(source, filetype)
    iter_src = source
  end

  return ts_parser, iter_src
end

M.get_node_text = function(node, source)
  if not node then
    return ""
  end

  -- when source is the string contents of the file
  if type(source) == "string" then
    local _, _, start_bytes = node:start()
    local _, _, end_bytes = node:end_()
    return string.sub(source, start_bytes + 1, end_bytes)
  end

  source = source or 0

  local start_row, start_col = node:start()
  local end_row, end_col = node:end_()

  local eof_row = vim.api.nvim_buf_line_count(source)

  if end_row >= eof_row then
    end_row = eof_row - 1
    end_col = -1
  end

  if start_row >= eof_row then
    return ""
  end

  local lines = vim.api.nvim_buf_get_text(source, start_row, start_col, end_row, end_col, {})

  return table.concat(lines, "\n")
end

--- Parses a query and automatically executes it for Norg
---@param query_string string #The query string
---@param callback function #The callback to execute with all values returned by
---`Query:iter_captures()`. When callback returns true, this function returns early
---@param source number | string | PathlibPath #buf number, or file path or 0 for current buffer
---@param filetype string vim's filetype for current buffer
---@param start number? #The start line for the query
---@param finish number? #The end line for the query
M.execute_query = function(query_string, callback, source, filetype, start, finish)
  local query = utils.ts_parse_query(filetype, query_string)
  local norg_parser, iter_src = module.public.get_ts_parser(source)

  if not norg_parser then
    return false
  end

  local root = norg_parser:parse()[1]:root()
  for id, node, metadata in query:iter_captures(root, iter_src, start, finish) do
    if callback(query, id, node, metadata) == true then
      return true
    end
  end

  return true
end

return M
