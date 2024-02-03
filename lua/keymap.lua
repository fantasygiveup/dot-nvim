local M = {}

M.setup = function()
  -- Pre. Allows us to map C-c key sequence (see Post below).
  vim.keymap.set("n", "<c-c>", "<nop>")
  vim.keymap.set("i", "<c-c>", "<nop>")

  -- Core.
  vim.g.mapleader = " "
  vim.g.maplocalleader = ","
  vim.keymap.set("n", vim.g.mapleader, "")
  vim.keymap.set("x", vim.g.mapleader, "")
  vim.keymap.set("n", ",", "")
  vim.keymap.set("x", ",", "")
  vim.keymap.set("n", vim.g.maplocalleader, "")
  vim.keymap.set("x", vim.g.maplocalleader, "")

  vim.keymap.set("n", "[f", "<cmd>cprev<cr>")
  vim.keymap.set("n", "]f", "<cmd>cnext<cr>")
  vim.keymap.set("n", "<localleader>ss", "<cmd>setlocal spell! spelllang=en_us<cr>")
  vim.keymap.set("n", "<localleader>su", "<cmd>setlocal spell! spelllang=uk_ua<cr>")
  vim.keymap.set("n", "<localleader>cw", [[<cmd>keeppatterns %s/\s\+$//e<cr>]]) -- remove white spaces
  vim.keymap.set("n", "ZZ", "<cmd>xa<cr>")
  vim.keymap.set("n", "ZQ", "<cmd>qa!<cr>")

  -- Quickfix.
  vim.keymap.set("n", "X", function()
    local nr = vim.api.nvim_win_get_buf(0)
    vim.cmd("cwindow")
    local nr2 = vim.api.nvim_win_get_buf(0)
    if nr == nr2 then
      vim.cmd("cclose")
    end
  end, { desc = "qf_toggle" })

  -- Command line (tcsh style).
  vim.keymap.set("c", "<c-a>", "<home>")
  vim.keymap.set("c", "<c-f>", "<right>")
  vim.keymap.set("c", "<c-b>", "<left>")
  vim.keymap.set("c", "<c-e>", "<end>")
  vim.keymap.set("c", "<c-d>", "<del>")
  vim.keymap.set("c", "<esc>b", "<s-left>")
  vim.keymap.set("c", "<esc>f", "<s-right>")
  vim.keymap.set("c", "<c-t>", [[<c-r>=expand("%:p:h") . "/" <cr>]])

  -- Insert mode (tcsh style).
  vim.keymap.set("i", "<a-b>", "<c-o>b")
  vim.keymap.set("i", "<a-f>", "<c-o>w")
  vim.keymap.set("i", "<a-d>", "<c-o>dw")
  vim.keymap.set("i", "<c-y>", "<c-o>gP")
  vim.keymap.set("i", "<c-w>", "<c-o>db")
  vim.keymap.set("i", "<c-k>", "<c-o>D")
  vim.keymap.set("i", "<c-a>", "<c-o>0")
  vim.keymap.set("i", "<c-e>", "<c-o>$")
  vim.keymap.set("i", "<c-_>", "<c-o>u") -- [C-/] to undo
  vim.keymap.set("i", "<c-d>", "<del>")
  vim.keymap.set("i", "<c-u>", "<c-g>u<c-u>")
  vim.keymap.set("i", "<c-b>", "<left>")
  vim.keymap.set("i", "<c-f>", "<right>")
  vim.keymap.set("i", "<c-p>", "<up>")
  vim.keymap.set("i", "<c-n>", "<down>")

  -- Misc.
  vim.keymap.set("n", "<localleader>wn", function()
    vim.wo.number = not vim.wo.number
    vim.wo.relativenumber = not vim.wo.relativenumber
  end, { desc = "toggle line number" })

  vim.keymap.set("n", "<localleader>wr", function()
    vim.wo.relativenumber = not vim.wo.relativenumber
  end, { desc = "toggle relative number" })

  vim.keymap.set("n", "<localleader>wf", function()
    vim.wo.foldenable = not vim.wo.foldenable
  end, { desc = "toggle folding" })

  vim.keymap.set("n", "<localleader>wc", function()
    if vim.wo.conceallevel ~= 0 then
      vim.wo.conceallevel = 0
      return
    end
    vim.wo.conceallevel = 2
  end, { desc = "toggle conceal level" })

  -- Post.
  -- Bind C-c to ESC, also clean up the highlight.
  vim.keymap.set("n", "<c-c>", "<esc>:noh<cr>", { noremap = true, silent = true })
  vim.keymap.set("i", "<c-c>", "<esc>:noh<cr>", { noremap = true, silent = true })
end

-- LSP stuff.

M.lsp_diagnostic = function(bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }

  vim.keymap.set(
    "n",
    "]d",
    "<cmd>lua vim.diagnostic.goto_next({ severity = require'vars'.diagnostic_severity })<cr>",
    opts
  )
  vim.keymap.set(
    "n",
    "[d",
    "<cmd>lua vim.diagnostic.goto_prev({ severity = require'vars'.diagnostic_severity })<cr>",
    opts
  )
end

M.lsp_flow = function(bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }

  vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
  vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
  vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
  vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
  vim.keymap.set("n", "gh", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
  vim.keymap.set("i", "<c-h>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
  vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
  vim.keymap.set("n", "gn", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
end

M.zettelkasten = function()
  local zettelkasten_dir = require("vars").zettelkasten_dir

  vim.keymap.set(
    "n",
    "<localleader>zn",
    "<cmd>ZkNewInput { notebook_path = '" .. zettelkasten_dir .. "' }<cr>",
    { desc = "zk new" }
  )

  vim.keymap.set(
    "n",
    "<localleader>zf",
    "<cmd>ZkEditOrNew { notebook_path = '" .. zettelkasten_dir .. "' }<cr>",
    { desc = "zk find notes" }
  )

  vim.keymap.set(
    "v",
    "<localleader>zf",
    ":'<,'>ZkMatch { notebook_path = '" .. zettelkasten_dir .. "' }<cr>",
    { desc = "zk match" }
  )

  vim.keymap.set(
    "v",
    "<localleader>zn",
    ":ZkNewFromTitleSelection { notebook_path = '" .. zettelkasten_dir .. "' }<cr>",
    { desc = "zk new from title selection", silent = true }
  )

  vim.keymap.set(
    "n",
    "<localleader>zr",
    ":ZkIndex { notebook_path = '" .. zettelkasten_dir .. "' }<cr>",
    { desc = "zk refersh index", silent = true }
  )
end

M.zettelkasten_bufnr = function(bufnr)
  local zettelkasten_dir = require("vars").zettelkasten_dir

  vim.keymap.set(
    "n",
    "<cr>",
    "<cmd>lua vim.lsp.buf.definition()<cr>",
    { desc = "zk go to definition", buffer = bufnr, silent = true }
  )

  vim.keymap.set(
    "n",
    "<localleader>zb",
    "<cmd>ZkBacklinks { notebook_path = '" .. zettelkasten_dir .. "' }<cr>",
    { desc = "zk backlinks", buffer = bufnr }
  )

  vim.keymap.set(
    "n",
    "<localleader>zi",
    "<cmd>ZkInsertLink { notebook_path = '" .. zettelkasten_dir .. "' }<cr>",
    { desc = "zk insert link", buffer = bufnr }
  )

  vim.keymap.set(
    "v",
    "<localleader>zi",
    ":ZkInsertLinkAtSelection { notebook_path = '" .. zettelkasten_dir .. "' }<cr>",
    { desc = "zk insert link", buffer = bufnr, silent = true }
  )

  vim.keymap.set(
    "n",
    "<localleader>zl",
    "<cmd>ZkLinks { notebook_path = '" .. zettelkasten_dir .. "' }<cr>",
    { desc = "zk links", buffer = bufnr }
  )
end

M.zen_mode = function()
  vim.keymap.set("n", "<localleader>wz", function()
    require("view.zen_mode").zen_mode()
  end, { desc = "zen mode toggle" })
end

return M
