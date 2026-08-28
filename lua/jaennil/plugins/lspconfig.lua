local M = {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
}

M.config = function()
    vim.lsp.enable({
        "rust_analyzer",
        "gopls",
        "intelephense",
        "pyright",
        "lemminx",
        "omnisharp",
    })
end

return M
