local g = vim.g
local opt = vim.opt
local cmd = vim.cmd
local exec = vim.api.nvim_exec

-- leader to space
g.mapleader = " "

opt.relativenumber = true
opt.number = true

-- cursor in the middle of the screen
opt.so = 999

-- disabe line wrap
opt.wrap = false

-- disable swap file
opt.swapfile = false

-- disable backup file
opt.backup = false

opt.hlsearch = false

opt.termguicolors = true

opt.scrolloff = 8

opt.signcolumn = "yes"

opt.updatetime = 50

opt.incsearch = true

opt.undofile = true

-- soft tabs
opt.softtabstop = 4

-- use spaces instead of tabs
opt.expandtab = true

-- shift 4 spaces when tab
opt.shiftwidth = 4

-- set tabstop to 4 spaces
opt.tabstop = 4

-- autoindent for new lines
opt.smartindent = true

-- paste from system clipboard
opt.clipboard = "unnamedplus"

-- don't auto commenting new lines
cmd([[au BufEnter * set fo-=c fo-=r fo-=o]])

-- remembers when you last edited a file
cmd([[
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
]])

-- highlight yanked text for few seconds
exec(
	[[
augroup YankHighlight
  autocmd!
  autocmd TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=400}
augroup END
]],
	false
)

exec(
	[[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost * FormatWrite
augroup END
]],
	false
)
