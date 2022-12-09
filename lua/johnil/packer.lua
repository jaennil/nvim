return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use 'github/copilot.vim'
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }
    use 'nvim-tree/nvim-web-devicons'
    use 'navarasu/onedark.nvim'
    use {
    'numToStr/Comment.nvim',
    config = function()
        require('Comment').setup()
    end
}
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        -- or                            , branch = '0.1.x',
        requires = { {'nvim-lua/plenary.nvim'} }
}
end)
