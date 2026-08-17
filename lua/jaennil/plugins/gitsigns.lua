return {
    "lewis6991/gitsigns.nvim",
    config = function()
        require("gitsigns").setup({
            current_line_blame = true,
            current_line_blame_opts = {
                delay = 500,
            },
            on_attach = function(bufnr)
                local gitsigns = require("gitsigns")
                local function map(mode, lhs, rhs, desc, opts)
                    opts = vim.tbl_extend("force", { buffer = bufnr, desc = desc }, opts or {})
                    vim.keymap.set(mode, lhs, rhs, opts)
                end

                map("n", "]c", function()
                    if vim.wo.diff then
                        return "]c"
                    end

                    vim.schedule(gitsigns.next_hunk)
                    return "<Ignore>"
                end, "Next git hunk", { expr = true })
                map("n", "[c", function()
                    if vim.wo.diff then
                        return "[c"
                    end

                    vim.schedule(gitsigns.prev_hunk)
                    return "<Ignore>"
                end, "Previous git hunk", { expr = true })
                map("n", "<leader>hp", gitsigns.preview_hunk, "Preview git hunk")
            end,
        })
    end,
}
