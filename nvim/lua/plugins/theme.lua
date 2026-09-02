return {
  {
    "navarasu/onedark.nvim",
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      local onedark = require("onedark")
      onedark.setup({
        style = 'dark'
      })
      onedark.load()
    end
  },
  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    config = function()
      vim.opt.termguicolors = true
      require("bufferline").setup({
        options = {
          separator_style = "slant",
          diagnostics = "nvim_lsp",
          diagnostics_indicator = function(_, _, diagnostics_dict, _)
            local s = " "
            for e, n in pairs(diagnostics_dict) do
              local sym = e == "error" and " "
                  or (e == "warning" and " " or " ")
              s = s .. n .. sym
            end
            return s
          end
        }
      })
    end
  }
}
