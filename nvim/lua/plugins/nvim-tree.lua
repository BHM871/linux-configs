return {
  "nvim-tree/nvim-tree.lua",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    vim.opt.termguicolors = true

    require("nvim-tree").setup({
      sort = {
        sorter = "case_sensitive",
      },
      view = {
        width = 30,
      },
      renderer = {
        group_empty = true,
      },
    })

    local api = require("nvim-tree.api")
    local opts = { noremap = true, silent = true, nowait = true }
    local keymap = vim.keymap.set

    api.tree.toggle = function()
      local tree = require("nvim-tree.api").tree

      if tree.is_tree_buf(nil) then
        tree.close()
      else
        tree.focus()
      end
    end

    keymap("n", "<A-1>", api.tree.toggle, opts)
  end
}
