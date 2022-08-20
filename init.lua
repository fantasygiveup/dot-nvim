local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
end

local packer = require("packer")

packer.startup(function(use)
  local config = require("config")
  config.global()

  use({ "wbthomason/packer.nvim" })
  use({ "elijahdanko/lf.vim", requires = { "rbgrouleff/bclose.vim", opt = true }, config = config.lf })
  use({ "ruifm/gitlinker.nvim", requires = 'nvim-lua/plenary.nvim', config = config.gitlinker })
  use({ "numToStr/Comment.nvim", config = config.comment_nvim })
  use({ "kylechui/nvim-surround", config = config.nvim_surround })
  use({ "kyazdani42/nvim-web-devicons" })
  use({ "elijahdanko/gruvbox.nvim", branch = "feature/distinct-sign" })
  use({ "nvim-lualine/lualine.nvim", config = config.lualine })
  use({ "lewis6991/gitsigns.nvim", requires = "nvim-lua/plenary.nvim", config = config.gitsigns })
  use({ "dense-analysis/ale", config = config.ale })
  use({ "ibhagwan/fzf-lua", config = config.fzf }) -- nvim-web-devicons requires
  use({ "ray-x/go.nvim", config = config.go })
  use({ "aserowy/tmux.nvim", config = config.tmux })
  use({ "neovim/nvim-lspconfig", config = config.lsp })
  use({ "L3MON4D3/LuaSnip", config = config.luasnip })
  use({ "hrsh7th/nvim-cmp",
    requires = {
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "saadparwaiz1/cmp_luasnip" },
      { "andersevenrud/cmp-tmux" },
      { "onsails/lspkind.nvim" },  -- lsp pictograms
      { "hrsh7th/cmp-nvim-lua" },
    }, config = config.cmp })
  use({ "norcalli/nvim-colorizer.lua", config = config.colorizer })
  use({ "ahmedkhalf/project.nvim", config = config.project_nvim })
  use({ "nvim-treesitter/nvim-treesitter", config = config.treesitter })
  use({ "nvim-treesitter/playground", config.treesitter_playground })
  use({ "windwp/nvim-autopairs", config = config.autopairs })
  use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install", setup = function() vim.g.mkdp_filetypes = { "markdown" } end, ft = { "markdown" }, })
  use({ "kazhala/close-buffers.nvim", config = config.close_buffers })
  use({ "gbprod/yanky.nvim", config = config.yanky})
  if packer_bootstrap then
    packer.sync()
  end
end)

require("options")
require("keymap")
require("event")
