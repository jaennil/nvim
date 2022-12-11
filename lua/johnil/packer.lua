return require("packer").startup(function(use)
	use("wbthomason/packer.nvim")
	use("github/copilot.vim")
	use("neovim/nvim-lspconfig") -- Configurations for Nvim LSP
	use("mhartington/formatter.nvim") -- Format code
	use("mfussenegger/nvim-lint")
	use("neovim/nvim-lspconfig")
	-- nvim-cmp
	use("hrsh7th/nvim-cmp")
	use("lukas-reineke/indent-blankline.nvim")
	use("hrsh7th/cmp-nvim-lsp")
	use({
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	})
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")
	use("hrsh7th/cmp-cmdline")

	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	})
	use("nvim-tree/nvim-web-devicons")
	use("navarasu/onedark.nvim")
	use({
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	})
	use({
		"nvim-telescope/telescope.nvim",
		tag = "0.1.0",
		-- or                            , branch = '0.1.x',
		requires = { { "nvim-lua/plenary.nvim" } },
	})
end)
