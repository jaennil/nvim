return {
    "Bekaboo/dropbar.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
        bar = {
            -- scratch buffers like the git review list have nothing to path out
            enable = function(buf, win, _)
                return vim.bo[buf].buftype == ""
                    and vim.api.nvim_buf_get_name(buf) ~= ""
                    and not vim.wo[win].diff
            end,
        },
    },
    keys = {
        {
            "<leader>;",
            function()
                require("dropbar.api").pick()
            end,
            desc = "Pick symbol in winbar",
        },
    },
}
