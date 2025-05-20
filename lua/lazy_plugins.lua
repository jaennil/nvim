require("lazy").setup({

    -- general
    require "jaennil/plugins/treesitter",
    require "jaennil/plugins/plenary",

    -- ui
    require "jaennil/plugins/ui/ayu",
    require "jaennil/plugins/ui/colorizer",
    require "jaennil/plugins/ui/todo",
    require "jaennil/plugins/ui/fidget",

    -- utils
    require "jaennil/plugins/yazi",
    require "jaennil/plugins/fugitive",
    require "jaennil/plugins/undotree",
    require "jaennil/plugins/tmux",

    -- lsp
    require "jaennil/plugins/lspconfig",
    require "jaennil/plugins/mason",

    -- TODO
    -- nvim-cmp
    -- smoka7/hop.nvim
    -- andymass/vim-matchup
    -- monaqa/dial.nvim
    -- nvim-tree/nvim-web-devicons
    -- luckasRanarison/clear-action.nvim
    -- folke/persistence.nvim
})
