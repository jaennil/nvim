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
    {"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function () 
	    local configs = require("nvim-treesitter.configs")

	    configs.setup({
		highlight = {
		enable = true,
		additional_vim_regex_highlighting = false
		},
		indent = { enable = true },  
	    })
	end
    },
    {
	"christoomey/vim-tmux-navigator",
	lazy = false,
    }
})
