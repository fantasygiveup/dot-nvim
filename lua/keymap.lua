local M = {}

M.init = function()
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
  vim.keymap.set("n", "<localleader>se", "<cmd>setlocal spell! spelllang=en_us<cr>")
  vim.keymap.set("n", "<localleader>su", "<cmd>setlocal spell! spelllang=uk_ua<cr>")
  vim.keymap.set(
    "n",
    "<localleader>cw",
    [[<cmd>keeppatterns %s/\s\+$//e<cr>]],
    { desc = "clean trailing whitespaces" }
  ) -- remove white spaces
  vim.keymap.set(
    "n",
    "<localleader>ce",
    [[<cmd>%!sed -r 's/\x1b\[[0-9;]*m//g'<cr>]],
    { desc = "clean ansi codes" }
  ) -- remove white spaces
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
  end, { desc = "quickfix toggle" })

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
    for _, name in pairs({ "number", "relativenumber" }) do
      local opt = vim.api.nvim_win_get_option(0, name)
      vim.api.nvim_win_set_option(0, name, not opt)
    end
  end, { desc = "toggle line number" })

  vim.keymap.set("n", "<localleader>wl", function()
    for _, name in pairs({ "cursorline" }) do
      local opt = vim.api.nvim_win_get_option(0, name)
      vim.api.nvim_win_set_option(0, name, not opt)
    end
  end, { desc = "toggle cursor line" })

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
  local dir = require("vars").notes_dir_path

  vim.keymap.set(
    "n",
    "<localleader>zn",
    "<cmd>ZkEditOrNew { notebook_path = '" .. dir .. "' }<cr>",
    { desc = "zk find or create", silent = true }
  )

  vim.keymap.set(
    "v",
    "<localleader>zf",
    ":'<,'>ZkMatch { notebook_path = '" .. dir .. "' }<cr>",
    { desc = "zk match", silent = true }
  )

  vim.keymap.set("n", "<localleader>zr", function()
    local zk = require("zk")
    zk.index({ notebook_path = dir })
  end, { desc = "zk refersh index", silent = true })

  vim.keymap.set(
    "n",
    "<localleader>zt",
    ":ZkTags { notebook_path = '" .. dir .. "' }<cr>",
    { desc = "zk find by tags", silent = true }
  )

  vim.keymap.set("n", "<localleader>zv", function()
    vim.cmd("e " .. require("vars").fleeting_notes)
  end, { desc = "visit fleeting note", silent = true })
end

M.zettelkasten_buffer = function(bufnr)
  local dir = require("vars").notes_dir_path

  vim.keymap.set(
    "n",
    "<cr>",
    "<cmd>lua vim.lsp.buf.definition()<cr>",
    { desc = "zk go to definition", buffer = bufnr, silent = true }
  )

  vim.keymap.set(
    "n",
    "<localleader>zb",
    "<cmd>ZkBacklinks { notebook_path = '" .. dir .. "' }<cr>",
    { desc = "zk backlinks", buffer = bufnr }
  )

  vim.keymap.set(
    "n",
    "<localleader>zi",
    "<cmd>ZkInsertLinkNormalMode { notebook_path = '" .. dir .. "' }<cr>",
    { desc = "zk insert link", buffer = bufnr }
  )

  vim.keymap.set("i", "<c-v>", function()
    vim.cmd("ZkInsertLinkInsertMode { notebook_path = '" .. dir .. "' }")
  end, { desc = "zk insert link insert mode", buffer = bufnr })

  vim.keymap.set(
    "v",
    "<localleader>zi",
    ":ZkInsertLinkAtSelection { notebook_path = '" .. dir .. "' }<cr>",
    { desc = "zk insert link", buffer = bufnr, silent = true }
  )

  vim.keymap.set(
    "n",
    "<localleader>zl",
    "<cmd>ZkLinks { notebook_path = '" .. dir .. "' }<cr>",
    { desc = "zk links", buffer = bufnr }
  )

  vim.keymap.set("n", "<Space><CR>", function()
    require("tools.zettelkasten").return_back()
  end, { desc = "zk return to editor", buffer = bufnr })
end

M.zen_mode = function()
  vim.keymap.set("n", "<localleader>wz", function()
    require("view.zen_mode").zen_mode()
  end, { desc = "zen mode toggle" })
end

M.tree_sitter = function()
  vim.keymap.set(
    "n",
    "<localleader>wT",
    "<cmd>lua vim.treesitter.inspect_tree()<cr>",
    { desc = "inspect tree sitter" }
  )

  vim.keymap.set(
    "n",
    "<localleader>wt",
    "<cmd>TSHighlightCapturesUnderCursor<cr>",
    { desc = "inspect tree sitter cursor" }
  )
end

M.hop = function()
  hop = require("hop")

  vim.keymap.set("", "<a-t>", function()
    hop.hint_words({})
  end, { remap = true, desc = "hop" })
end

