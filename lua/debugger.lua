local M = {}

M.config = function()
  local dap = require("dap")

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

  require("dapui").setup({})
  require("keymap").debugger()
end

return M
