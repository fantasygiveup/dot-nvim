local M = {}

M.config = function()
  local dressing = require("dressing").setup({
    input = {
      get_config = function(opts)
        return opts
      end,
    },
  })

  local keymap = require("keymap")

  telescope = require("telescope")
  telescope.setup({
    extensions = {
      fzf = {
        fuzzy = false,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      },
    },
    defaults = {
      mappings = { i = keymap.fzf_builtin() },
      prompt_prefix = "🔭 ",
      -- Full screen, equal panels, prompt and content top.
      layout_config = {
        prompt_position = "top",
        width = 1000,
        height = 1000,
        preview_width = 0.5,
        anchor = "CENTER",
      },
      sorting_strategy = "ascending",
      vimgrep_arguments = require("vars").rg_opts,
    },
  })

  telescope.load_extension("fzf")

  keymap.fzf()
end

return M
