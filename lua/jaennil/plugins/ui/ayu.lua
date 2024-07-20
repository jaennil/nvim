local red_orange = "#ff4f00"
local black = "#000000"
local green = "#00ff00"
local brown = "#f4a460"
local purple = "#ac64fb"
local bright_green = "#aaf94c"
local pink = "#ff66c4"
local yellow = "#ffff00"
local gray = "#1f1f1f"
local blue = "#0000ff"
local white = "#ffffff"

return { {
    "shatur/neovim-ayu",
    lazy = false,
    priority = 1000,
    main = "ayu",
    init = function()
	vim.cmd.colorscheme 'ayu'
	vim.cmd.hi "WinSeparator guibg=None"
    end,
    opts = {
	overrides = {
	    Normal                = { bg = black },
	    -- function name
	    Function              = { fg = yellow },
	    -- keywords like require
	    Special               = { fg = red_orange },
	    Statement             = { fg = red_orange },
	    -- imports
	    PreProc               = { fg = brown },
	    Constant              = { fg = green },
	    Conditional           = { fg = blue },
	    String                = { fg = bright_green },
	    ['@variable']         = { fg = pink },
	    ['@parameter']        = { fg = purple },
	    ['@']        = { fg = purple },
	    SignColumn            = { bg = black },
	    Conceal               = {},
	    CocUnusedHighlight    = {},
	    DiagnosticUnnecessary = { bg = gray },
	    Delimiter             = { fg = white },
	},
    },
} }
