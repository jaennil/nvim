local M = {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
}

M.opts = {
    ensure_installed = { "bash", "diff", "lua", "markdown", "rust", "go" },
    sync_install = false,
    auto_install = true,
    ignore_install = { },
    highlight = {
	enable = true,
	disable = { },
	additional_vim_regex_highlighting = false,
    },
    indent = {
	enable = true,
    },
}

M.config = function(_, opts)
    require('nvim-treesitter.install').prefer_git = true
    require('nvim-treesitter.configs').setup(opts)
end

return M
