return require("packer").startup(function(use)
	-- packer can manage itself
	use("wbthomason/packer.nvim")
	-- copilot
	use("github/copilot.vim")
	-- formatter
	use("mhartington/formatter.nvim")
	-- linter
	use("mfussenegger/nvim-lint")
	-- git
	use("lewis6991/gitsigns.nvim")
	use({
		"VonHeikemen/lsp-zero.nvim",
		requires = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" },
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lua" },

			-- Snippets
			{ "L3MON4D3/LuaSnip" },
			{ "rafamadriz/friendly-snippets" },
		},
	})
	-- nvim-tree
	use({
		"nvim-tree/nvim-tree.lua",
		requires = {
			"nvim-tree/nvim-web-devicons", -- optional, for file icons
		},
		tag = "nightly", -- optional, updated every week. (see issue #1193)
	})
	use({ "saadparwaiz1/cmp_luasnip" })
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
