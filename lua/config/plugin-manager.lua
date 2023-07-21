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
    { "mbbill/undotree" },
    { "eandrju/cellular-automaton.nvim" },
    { "tpope/vim-fugitive" },
    { "folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
	    vim.o.timeout = true
	    vim.o.timeoutlen = 700
	end,
	opts = {
	    -- your configuration comes here
	    -- or leave it empty to use the default settings
	    -- refer to the configuration section below
	}
    },
    { "shatur/neovim-ayu" },
    { "norcalli/nvim-colorizer.lua" },
    { "williamboman/mason.nvim",
	build = ":MasonUpdate" -- :MasonUpdate updates registry contents
    },
    { "nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
    },
})
