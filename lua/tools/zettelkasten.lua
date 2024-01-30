local M = {}

local vars = require("vars")

M.config = function()
  local ok, zk = pcall(require, "zk")
  if not ok then
    return
  end

  zk.setup({ picker = "fzf_lua" })

  local commands = require("zk.commands")

  -- Select notes or edit a new one.
  commands.add("ZkEditOrNew", function(options)
    M.edit_or_new(options, { title = "Zk Notes" })
  end)

  -- Create a new note using vim.ui.input api.
  commands.add("ZkNewInput", function(options)
    vim.ui.input({ prompt = "Zk New", relative = "win" }, function(title)
      options = vim.tbl_extend("force", { title = title }, options or {})
      commands.get("ZkNew")(options)
    end)
  end)

  require("keymap").zettelkasten()
end

function M.edit_or_new(options, picker_options)
  local zk = require("zk")
  local commands = require("zk.commands")

  zk.pick_notes(options, picker_options, function(notes)
    -- Create a new note if no selection.
    if #notes == 0 then
      local title = require("fzf-lua").get_last_query()
      options = vim.tbl_extend("force", { title = title }, options or {})
      commands.get("ZkNew")(options)
      return
    end

    if picker_options and picker_options.multi_select == false then
      notes = { notes }
    end
    for _, note in ipairs(notes) do
      vim.cmd("e " .. note.absPath)
    end
  end)
end

return M
