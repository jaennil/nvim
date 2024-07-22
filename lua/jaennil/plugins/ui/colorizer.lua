local M = {
    "norcalli/nvim-colorizer.lua",
    event = "VeryLazy",
}

M.config = function()
    require"colorizer".setup()
end

return M
