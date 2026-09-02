return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "BurntSushi/ripgrep",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      require("telescope").setup()

      local builtin = require("telescope.builtin")
      local opts = { noremap = true, silent = true, nowait = true }
      local keymap = vim.keymap.set

      keymap("n", "<M-E>", builtin.oldfiles, opts)
      keymap("n", "<M-e>", builtin.buffers, opts)
      keymap("n", "<M-n>", builtin.find_files, opts)
      keymap("n", "<M-p>", builtin.commands, opts)
      keymap("n", "<M-F>", builtin.live_grep, opts)
      keymap("n", "<M-f>", builtin.current_buffer_fuzzy_find, opts)

      require("telescope").load_extension("fzf")
    end
  },
  {
    "nvim-telescope/telescope-ui-select.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("telescope").setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({})
          }
        }
      })
      require("telescope").load_extension("ui-select")
    end
  }
}
