local M = {}

M.config = function()
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

  dapui.setup({})
  require("keymap").debugger()
end

return M
