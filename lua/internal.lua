local function visual_selection_range()
  local _, csrow, cscol, _ = unpack(vim.fn.getpos("'<"))
  local _, cerow, cecol, _ = unpack(vim.fn.getpos("'>"))
  if csrow < cerow or (csrow == cerow and cscol <= cecol) then
    return csrow - 1, cscol - 1, cerow - 1, cecol
  else
    return cerow - 1, cecol - 1, csrow - 1, cscol
  end
end

local function visual_selection()
  local csrow, cscol, cerow, cecol = visual_selection_range()
  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, csrow, cerow+1, false)
  if #lines == 0 then
    return ''
  elseif #lines == 1 then
    lines[1] = string.sub(lines[1], cscol+1, cecol)
  else
    lines[1] = string.sub(lines[1], cscol+1, string.len(lines[1]))
    lines[#lines] = string.sub(lines[#lines], 1, cecol)
  end
  return table.concat(lines, "\n")
end

local function unfold()
  local cl = vim.fn.line(".")

  if not vim.o.foldenable or cl <= 1 then
    return
  end

  local cf = vim.fn.foldlevel(cl)
  local uf = vim.fn.foldlevel(cl - 1)
  local min = math.min(cf, uf)

  if min > 0 then
    vim.fn.execute("normal! " .. tostring(min) .. "zo")
  end
end

-- restore_buf_cursor jumps to the last visited file's position.
local function restore_buf_cursor()
  vim.fn.execute("normal! zM") -- close all folds.
  if vim.fn.line([[`"]]) <= vim.fn.line([[$]]) then
    vim.cmd([[try | exec 'normal! g`"zz' | catch | endtry]])
  end

  -- It looks like vim/nvim doesn't sync cursor position right the way. To work it correctly, we
  -- might wait one more event loop round (similar to sleep(0) in UNIX to context switch.)
  local timer = vim.loop.new_timer()
  timer:start(0, 0, vim.schedule_wrap(unfold))
end

local function qf_toggle()
  local nr = vim.api.nvim_win_get_buf(0)
  vim.cmd("cwindow")
  local nr2 = vim.api.nvim_win_get_buf(0)
  if nr == nr2 then
    vim.cmd("cclose")
  end
end

local function open_scratchpad()
  vim.cmd("edit " .. require("global").scratchpad)
end

local function open_ref()
  vim.cmd("edit " .. require("global").ref)
end

return {
  restore_buf_cursor = restore_buf_cursor,
  visual_selection = visual_selection,
  qf_toggle = qf_toggle,
  open_scratchpad = open_scratchpad,
  open_ref = open_ref,
}
