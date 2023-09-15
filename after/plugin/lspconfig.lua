local lspconfig = require('lspconfig')
lspconfig.pyright.setup {}
lspconfig.bashls.setup {}
lspconfig.lua_ls.setup {
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = {'vim'},
      },
    },
  },
}
lspconfig.gopls.setup{}
lspconfig.html.setup{}
