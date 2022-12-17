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
    "lmburns/lf.nvim",
    requires = { "nvim-lua/plenary.nvim", "akinsho/toggleterm.nvim" },
    config = config.lf,
  })
  use({ "ruifm/gitlinker.nvim", requires = "nvim-lua/plenary.nvim", config = config.gitlinker })
  use({ "numToStr/Comment.nvim", config = config.comment_nvim })
  use({ "kylechui/nvim-surround", config = config.nvim_surround })
  use({ "kyazdani42/nvim-web-devicons" })
  use({ "navarasu/onedark.nvim", config = config.theme })
  use({ "lewis6991/gitsigns.nvim", requires = "nvim-lua/plenary.nvim", config = config.gitsigns })
  use({ "ibhagwan/fzf-lua", config = config.fzf }) -- nvim-web-devicons requires
  use({ "neovim/nvim-lspconfig", config = config.lsp })
  use({ "jose-elias-alvarez/null-ls.nvim", config = config.null_ls })
  use({ "nvim-lualine/lualine.nvim", config = config.status_line })
  use({ "L3MON4D3/LuaSnip", config = config.luasnip })
  use({
    "hrsh7th/nvim-cmp",
    requires = {
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "saadparwaiz1/cmp_luasnip" },
      { "andersevenrud/cmp-tmux" },
      { "onsails/lspkind.nvim" }, -- lsp pictograms
      { "hrsh7th/cmp-nvim-lua" },
      { "hrsh7th/cmp-calc" },
    },
    config = config.cmp,
  })
  use({ "norcalli/nvim-colorizer.lua", config = config.colorizer })
  use({ "ahmedkhalf/project.nvim", config = config.project_nvim })
  use({ "nvim-treesitter/nvim-treesitter", config = config.treesitter })
  use({ "nvim-treesitter/playground", config.treesitter_playground })
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
  use({ "kevinhwang91/nvim-bqf", ft = "qf" })
  use({
    "mfussenegger/nvim-dap",
    requires = { "rcarriga/nvim-dap-ui" },
    config = config.dap,
  })
  use({ "folke/which-key.nvim", config = config.which_key })
  use({ "glepnir/dashboard-nvim", config = config.dashboard })
  use({ "folke/todo-comments.nvim", config = config.todo_comments })
  use({ "Olical/conjure", config = config.conjure })
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
