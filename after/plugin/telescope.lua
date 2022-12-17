local builtin = require('telescope.builtin')
-- project files
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
-- useful because it's not showing files like node_modules
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
-- just search for a string in the current directory
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)

