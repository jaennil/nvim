vim.g.mapleader = ' '
vim.api.nvim_set_keymap('n', '<leader>e', ':Explore<CR>', { silent = true })
vim.api.nvim_set_keymap('n', "<leader><leader>", ":w<CR>:so<CR>", {silent = true })
