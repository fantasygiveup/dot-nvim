-- NOT READY YET!!!
-- Shows file overview using treesitter query. Inspired by Emacs imenu.

local M = {}

local ts_query_lookup = {
  python = [[
  (function_definition
    name: (identifier) @func_name (#offset! @func_name)
  )]],
  lua = [[
  (function_declaration
  name:
    [
      (dot_index_expression)
      (identifier)
    ] @func_name (#offset! @func_name)
  )]],
  go = [[
  (function_declaration
    name: (identifier) @func_name (#offset! @func_name)
  )]],
}

local function get_functions(bufnr, lang, query_string)
  local parser = vim.treesitter.get_parser(bufnr, lang)
  local syntax_tree = parser:parse()[1]
  local root = syntax_tree:root()
  local query = vim.treesitter.parse_query(lang, query_string)
  local func_list = {}

  for _, captures, metadata in query:iter_matches(root, bufnr) do
    local row, col, _ = captures[1]:start()
    local name = vim.treesitter.query.get_node_text(captures[1], bufnr)
    table.insert(func_list, { name, row, col, metadata[1].range })
  end
  return func_list
end

M.show = function()
  local ok, fzf_lua = pcall(require, "fzf-lua")
  if not ok then
    vim.notify("Overview: error load fzf-lua", vim.log.levels.ERROR)
    return
  end

  local fzf_lua_builtin = require("fzf-lua.previewer.builtin")
  local fzf_lua_actions = require("fzf-lua.actions")

  local bufnr = vim.api.nvim_get_current_buf()
  local lang = vim.api.nvim_buf_get_option(bufnr, "filetype")
  local path = vim.api.nvim_buf_get_name(bufnr)

  local query_string = ts_query_lookup[lang]
  if not query_string then
    vim.notify(strings.format("Overview: %s is not supported", lang), vim.log.levels.INFO)
    return
  end

  local ts_parser = vim.treesitter.get_parser(bufnr, lang)
  local ts_syntax_tree = ts_parser:parse()[1]
  local ts_root = ts_syntax_tree:root()
  local ts_query = vim.treesitter.parse_query(lang, query_string)
  local entries = {}

  for _, captures, _ in ts_query:iter_matches(ts_root, bufnr) do
    local row, col, _ = captures[1]:start()
    local name = vim.treesitter.query.get_node_text(captures[1], bufnr)
    table.insert(entries, { name = name, row = row, col = col, kind = "func" })
  end

  if vim.tbl_isempty(entries) then
    vim.notify(strings.format("Overview: no entries"), vim.log.levels.INFO)
    return
  end

  local FzfLuaPreviewer = fzf_lua_builtin.buffer_or_file:extend()

  function FzfLuaPreviewer:new(o, opts, fzf_win)
    FzfLuaPreviewer.super.new(self, o, opts, fzf_win)
    setmetatable(self, FzfLuaPreviewer)
    return self
  end

  local re_entry = "^%[(%d+)%].*$"

  function FzfLuaPreviewer:parse_entry(entry_str)
    local line = entry_str:match(re_entry)
    return {
      path = path,
      line = tonumber(line) or 1,
      col = 1,
    }
  end

  fzf_lua.fzf_exec(function(fzf_cb)
    for _, e in ipairs(entries) do
      fzf_cb(string.format("[%d] %s %s", e.row + 1, e.name, e.kind))
    end
  end, {
    previewer = FzfLuaPreviewer,
    actions = {
      ["default"] = function(selected, opts)
        local line = selected[1]:match(re_entry)
        vim.api.nvim_win_set_cursor(0, { tonumber(line), 0 })
      end,
    },
  })
end

return M
