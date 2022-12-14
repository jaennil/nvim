return require("packer").startup(function(use)
	-- packer can manage itself
	use("wbthomason/packer.nvim")
	-- copilot
	use("github/copilot.vim")
	-- formatter
	use("mhartington/formatter.nvim")
	-- linter
	use("mfussenegger/nvim-lint")
	-- lsp
	use("neovim/nvim-lspconfig")
	-- nvim-cmp
	use("hrsh7th/nvim-cmp")
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-cmdline")
	use("hrsh7th/cmp-nvim-lsp")
	-- git
	use("lewis6991/gitsigns.nvim")
	-- nvim-tree
	use({
		"nvim-tree/nvim-tree.lua",
		requires = {
			"nvim-tree/nvim-web-devicons", -- optional, for file icons
		},
		tag = "nightly", -- optional, updated every week. (see issue #1193)
	})
	use({ "saadparwaiz1/cmp_luasnip" })
	-- snippets
	use("rafamadriz/friendly-snippets")
	use({ "L3MON4D3/LuaSnip", tag = "v<CurrentMajor>.*" })
	-- indent-blankline
	use("lukas-reineke/indent-blankline.nvim")
	-- which key (for keybindings cheatsheet)
	use("folke/which-key.nvim")

	-- auto pairs
	use({
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	})
	-- tree sitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	})
	-- rainbow parentheses (for tree sitter)
	use("p00f/nvim-ts-rainbow")
	-- icons
	use("nvim-tree/nvim-web-devicons")
	-- better git commands
	use("tpope/vim-fugitive")
	-- themes
	use("navarasu/onedark.nvim")
	use("folke/tokyonight.nvim")
	-- comment
	use({
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	})
	-- telescope
	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.0",
		-- or                            , branch = '0.1.x',
		requires = { { "nvim-lua/plenary.nvim" } },
	})
end)
