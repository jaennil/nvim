local M = {
    "mbbill/undotree",
}

M.keys = {
    { "<leader>u", vim.cmd.UndotreeToggle, desc = "Undo tree toggle" },
}

M.config = function()
    vim.g.undotree_SetFocusWhenToggle = true
end

return M
