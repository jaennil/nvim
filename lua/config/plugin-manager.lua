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
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		-- enable = false,
	},
	{ "CRAG666/code_runner.nvim", config = true },
	{
		"christoomey/vim-tmux-navigator",
		lazy = false,
	},
	{ "neovim/nvim-lspconfig" },
	{ "udalov/kotlin-vim" },
	{ "OmniSharp/omnisharp-vim" },
	{
		'neoclide/coc.nvim',
		branch = 'release'
	},
	{ 'numToStr/Comment.nvim' },
	{ "mbbill/undotree" },
	-- { "eandrju/cellular-automaton.nvim" },

	-- debugging
	{ "mfussenegger/nvim-dap" },
	{ "theHamsta/nvim-dap-virtual-text" },
	{ "rcarriga/nvim-dap-ui", dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"} },
	{ "leoluz/nvim-dap-go" },
	{
		"ray-x/go.nvim",
		dependencies = { -- optional packages
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("go").setup()
		end,
		event = { "CmdlineEnter" },
		ft = { "go", 'gomod' },
		build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
	},
	{ "folke/neodev.nvim", opts = {} },

	{ "tpope/vim-fugitive" },
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 600
		end,
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		}
	},
	{ "shatur/neovim-ayu" },
	{ "norcalli/nvim-colorizer.lua" },
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate" -- :MasonUpdate updates registry contents
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.2',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},
	{ "preservim/nerdtree" },
	{ "chentoast/marks.nvim" },
	-- {
	-- 	'm4xshen/autoclose.nvim',
	-- 	enable=false,
	-- 	config = function() require("autoclose").setup() end
	-- },
	-- {
	-- 	'glacambre/firenvim',
	--
	-- 	lazy = not vim.g.started_by_firenvim,
	-- 	build = function()
	-- 		vim.fn["firenvim#install"](0)
	-- 	end
	-- },
	-- {
	-- 	'andymass/vim-matchup',
	-- 	setup = function()
	-- 		vim.g.matchup_matchparen_offscreen = { method = "popup" }
	-- 	end,
	-- },

})
