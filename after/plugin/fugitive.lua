vim.keymap.set("n", "<leader>gs", ":Git<CR>G")
vim.keymap.set("n", "<leader>p", vim.cmd.Git('push'))
vim.keymap.set("n", "<leader>fp", ":Git push -u origin ");
