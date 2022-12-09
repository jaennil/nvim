local g = vim.g
local opt = vim.opt
local cmd = vim.cmd
local exec = vim.api.nvim_exec

-- leader to space
g.mapleader = ' '

opt.relativenumber=true

-- cursor in the middle of the screen
opt.so=999                        

-- use spaces instead of tabs
opt.expandtab=true

-- shift 4 spaces when tab
opt.shiftwidth=4

-- set tabstop to 4 spaces
opt.tabstop=4

-- autoindent for new lines
opt.smartindent=true

-- don't auto commenting new lines
cmd [[au BufEnter * set fo-=c fo-=r fo-=o]]

-- remembers when you last edited a file
cmd [[
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
]]

-- highlight yanked text for few seconds
exec([[
augroup YankHighlight
  autocmd!
  autocmd TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=400}
augroup END
]],false)
