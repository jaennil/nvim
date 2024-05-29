require("neodev").setup({
	library = { plugins = { "nvim-dap-ui" }, types = true },
})

local lspconfig = require('lspconfig')
lspconfig.pyright.setup {}
lspconfig.kotlin_language_server.setup {}
lspconfig.bashls.setup {}
lspconfig.lua_ls.setup {
	settings = {
		Lua = {
			runtime = {
				version = 'LuaJIT',
			},
			diagnostics = {
				globals = { 'vim' },
			},
		},
	},
}
lspconfig.gopls.setup {}
lspconfig.html.setup {}
-- lspconfig.eslint.setup({
--   --- ...
--   on_attach = function(client, bufnr)
--     vim.api.nvim_create_autocmd("BufWritePre", {
--       buffer = bufnr,
--       command = "EslintFixAll",
--     })
--   end,
-- })
lspconfig.tsserver.setup {}
lspconfig.csharp_ls.setup {}
lspconfig.jdtls.setup{}
lspconfig.phpactor.setup {}
lspconfig.rust_analyzer.setup {}
