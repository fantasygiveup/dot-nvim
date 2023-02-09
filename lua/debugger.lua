local M = {}

M.setup = function(use)
  use({ "mfussenegger/nvim-dap", requires = { "rcarriga/nvim-dap-ui" }, config = M.dap_setup })
end

M.dap_setup = function()
  ok, dap = pcall(require, "dap")
  if not ok then
    return
  end
  dap.adapters.delve = {
    type = "server",
    port = "${port}",
    executable = {
      command = "dlv",
      args = { "dap", "-l", "127.0.0.1:${port}" },
    },
  }

  -- 'dlv' binary is required.
  dap.configurations.go = {
    {
      type = "delve",
      name = "Debug",
      request = "launch",
      program = "${file}",
    },
    {
      type = "delve",
      name = "Debug test",
      request = "launch",
      mode = "test",
      program = "./${relativeFileDirname}",
    },
  }

  vim.fn.sign_define("DapBreakpoint", { text = "" })
  vim.fn.sign_define("DapBreakpointCondition", { text = "" })
  vim.fn.sign_define("DapLogPoint", { text = "" })
  vim.fn.sign_define("DapStopped", { text = "ﭥ" })
  vim.fn.sign_define("DapBreakpointRejected", { text = "" })

  ok, dapui = pcall(require, "dapui")
  if not ok then
    return
  end

  dapui.setup()

  -- Keymap.
  vim.keymap.set("n", "<leader><Space>", "<cmd>lua require'dap'.toggle_breakpoint()<cr>")
  vim.keymap.set(
    "n",
    "<leader>t",
    "<cmd>lua require'dap'.terminate(); require'dap'.clear_breakpoints()<cr>"
  )
  vim.keymap.set("n", "<leader>r", "<cmd>lua require'dap'.run_last()<cr>")
  vim.keymap.set("n", "<leader>c", "<cmd>lua require'dap'.continue()<cr>")
  vim.keymap.set("n", "<leader>n", "<cmd>lua require'dap'.step_over()<cr>")
  vim.keymap.set("n", "<leader>i", "<cmd>lua require'dap'.step_into()<cr>")
  vim.keymap.set("n", "<leader>u", "<cmd>lua require'dapui'.toggle()<cr>")
  vim.keymap.set("v", "<leader>e", "<cmd>lua require'dapui'.eval(); vim.fn.feedkeys('v')<cr>")
end

return M
