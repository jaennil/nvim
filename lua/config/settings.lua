vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 4 
vim.opt.hlsearch = false
vim.opt.termguicolors = true
vim.opt.updatetime = 50
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.signcolumn = "yes"
vim.cmd([[
  highlight SignColumn guibg='#000000'
  highlight SignColumnSB guibg='#000000'
]])
vim.g.netrw_banner = false
vim.api.nvim_set_option("clipboard","unnamed")
vim.opt.swapfile = false
vim.cmd([[let w:m1=matchadd('ErrorMsg', '\%>80v.\+', -1)]])
