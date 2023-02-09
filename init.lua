local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  packer_bootstrap = vim.fn.system({
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
    "iamcco/markdown-preview.nvim",
    run = "cd app && npm install",
    setup = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  })
  use({ "aserowy/tmux.nvim", config = config.tmux })
  use({ "rest-nvim/rest.nvim", config = config.rest_nvim })

  require("tools.project_nvim").setup(use)
  require("tools.icon_picker").setup(use)
  require("tools.lf").setup(use)
  require("tools.colorizer").setup(use)
  require("tools.close_buffers").setup(use)

  require("formatter_diagnostics").setup(use)
  require("general_completion").setup(use)
  require("edit_completion").setup(use)
  require("frontend").setup(use)
  require("treesitter").setup(use)
  require("debugger").setup(use)
  require("edit").setup(use)
  require("vc").setup(use)

  if packer_bootstrap then
    packer.sync()
  end
end)

local gl = require("global")
gl:load_variables()
gl:ensure_dir()

require("options")
require("keymap").load()
require("event")
require("event_gpg")

require("vc").load()
require("notes").load()

vim.keymap.set("n", "<leader>pc", "<cmd>PackerCompile<cr>")
vim.keymap.set("n", "<leader>ps", "<cmd>PackerSync<cr>")
