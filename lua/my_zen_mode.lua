local M = {}

M.config = function()
  local ok, zen_mode = pcall(require, "zen-mode")
  if not ok then
    return
  end

  zen_mode.setup({
    window = {
      backdrop = 1.0,
      width = 80,
      options = {
        wrap = true,
        signcolumn = "no",
        number = false,
        relativenumber = false,
        cursorline = false,
        cursorcolumn = false,
        foldcolumn = "0",
        list = false,
      },
    },
  })

  vim.keymap.set(
    "n",
    "<localleader>z",
    "<cmd>lua require'appearance'.zen_mode()<cr>",
    { desc = "zen_mode_toggle" }
  )
end

M.zen_mode = function(extra_width, direction)
  local ok, view = pcall(require, "zen-mode.view")
  if not ok then
    return
  end
  local extra_width = extra_width or 0
  local direction = direction or 0

  local fn = view.toggle
  if direction > 0 then
    fn = view.open
  elseif direction < 0 then
    fn = view.close
  end

  local opts = {
    window = {
      width = vim.bo.textwidth + extra_width,
    },
  }

  fn(opts)
end

return M
