local M = {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
}

M.opts = {
    ensure_installed = { "bash", "diff", "lua", "markdown", "markdown_inline", "rust", "go" },
    sync_install = false,
    auto_install = true,
    ignore_install = {},
    highlight = {
        enable = true,
        disable = {},
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = true,
    },
}

M.config = function(_, opts)
    local treesitter = require("nvim-treesitter")

    if type(treesitter.install) ~= "function" then
        require("nvim-treesitter.install").prefer_git = true
        require("nvim-treesitter.configs").setup(opts)
        return
    end

    treesitter.setup()
    treesitter.install(opts.ensure_installed)

    vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("jaennil-treesitter", { clear = true }),
        callback = function(event)
            if opts.highlight.enable then
                local ok = pcall(vim.treesitter.start, event.buf)

                if ok and opts.indent.enable then
                    vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end
            end
        end,
    })
end

return M
