require("lazy").setup({

    -- general
    require "jaennil/plugins/treesitter",

    -- ui
    require "jaennil/plugins/ui/ayu",
    require "jaennil/plugins/ui/colorizer",

    -- utils
    require "jaennil/plugins/yazi",
    require "jaennil/plugins/fugitive",
    require "jaennil/plugins/undotree",
    require "jaennil/plugins/fidget",

    -- lsp
    require "jaennil/plugins/lspconfig",

    -- TODO
    -- nvim-cmp
    -- smoka7/hop.nvim
    -- andymass/vim-matchup
    -- monaqa/dial.nvim
    -- nvim-tree/nvim-web-devicons
    -- luckasRanarison/clear-action.nvim
})
