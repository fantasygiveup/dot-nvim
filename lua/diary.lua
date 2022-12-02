local M = {}

M.new_entry = function()
  vim.ui.input("New Diary", function(title)
    if not title or title == "" then
      return
    end

    local zen_mode = require("internal").zen_mode_textwidth
    local file_name = require("global").diary
    local day = os.date("%Y-%m-%d")
    local weekday = os.date("%A")
    -- NOTE: consider to rewrite to pure vim api.
    local status = os.execute(
      "echo >> "
        .. file_name
        .. "; echo '"
        .. "# "
        .. day
        .. " "
        .. weekday
        .. ": "
        .. title
        .. "' >> "
        .. file_name
        .. "; echo >> "
        .. file_name
        .. "; echo >> "
        .. file_name
    )

    if status ~= 0 then
      print("Unable to write to " .. file_name)
      return
    end

    vim.cmd(":edit " .. file_name)
    vim.cmd(":normal! Gzo") -- go bottom; open the fold
    zen_mode(5)
  end)
end

return M
