vim.g.mapleader = " "

-- open vim's explorer
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- move lines like in VSCode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- move next line to the end of the current line with space without moving the cursor
vim.keymap.set("n", "J", "mzJ`z")
-- moving half page with cursor remains at the same position
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
-- when searching with n cursor stays at the middle of the screen
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- when pasting in highlighted text, it will not copy the highlighted text
vim.keymap.set("x", "<leader>p", [["_dP]])

-- yank in to the system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
-- idk what this does
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- delete without copying to the clipboard
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- fix for multicursor with ctrl-c
vim.keymap.set("i", "<C-c>", "<Esc>")

-- ...
vim.keymap.set("n", "Q", "<nop>")
-- vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
-- just formatting
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

-- for quickfix feature
-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
-- vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
-- vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
-- vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- replace the word under the cursor
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