M.colorizer = function()
  vim.keymap.set("n", "<localleader>wi", "<cmd>ColorizerToggle<cr>", { desc = "colorized toggle" })
end

M.cmp_preset = function()
  local cmp = require("cmp")
  local luasnip = require("luasnip")

  return {
    ["<c-n>"] = cmp.mapping.select_next_item({ behavior = "select", count = 1 }),
    ["<c-p>"] = cmp.mapping.select_prev_item({ behavior = "select", count = 1 }),
    ["<c-b>"] = cmp.mapping.scroll_docs(-4),
    ["<c-f>"] = cmp.mapping.scroll_docs(4),
    ["<c-q>"] = cmp.mapping.abort(),
    ["<cr>"] = cmp.mapping.confirm({ select = true }),
    ["<c-t>"] = cmp.mapping.confirm({ select = true }),
    ["<tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
  }
end

M.luasnip = function()
  local luasnip = require("luasnip")

  vim.keymap.set({ "i", "s" }, "<c-e>", function()
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
    ["<a-p>"] = "toggle-preview",
    ["<c-d>"] = "preview-page-down",
    ["<c-u>"] = "preview-page-up",
    ["<f1>"] = "toggle-help",
    ["<f2>"] = "toggle-fullscreen",
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

  vim.keymap.set("n", "<localleader>rr", function()
    fzf_lua.resume()
  end, { desc = "resume menu" })

  vim.keymap.set("n", "<localleader>rf", function()
    fzf_lua.oldfiles()
  end, { desc = "show recent files" })

  vim.keymap.set("n", "<localleader>gs", function()
    fzf_lua.git_status()
  end, { desc = "git status" })

  vim.keymap.set("n", "<localleader>gb", function()
    fzf_lua.git_bcommits()
  end, { desc = "git buffer commits" })

  vim.keymap.set("n", "<localleader>gl", function()
    fzf_lua.git_commits()
  end, { desc = "git commits" })

  local function grep_project(opts)
    local opts = opts or {}
    opts.rg_opts = require("vars").rg_opts
    opts.fzf_opts = { ["--nth"] = false }
    opts.no_esc = true
    opts.search = opts.search or ""
    fzf_lua.grep_project(opts)
  end

  vim.keymap.set("n", "<localleader>ss", function()
    grep_project({ rg_opts = require("vars").rg_opts })
  end, { desc = "live grep project" })

  vim.keymap.set("v", "<localleader>ss", function()
    fzf_lua.grep_visual({
      rg_opts = require("vars").rg_opts,
      search = input,
    })
  end, { desc = "grep project visual" })

  vim.keymap.set("n", "<localleader>sS", function()
    grep_project({
      rg_opts = require("vars").rg_opts,
      cwd = require("utils.file").current_directory(),
    })
  end, { desc = "live grep current directory" })

  vim.keymap.set("n", "<localleader>sf", function()
    vim.ui.input({ prompt = "grep project", relative = "win" }, function(input)
      if input then
        grep_project({ rg_opts = require("vars").rg_opts, search = input })
      end
    end)
  end, { desc = "grep project" })

  vim.keymap.set("n", "<localleader>sF", function()
    vim.ui.input({ prompt = "grep current directory", relative = "win" }, function(input)
      if input then
        grep_project({
          rg_opts = require("vars").rg_opts,
          search = input,
          cwd = require("utils.file").current_directory(),
        })
      end
    end)
  end, { desc = "grep current directory" })

  vim.keymap.set("v", "<localleader>sS", function()
    fzf_lua.grep_visual({
      rg_opts = require("vars").rg_opts,
      search = input,
      cwd = require("utils.file").current_directory(),
    })
  end, { desc = "grep current directory visual" })

  vim.keymap.set("n", "<c-s>", function()
    local vars = require("vars")

    fzf_lua.grep_project({
      prompt = "Notes> ",
      rg_opts = vars.rg_opts,
      cwd = vars.notes_dir_path,
    })
  end, { desc = "grep notes" })

  vim.keymap.set("n", "<localleader>v", function()
    fzf_lua.lsp_document_symbols()
  end, { desc = "lsp document symbols" })
end

M.fzf_project = function()
  vim.keymap.set(
    "n",
    "<c-g>",
    "<cmd>lua require'fzf.project'.navigate()<cr>",
    { desc = "switch other project" }
  )
end

M.icon_picker = function()
  vim.keymap.set("n", "<a-e>", "<cmd>IconPickerNormal<cr>")
  vim.keymap.set("i", "<a-e>", "<cmd>IconPickerInsert<cr>")
end

M.markdown_ts_buffer = function(bufnr)
  vim.keymap.set("n", "<c-x><c-x>", function()
    require("treesitter.markdown").toggle_checkbox({ create = true })
  end, { desc = "toggle markdown checkbox", buffer = bufnr })

  vim.keymap.set("n", "<Space><Space>", function()
    require("treesitter.markdown").todo_section_toggle(bufnr)
  end, { desc = "markdown toggle todo", buffer = bufnr })
end

M.buffers = function()
  local project = require("project_nvim.project")
  local close_buffers = require("close_buffers")

  vim.keymap.set("n", "<localleader>db", "<cmd>bp | bd#<cr>", { desc = "close current buffer" })

  vim.keymap.set("n", "<localleader>do", function()
    close_buffers.wipe({ type = "other", force = true })
  end, { desc = "close other buffers" })

  vim.keymap.set("n", "<localleader>da", function()
    close_buffers.wipe({ type = "all", force = true })
  end, { desc = "close all buffers" })

  vim.keymap.set("n", "<localleader>dp", function()
    local project_root = project.get_project_root()
    close_buffers.wipe({ regex = project_root, force = true })
  end, { desc = "close project buffers" })
end

M.git_linker = function()
  vim.keymap.set(
    { "n", "v" },
    "<localleader>gu",
    require("gitlinker").link,
    { silent = true, noremap = true, desc = "copy git url" }
  )

  vim.keymap.set({ "n", "v" }, "<localleader>gU", function()
    require("gitlinker").link({ action = require("gitlinker.actions").system })
  end, { silent = true, noremap = true, desc = "open git url" })
end

M.terminal_multiplexer = function()
  vim.keymap.set("n", "<c-h>", require("smart-splits").move_cursor_left)
  vim.keymap.set("n", "<c-j>", require("smart-splits").move_cursor_down)
  vim.keymap.set("n", "<c-k>", require("smart-splits").move_cursor_up)
  vim.keymap.set("n", "<c-l>", require("smart-splits").move_cursor_right)

  vim.keymap.set("n", "<a-s-h>", require("smart-splits").resize_left)
  vim.keymap.set("n", "<a-s-j>", require("smart-splits").resize_down)
  vim.keymap.set("n", "<a-s-k>", require("smart-splits").resize_up)
  vim.keymap.set("n", "<a-s-l>", require("smart-splits").resize_right)
end

M.gitsigns = function()
  local actions = require("gitsigns.actions")

  vim.keymap.set("n", "<localleader>ga", "<cmd>lua require'gitsigns'.blame_line({full=true})<cr>")
  vim.keymap.set("n", "ghp", "<cmd>lua require'gitsigns'.preview_hunk()<cr>")
  vim.keymap.set("n", "ghu", "<cmd>lua require'gitsigns'.reset_hunk()<cr>")
  vim.keymap.set("n", "ghs", "<cmd>lua require'gitsigns'.stage_hunk()<cr>")
  vim.keymap.set("n", "gh#", "<cmd>lua require'gitsigns'.reset_buffer()<cr>")

  vim.keymap.set("n", "]c", function()
    if vim.o.diff then
      pcall(vim.cmd, "normal! ]czz")
      return
    end

    actions.next_hunk()
    pcall(vim.cmd, "normal! zz")
  end, { desc = "next hunk" })

  vim.keymap.set("n", "[c", function()
    if vim.o.diff then
      pcall(vim.cmd, "normal! [czz")
      return
    end

    actions.prev_hunk()
    pcall(vim.cmd, "normal! zz")
  end, { desc = "prev hunk" })
end

M.debugger = function()
  -- Keymap.
  vim.keymap.set("n", "<localleader>at", "<cmd>lua require'dap'.toggle_breakpoint()<cr>")
  vim.keymap.set(
    "n",
    "<localleader>ad",
    "<cmd>lua require'dap'.terminate(); require'dap'.clear_breakpoints()<cr>"
  )
  vim.keymap.set("n", "<localleader>ar", "<cmd>lua require'dap'.run_last()<cr>")
  vim.keymap.set("n", "<localleader>ac", "<cmd>lua require'dap'.continue()<cr>")
  vim.keymap.set("n", "<localleader>an", "<cmd>lua require'dap'.step_over()<cr>")
  vim.keymap.set("n", "<localleader>ai", "<cmd>lua require'dap'.step_into()<cr>")
  vim.keymap.set("n", "<localleader>ao", "<cmd>lua require'dapui'.toggle()<cr>")
  vim.keymap.set("v", "<localleader>ae", "<cmd>lua require'dapui'.eval(); vim.fn.feedkeys('v')<cr>")
end

M.lf = function(cb)
  vim.keymap.set("n", "-", cb, { desc = "lf file explorer" })
end

M.yanky = function()
  vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
  vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
  vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
  vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")

  vim.keymap.set("n", "<c-p>", "<Plug>(YankyNextEntry)")
  vim.keymap.set("n", "<c-n>", "<Plug>(YankyPreviousEntry)")
end

M.bookmarks = function()
  vim.keymap.set("n", "<leader>mm", "<cmd>BookmarksGoto<cr>")
  vim.keymap.set(
    "n",
    "<leader>ma",
    require("tools.bookmarks").toggle_bookmark,
    { desc = "toggle bookmark" }
  )
end

return M
