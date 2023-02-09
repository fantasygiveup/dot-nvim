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
  use({ "ahmedkhalf/project.nvim", config = config.project_nvim })
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

  require("formatter_diagnostics").setup(use)
  require("general_completion").setup(use)
  require("edit_completion").setup(use)
  require("frontend").setup(use)
  require("treesitter").setup(use)
  require("debugger").setup(use)
  require("edit").setup(use)
  require("vc").setup(use)

  require("tools.icon_picker").setup(use)
  require("tools.lf").setup(use)
  require("tools.colorizer").setup(use)
  require("tools.close_buffers").setup(use)

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
require("notes").hook()
require("keymap").hook()

vim.keymap.set("n", "<leader>pc", "<cmd>PackerCompile<cr>")
vim.keymap.set("n", "<leader>ps", "<cmd>PackerSync<cr>")
