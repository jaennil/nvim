local red_orange = "#ff4f00"
local black = "#000000"
local green = "#00ff00"
local brown = "#f4a460"
local purple = "#ac64fb"
local bright_green = "#aaf94c"
local pink = "#ff56c4"
local yellow = "#ffff00"
local gray = "#1f1f1f"
local blue = "#0060ff"
local white = "#ffffff"

local M = {
    "shatur/neovim-ayu",
    lazy = false,
    priority = 1000,
    main = "ayu",
}

M.init = function()
	vim.cmd.colorscheme 'ayu'
	vim.cmd.hi "WinSeparator guibg=None"
	vim.cmd.hi "StatusLine guibg=None"
	vim.cmd.hi "StatusLineNC guibg=None"
end

M.opts = {
	overrides = {
	    Normal                = { bg = black },
	    Function              = { fg = yellow },
	    -- keywords like require
	    Special               = { fg = red_orange },
	    Statement             = { fg = red_orange },
	    -- imports
	    PreProc               = { fg = brown },
        ['@module']           = { fg = brown },
	    -- Constant              = { fg = green },
	    Conditional           = { fg = blue },
	    String                = { fg = bright_green },
	    ['@variable']         = { fg = white },
        Type                  = { fg = green },
	    ['@property']         = { fg = pink },
	    ['@variable.member']         = { fg = purple },
	    -- ['@parameter']        = { fg = blue },
	    ['@lsp.type.parameter']        = { fg = blue },
	    -- ['@']        = { fg = purple },
	    SignColumn            = { bg = black },
	    Conceal               = {},
	    CocUnusedHighlight    = {},
	    DiagnosticUnnecessary = { bg = gray },
	    Delimiter             = { fg = white },
	},
}

return M;
