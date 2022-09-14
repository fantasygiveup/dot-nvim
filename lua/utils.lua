local M = {}

M.int2rgb = function(color)
  bit = require("bit")
  local r = bit.rshift(bit.band(color, 0xFF0000), 16)
  local g = bit.rshift(bit.band(color, 0x00FF00), 8)
  local b = bit.band(color, 0x0000FF)
  return string.format("#%02x%02x%02x", r, g, b)
end

return M
