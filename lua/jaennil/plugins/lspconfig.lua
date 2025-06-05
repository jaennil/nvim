local M = {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
}

M.config = function()
    local lspconfig = require("lspconfig")
    lspconfig.rust_analyzer.setup {}
    lspconfig.gopls.setup {}
    lspconfig.pyright.setup {}
    lspconfig.lemminx.setup {}
    lspconfig.omnisharp.setup({
        cmd = { "OmniSharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
    })
end

return M
