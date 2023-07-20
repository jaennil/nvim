-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",
vim.g.mapleader = ' '
local keymap = vim.api.nvim_set_keymap
keymap('n', '<leader>e', ':Explore<CR>', { silent = true })
keymap('n', "<leader><leader>", ":w<CR>:so<CR>", {silent = true })
function reload_colorizer()
    package.loaded['colorizer'] = nil
    require('colorizer').setup()
    require('colorizer').attach_to_buffer(0)
end
keymap('n', "<leader>rc", ":lua reload_colorizer()<CR>", {silent = true})
