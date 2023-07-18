local lspconfig = require('lspconfig')
lspconfig.pyright.setup {}
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
