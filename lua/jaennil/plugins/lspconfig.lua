local M = {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
}

M.config = function()
    local lspconfig = require("lspconfig")
    lspconfig.rust_analyzer.setup {}
    lspconfig.gopls.setup {}
end

return M
