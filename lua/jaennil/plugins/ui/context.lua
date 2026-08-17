return {
    "nvim-treesitter/nvim-treesitter-context",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        -- the enclosing function plus the loop or branch the cursor sits in
        max_lines = 3,
        multiline_threshold = 1,
        trim_scope = "outer",
    },
}
