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
    plugins = {
      options = {
        enabled = true,
        ruler = false, -- disables the ruler text in the cmd line area
        showcmd = false, -- disables the command in the last line of the screen
        -- you may turn on/off statusline in zen mode by setting 'laststatus'
        -- statusline will be shown only if 'laststatus' == 3
        laststatus = 0, -- turn off the statusline in zen mode
      },
      gitsigns = { enable = false },
    },
  })

  require("keymap").zen_mode()
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
