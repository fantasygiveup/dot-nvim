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
  use({
      "illia-danko/lf.vim",
      requires = { "rbgrouleff/bclose.vim" },
      config = config.lf,
  })
  use({ "ruifm/gitlinker.nvim", requires = "nvim-lua/plenary.nvim", config = config.gitlinker })
  use({ "numToStr/Comment.nvim", config = config.comment_nvim })
  use({ "kylechui/nvim-surround", config = config.nvim_surround })
  use({ "kyazdani42/nvim-web-devicons" })
  use({ "navarasu/onedark.nvim", config = config.theme })
  use({ "lewis6991/gitsigns.nvim", requires = "nvim-lua/plenary.nvim", config = config.gitsigns })
  use({ "ibhagwan/fzf-lua", config = config.fzf }) -- nvim-web-devicons requires
  use({ "jose-elias-alvarez/null-ls.nvim", config = config.null_ls })
  use({ "folke/which-key.nvim", config = config.which_key })
  use({ "nvim-lualine/lualine.nvim", config = config.status_line })
  use({ "norcalli/nvim-colorizer.lua", config = config.colorizer })
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
  use({ "kazhala/close-buffers.nvim", config = config.close_buffers })
  use({ "stevearc/dressing.nvim", config = config.dressing }) -- better ui of vim.ui.input, vim.ui.select
  use({
      "ziontee113/icon-picker.nvim",
      config = config.icon_picker,
  })
  use({ "aserowy/tmux.nvim", config = config.tmux })
  use({ "folke/zen-mode.nvim", config = config.zen_mode })
  use({ "rest-nvim/rest.nvim", config = config.rest_nvim })

  require("treesitter").setup(use)
  require("completion").setup(use)
  require("debugger").setup(use)

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

vim.keymap.set("n", "<leader>pc", "<cmd>PackerCompile<cr>")
vim.keymap.set("n", "<leader>ps", "<cmd>PackerSync<cr>")
