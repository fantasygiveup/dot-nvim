local function ensure_vars()
  local vars = require("vars")
  vars:load_variables()
  vars:ensure_dir()
  vars:load_options()
end

ensure_vars()
require("keymap").init()

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local ok, lazy = pcall(require, "lazy")
if not ok then
  error("lazy nvim is not installed")
  return
end

lazy.setup({
  { "ahmedkhalf/project.nvim", config = require("tools.project_nvim").config },
  { "akinsho/toggleterm.nvim", config = require("tools.toggleterm").config },
  {
    "navarasu/onedark.nvim",
    dependencies = { "rktjmp/fwatch.nvim" },
    config = require("view.theme").config,
  },
  { "folke/which-key.nvim", config = require("view.which_key").config },
  { "nvim-lualine/lualine.nvim", config = require("status_line").config },
  { "ziontee113/icon-picker.nvim", config = require("tools.icon_picker").config },
  { "aserowy/tmux.nvim", config = require("tools.tmux").config },
  { "kazhala/close-buffers.nvim", config = require("tools.buffers").config },
  { "jose-elias-alvarez/null-ls.nvim", config = require("formatter_diagnostics").config },
  { "folke/zen-mode.nvim", config = require("view.zen_mode").config },
  {
    "ibhagwan/fzf-lua",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "stevearc/dressing.nvim",
    },
    config = require("fzf").config,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "saadparwaiz1/cmp_luasnip",
      "andersevenrud/cmp-tmux",
      "hrsh7th/cmp-calc",
    },
    config = require("completion").config,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = require("lsp").config,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/playground",
      "windwp/nvim-ts-autotag",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = require("treesitter").config,
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = { "rcarriga/nvim-dap-ui" },
    config = require("debugger").config,
  },
  { "numToStr/Comment.nvim", config = require("edit.comment").config },
  { "kylechui/nvim-surround", config = require("edit.surround").config },
  { "windwp/nvim-autopairs", config = require("edit.autopairs").config },
  { "phaazon/hop.nvim", branch = "v2", config = require("edit.hop").config },
  { "ruifm/gitlinker.nvim", config = require("vc.gitlinker").config },
  { "lewis6991/gitsigns.nvim", config = require("vc.gitsigns").config },
  { "kevinhwang91/nvim-bqf", ft = "qf" },
  -- By forcing use a commit hash, ensure that pipe to stdin works.
  -- See https://github.com/nvimdev/dashboard-nvim/issues/443
  { "nvimdev/dashboard-nvim", config = require("tools.dashboard").config, commit = "c71cab740e2a" },
  { "zk-org/zk-nvim", config = require("tools.zettelkasten").config },
  { "NvChad/nvim-colorizer.lua", config = require("view.colorizer").config },
  {
    "folke/todo-comments.nvim",
    config = require("edit.todo_comments").config,
    dependencies = { "nvim-lua/plenary.nvim" },
    after = { "nvim-treesitter/nvim-treesitter" },
  },
})

require("event").init()
require("tools.gpg").init()
require("fzf.project").init()
require("vc.git_helpers").init()
require("view.theme").init()
require("custom").init()
require("treesitter.markdown").init()
