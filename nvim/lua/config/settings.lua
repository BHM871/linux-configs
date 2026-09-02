vim.wo.number = true
vim.wo.relativenumber = true

---- Text and Font
vim.o.wrap = false
vim.opt.guifont = "JetBrainsMono"
vim.opt.encoding = "utf-8"

-- Funcionais

---- <Tab> Config
vim.opt.expandtab = true

---- Identação
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.breakindent = true
vim.opt.list = true

---- Salvar e Atualizar
vim.o.autowriteall = true
vim.o.autowrite = true
vim.o.autoread = true

---- Fold
vim.wo.foldenable = true
vim.wo.foldlevel = 20
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"

---- Outros
vim.o.hidden = true
vim.o.incsearch = true
vim.opt.scrolloff = 10
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.mouse = ""
