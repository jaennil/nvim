local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
	"git",
	"clone",
	"--filter=blob:none",
	"https://github.com/folke/lazy.nvim.git",
	"--branch=stable", -- latest stable release
	lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    { "nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
    },
    { "christoomey/vim-tmux-navigator",
	lazy = false,
    },
    { "neovim/nvim-lspconfig" },
    { 'neoclide/coc.nvim',
	branch = 'release'
    },
    { 'numToStr/Comment.nvim' },
})
