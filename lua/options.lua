vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.hlsearch = false

-- TODO:
-- vim.opt.mouse = "a"

vim.opt.tabstop = 8
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4

vim.opt.termguicolors = true

vim.opt.showmode = false

vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = "yes"

vim.opt.updatetime = 2000

vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.opt.inccommand = "split"

vim.opt.cursorline = true

vim.opt.scrolloff = 10

vim.opt.cmdheight = 0

vim.opt.statusline = "%!v:lua.status_line()"

function status_line()
    local recording_register = vim.fn.reg_recording()
    local right_align = "%="
    local base = "%m%F"
    if recording_register == "" then
        return right_align .. base
    else
        return right_align .. "Recording @" .. recording_register .. " " .. base
    end
end

