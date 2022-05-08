local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
end

local packer = require("packer")

packer.startup(function(use)
  local config = require("config")

  use({ "wbthomason/packer.nvim" })
  use({ "elijahdanko/lf.vim", requires = { "rbgrouleff/bclose.vim", opt = true }, config = config.lf })
  use({ "ruifm/gitlinker.nvim", requires = 'nvim-lua/plenary.nvim', config = config.gitlinker })
  use({ "tpope/vim-commentary" })
  use({ "machakann/vim-sandwich" })
  use({ "junegunn/fzf.vim", requires = "junegunn/fzf", config = config.fzf })
  use({ "rakr/vim-one", config = config.colortheme })
  use({ "nvim-lualine/lualine.nvim", requires = {"kyazdani42/nvim-web-devicons", opt = true}, config = config.lualine })
  use({ "lewis6991/gitsigns.nvim", requires = "nvim-lua/plenary.nvim", config = config.gitsigns })
  use({ "dense-analysis/ale", config = config.ale })
  use({ "jamessan/vim-gnupg", config = config.gnupg })
  use({ "fatih/vim-go", config = config.go })
  use({ "christoomey/vim-tmux-navigator", config = config.tmux })
  use({ "neovim/nvim-lspconfig", config = config.lsp })
  use({ "L3MON4D3/LuaSnip", config = config.luasnip })
  use({ "hrsh7th/nvim-cmp",
    requires = {
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "saadparwaiz1/cmp_luasnip" },
      { "andersevenrud/cmp-tmux" },
      { "PaterJason/cmp-conjure" },
      { "onsails/lspkind.nvim" },
      { "hrsh7th/cmp-nvim-lua" },
    }, config = config.cmp })
  use({ "norcalli/nvim-colorizer.lua", config = config.colorizer })
  use({ "dbakker/vim-projectroot" })
  use({ "elijahdanko/fzf-notes", run = "make bin" })
  use({ "Olical/conjure", requires = { "guns/vim-sexp", "tpope/vim-sexp-mappings-for-regular-people" }})
  use({ "nvim-treesitter/nvim-treesitter", config = config.treesitter })
  use({ "nvim-orgmode/orgmode", config = config.orgmode })
  use({ "windwp/nvim-autopairs", config = config.autopairs })
  use({ "TimUntersberger/neogit", requires = "nvim-lua/plenary.nvim" })
  if packer_bootstrap then
    packer.sync()
  end
end)

require("options")
require("keymap")
require("event")
