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
    -- snippets
	use("rafamadriz/friendly-snippets")
    -- indent-blankline
	use("lukas-reineke/indent-blankline.nvim")
    -- which key (for keybindings cheatsheet)
	use({
		"folke/which-key.nvim",
		config = function()
			require("which-key").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			})
		end,
	})
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
    -- icons
	use("nvim-tree/nvim-web-devicons")
    -- theme
	use("navarasu/onedark.nvim")
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
