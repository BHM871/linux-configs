return {
  setup = function(dap)
    dap.adapters.gdb = {
      id = "gdb",
      type = "executable",
      command = "/usr/bin/gdb",
      args = { "--interpreter=dap", "--eval-command", "set print pretty on" }
    }

    dap.configurations.c = {
      {
        name = "Launch",
        type = "gdb",
        request = "launch",
        program = function()
          return vim.fn.getcwd() .. '/' .. vim.fn.expand('%:t:r')
        end,
        cwd = "${workspaceFolder}",
        stopAtEntry = true,
        stopAtBeginningOfMainSubprogram = false,
        externalConsole = false,
        MIMode = "gdb",
        setupCommands = {
          {
            description = "Enable pretty-printing for gdb",
            text = "-enable-pretty-printing",
            ignoreFailures = true
          },
          {
            description = "Set Disassembly Flavor to Intel",
            text = "-gdb-set disassembly-flavor intel",
            ignoreFailures = true
          }
        },
      },
      {
        name = "Attach",
        type = "gdb",
        request = "attach",
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        pid = function()
          local name = vim.fn.input('Executable name (filter): ')
          return require("dap.utils").pick_process({ filter = name })
        end,
        cwd = '${workspaceFolder}',
        stopAtEntry = true,
        stopAtBeginningOfMainSubprogram = false,
        externalConsole = false,
        MIMode = "gdb",
        setupCommands = {
          {
            description = "Enable pretty-printing for gdb",
            text = "-enable-pretty-printing",
            ignoreFailures = true
          },
          {
            description = "Set Disassembly Flavor to Intel",
            text = "-gdb-set disassembly-flavor intel",
            ignoreFailures = true
          }
        },
      },
    }

    dap.configurations.cpp = dap.configurations.c
    dap.configurations.rust = dap.configurations.c
  end
}
