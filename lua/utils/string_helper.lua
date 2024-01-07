local M = {}

M.fields = function(s)
  local tokens = {}

  for token in s:gmatch("%S+") do
    table.insert(tokens, token)
  end

  return tokens
end

return M
