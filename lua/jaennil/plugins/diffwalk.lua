return {
    "jaennil/diffwalk.nvim",
    dependencies = { "lewis6991/gitsigns.nvim" },
    cmd = {
        "DiffwalkBranch",
        "DiffwalkFiles",
        "DiffwalkCommits",
        "DiffwalkCommit",
        "DiffwalkOld",
        "DiffwalkToggleDeleted",
        "DiffwalkReset",
    },
    keys = {
        { "<leader>mh", "<CMD>DiffwalkBranch<CR>", desc = "Walk the branch diff" },
        { "<leader>mw", "<CMD>DiffwalkFiles<CR>", desc = "Changed files of the branch" },
        { "<leader>mc", "<CMD>DiffwalkCommits<CR>", desc = "Walk the diff of a commit" },
        { "<leader>mo", "<CMD>DiffwalkOld<CR>", desc = "Open the base version of the file" },
        { "<leader>md", "<CMD>DiffwalkToggleDeleted<CR>", desc = "Toggle deleted lines" },
        { "<leader>mB", "<CMD>DiffwalkReset<CR>", desc = "Reset the diff base" },
    },
}
