local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  })
end

local packer = require("packer")

packer.startup(function(use)
  local config = require("config")
  config.global()

  use({ "wbthomason/packer.nvim" })
  use({ "numToStr/Comment.nvim", config = config.comment_nvim })
  use({ "kylechui/nvim-surround", config = config.nvim_surround })
  use({ "navarasu/onedark.nvim", config = config.theme })
  use({ "jose-elias-alvarez/null-ls.nvim", config = config.null_ls })
  use({ "folke/which-key.nvim", config = config.which_key })
  use({ "nvim-lualine/lualine.nvim", config = config.status_line })
  use({ "ahmedkhalf/project.nvim", config = config.project_nvim })
  use({ "windwp/nvim-autopairs", config = config.autopairs })
  use({
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
    setup = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  })
  use({ "aserowy/tmux.nvim", config = config.tmux })
  use({ "folke/zen-mode.nvim", config = config.zen_mode })
  use({ "rest-nvim/rest.nvim", config = config.rest_nvim })

  require("general_completion").setup(use)
  require("edit_completion").setup(use)
  require("treesitter").setup(use)
  require("debugger").setup(use)
  require("vc").setup(use)
  require("tools").setup(use)

  if packer_bootstrap then
    packer.sync()
  end
end)

local gl = require("global")
gl:load_variables()
gl:ensure_dir()

require("options")
require("keymap")
require("event")
require("event_gpg")
require("vc").hook()

vim.keymap.set("n", "<leader>pc", "<cmd>PackerCompile<cr>")
vim.keymap.set("n", "<leader>ps", "<cmd>PackerSync<cr>")
