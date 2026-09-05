local language_servers = {
  "lua_ls",
  "clangd",
  "docker_language_server",
  "jdtls",
  "shuck",
}

local configure_lsp = function()
  local lspconfig = vim.lsp.config
  local capabilities = require("cmp_nvim_lsp").default_capabilities()

  for _, language in pairs(language_servers) do
    lspconfig(language, { capabilities = capabilities })
  end

  lspconfig("dartls", {
    dartls = {
      cmd = { "dart", "language-server", "--protocol=lsp" },
    },
    capabilities = capabilities,
  })

  lspconfig("shuck", {
    cmd = { "shuck", "server" },
    filetypes = { "sh", "bash", "zsh", "ksh" },
    root_markers = { ".shuck.toml", "shuck.toml", ".git" },
    capabilities = capabilities,
  })
end

return {
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = language_servers,
      })

      configure_lsp()

      local opts = { noremap = true, silent = true, nowait = true }
      local keymap = vim.keymap.set

      keymap("n", "<A-CR>", vim.lsp.buf.hover, opts)
      keymap("n", "gD", vim.lsp.buf.declaration, opts)
      keymap("n", "gd", vim.lsp.buf.definition, opts)
      keymap("n", "gI", vim.lsp.buf.implementation, opts)
      keymap("n", "gi", vim.lsp.buf.incoming_calls, opts)
      keymap("n", "<A-l>", vim.lsp.buf.format, opts)

      keymap("i", "<A-CR>", vim.lsp.buf.code_action, opts)
    end,
  },
}
