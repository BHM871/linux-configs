return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      local config = require("config.debugging")

      config.c_cpp_rust.setup(dap)
      config.java.setup(dap)
      config.dart.setup(dap)

      local opts = {}
      local keymap = vim.keymap.set

      keymap("n", "<F7>", dap.step_into, opts)
      keymap("n", "<F32>", dap.toggle_breakpoint, opts)
      keymap("n", "<F20>", dap.step_out, opts)
      keymap("n", "<F8>", dap.step_over, opts)
      keymap("n", "<F9>", dap.continue, opts)
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      local dapui = require("dapui")
      local daptxt = require("nvim-dap-virtual-text")

      dapui.setup()
      daptxt.setup()

      local dap = require("dap")
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.after.event_terminated.dapui_config = function()
        dapui.close()
        daptxt.refresh()
      end
      dap.listeners.after.event_exited.dapui_config = function()
        dapui.close()
        daptxt.refresh()
      end
    end
  }
}
