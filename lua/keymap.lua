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

  vim.keymap.set("n", "[x", "<cmd>cprev<cr>")
  vim.keymap.set("n", "]x", "<cmd>cnext<cr>")
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
  -- See M.luasnip() for details.
  vim.keymap.set("i", "<c-e>", "<c-o>$")
  vim.keymap.set("i", "<c-_>", "<c-o>u") -- [C-/] to undo
  vim.keymap.set("i", "<c-d>", "<del>")
  vim.keymap.set("i", "<c-u>", "<c-g>u<c-u>")
  -- See M.luasnip() for details.
  -- vim.keymap.set("i", "<c-b>", "<left>")
  -- vim.keymap.set("i", "<c-f>", "<right>")
  vim.keymap.set("i", "<c-p>", "<up>")
  vim.keymap.set("i", "<c-n>", "<down>")

  -- Misc.
  vim.keymap.set("n", "<localleader>wn", function()
    vim.opt_local.number = not vim.opt_local.number
    vim.opt_local.relativenumber = not vim.opt_local.relativenumber
  end, { desc = "toggle line number" })

  vim.keymap.set("n", "<localleader>wr", function()
    vim.opt_local.relativenumber = not vim.opt_local.relativenumber
  end, { desc = "toggle relative number" })

  vim.keymap.set("n", "<localleader>wf", function()
    vim.opt_local.foldenable = not vim.opt_local.foldenable
  end, { desc = "toggle folding" })

  vim.keymap.set("n", "<localleader>wc", function()
    if vim.api.nvim_get_option_value("conceallevel", { win = 0 }) ~= 0 then
      vim.opt_local.conceallevel = 0
      return
    end
    vim.opt_local.conceallevel = 2
  end, { desc = "toggle conceal level" })

  vim.keymap.set("n", "<localleader>ww", function()
    vim.opt_local.wrap = not vim.opt_local.wrap
  end, { desc = "toggle text wrapping" })

  vim.keymap.set("n", "<localleader>1", function()
    vim.cmd("e " .. require("vars").scratchpad_file)
  end, { desc = "open scratchpad", silent = true })

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
  vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
  vim.keymap.set("i", "<c-s>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
  vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
  vim.keymap.set("n", "gn", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
end

M.zettelkasten = function()
  local zettelkasten_dir = require("vars").zettelkasten_dir_path

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

  vim.keymap.set(
    "n",
    "<localleader>zt",
    ":ZkTags { notebook_path = '" .. zettelkasten_dir .. "' }<cr>",
    { desc = "zk find by tags", silent = true }
  )

  vim.keymap.set("n", "<localleader>z1", function()
    vim.cmd("e " .. require("vars").todos_file)
  end, { desc = "open todos file", silent = true })
end

M.zettelkasten_bufnr = function(bufnr)
  local zettelkasten_dir_path = require("vars").zettelkasten_dir_path

  vim.keymap.set(
    "n",
    "<cr>",
    "<cmd>lua vim.lsp.buf.definition()<cr>",
    { desc = "zk go to definition", buffer = bufnr, silent = true }
  )

  vim.keymap.set(
    "n",
    "<localleader>zb",
    "<cmd>ZkBacklinks { notebook_path = '" .. zettelkasten_dir_path .. "' }<cr>",
    { desc = "zk backlinks", buffer = bufnr }
  )

  vim.keymap.set(
    "n",
    "<localleader>zi",
    "<cmd>ZkInsertLink { notebook_path = '" .. zettelkasten_dir_path .. "' }<cr>",
    { desc = "zk insert link", buffer = bufnr }
  )

  vim.keymap.set(
    "v",
    "<localleader>zi",
    ":ZkInsertLinkAtSelection { notebook_path = '" .. zettelkasten_dir_path .. "' }<cr>",
    { desc = "zk insert link", buffer = bufnr, silent = true }
  )

  vim.keymap.set(
    "n",
    "<localleader>zl",
    "<cmd>ZkLinks { notebook_path = '" .. zettelkasten_dir_path .. "' }<cr>",
    { desc = "zk links", buffer = bufnr }
  )

  vim.keymap.set("n", "<tab>", "zA", { desc = "toggle fold", buffer = bufnr })
end

M.zen_mode = function()
  vim.keymap.set("n", "<localleader>wz", function()
    require("view.zen_mode").zen_mode()
  end, { desc = "zen mode toggle" })
end

M.tree_sitter = function()
  vim.keymap.set(
    "n",
    "<leader>it",
    "<cmd>lua vim.treesitter.inspect_tree()<cr>",
    { desc = "inspect tree sitter" }
  )
end

M.git_helpers = function()
  git_helpers = require("vc.git_helpers")

  vim.keymap.set("n", "<localleader>gc", function()
    local org_dir_name = require("vars").org_dir_name

    git_helpers.push_current_buffer({ org_dir_name })
  end, { desc = "git push buffer", silent = true })
end

M.hop = function()
  hop = require("hop")

  vim.keymap.set("", "<a-t>", function()
    hop.hint_words({})
  end, { remap = true, desc = "hop_words" })
end

M.colorizer = function()
  vim.keymap.set(
    "n",
    "<localleader>wl",
    "<cmd>ColorizerToggle<cr>",
    { desc = "co[l]orized toggle" }
  )
end

M.cmp_preset = function()
  local cmp = require("cmp")
  local luasnip = require("luasnip")

  return {
    ["<C-n>"] = cmp.mapping.select_next_item({ behavior = "select", count = 1 }),
    ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = "select", count = 1 }),
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-q>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
  }
end

M.luasnip = function()
  local luasnip = require("luasnip")

  vim.keymap.set({ "i", "s" }, "<c-x>", function()
    if luasnip.expand_or_jumpable() then
      return "<plug>luasnip-expand-or-jump"
    end
  end, { expr = true, remap = true })
  vim.keymap.set({ "i", "s" }, "<c-f>", function()
    if luasnip.jumpable(1) then
      luasnip.jump(1)
    else
      vim.cmd("normal! l")
    end
  end, { silent = true })
  vim.keymap.set({ "i", "s" }, "<c-b>", function()
    if luasnip.jumpable(-1) then
      luasnip.jump(-1)
    else
      vim.cmd("normal! h")
    end
  end, { silent = true })
end

M.fzf_builtin = function()
  return {
    ["<A-p>"] = "toggle-preview",
    ["<C-d>"] = "preview-page-down",
    ["<C-u>"] = "preview-page-up",
    ["<F1>"] = "toggle-help",
    ["<F2>"] = "toggle-fullscreen",
  }
end

M.fzf = function()
  local fzf_lua = require("fzf-lua")

  vim.keymap.set("n", "<localleader>b", function()
    fzf_lua.buffers()
  end, { desc = "buffers" })

  vim.keymap.set("n", "<c-t>", function()
    fzf_lua.files({ cmd = vim.env.FZF_DEFAULT_COMMAND })
  end, { desc = "files" })

  vim.keymap.set("n", "<leader>?", function()
    fzf_lua.keymaps()
  end, { desc = "keymaps" })

  vim.keymap.set("n", "<localleader>~", function()
    fzf_lua.filetypes()
  end, { desc = "filetypes" })

  vim.keymap.set("n", "<localleader>r", function()
    fzf_lua.oldfiles()
  end, { desc = "oldfiles" })

  vim.keymap.set("n", "<localleader>gs", function()
    fzf_lua.git_status()
  end, { desc = "git_status" })

  vim.keymap.set("n", "<localleader>gb", function()
    fzf_lua.git_bcommits()
  end, { desc = "git_bcommits" })

  vim.keymap.set("n", "<localleader>gl", function()
    fzf_lua.git_commits()
  end, { desc = "git_commits" })

  vim.keymap.set("v", "<leader>/", function()
    fzf_lua.grep_visual({ rg_opts = require("vars").rg_opts })
  end, { desc = "grep_visual" })

  local function grep_project(opts)
    local opts = opts or {}
    opts.rg_opts = require("vars").rg_opts
    opts.fzf_opts = { ["--nth"] = false }
    opts.no_esc = true
    opts.search = opts.search or ""
    fzf_lua.grep_project(opts)
  end

  vim.keymap.set("n", "<leader>/", grep_project, { desc = "grep_project" })

  vim.keymap.set("n", "<c-s>", function()
    local vars = require("vars")
    grep_project({ prompt = "Notes> ", cwd = vars.org_dir_path })
  end, { desc = "grep_notes" })

  vim.keymap.set("n", "<localleader>v", function()
    fzf_lua.lsp_document_symbols()
  end, { desc = "lsp document symbols" })
end

M.icon_picker = function()
  vim.keymap.set("n", "<a-e>", "<cmd>IconPickerNormal<cr>")
  vim.keymap.set("i", "<a-e>", "<cmd>IconPickerInsert<cr>")
end

return M
