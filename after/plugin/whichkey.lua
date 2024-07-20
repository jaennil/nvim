local wk = require("which-key")

local function show_docs()
	local cw = vim.fn.expand('<cword>')
	if vim.fn.index({ 'vim', 'help' }, vim.bo.filetype) >= 0 then
		vim.api.nvim_command('h ' .. cw)
	elseif vim.api.nvim_eval('coc#rpc#ready()') then
		vim.fn.CocActionAsync('doHover')
	else
		vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
	end
end

local function source_file()
	vim.api.nvim_command("w")
	vim.api.nvim_command("so")
	local time = os.date("*t")
	print("file sourced " .. time.hour .. ':' .. time.min .. ':' .. time.sec)
end

wk.add({
    { "<F5>", "<CMD>lua require'dap'.continue()<CR>", desc="Debug Continue" },
    {"<F10>", ":lua require'dap'.step_over()<CR>", desc="Debug Step Over" },
    {"<F11>", ":lua require'dap'.step_into()<CR>", desc="Debug Step Into" },
    {"<F12>", ":lua require'dap'.step_out()<CR>", desc="Debug Step Out" },
})

-- TODO: add modes; fix overlaping mappings
wk.add({
    { "<leader>t", group = "Telescope" },
	{ "<leader>tf", "<CMD>Telescope find_files theme=dropdown<CR>", desc="Telescope find files" },
	{ "<leader>tl", "<CMD>Telescope live_grep theme=dropdown<CR>", desc="Telescope live grep" },
	{ "<leader>tb", "<CMD>Telescope buffers theme=dropdown<CR>", desc="Telescope buffers" },
	{ "<leader>tg", "<CMD>Telescope git_files theme=dropdown<CR>", desc="Telescope git files" },
	{ "<leader>ts", "<CMD>Telescope grep_string theme=dropdown<CR>", desc="Telescope grep string" },
	{ "<leader>tc", "<CMD>Telescope git_commits theme=dropdown<CR>", desc="Telescope git commits" },
    { "<leader>d", group = "Debug" },
	{ "<leader>dt", "<CMD>lua require'dap'.toggle_breakpoint()<CR>", desc = "Toggle breakpoint" },
	{ "<leader>dc", "<CMD>lua require'dapui'.close()<CR>", desc="Close Dapui" },
	{ "<leader>ds", "<CMD>lua require'dap'.disconnect()<CR>", desc="Stop" },
    { "<leader>o", group = "Open" },
	{ "<leader>or", "<Plug>(coc-references)", desc="References of element under cursor" },
	{ "<leader>od", ":<C-u>CocList diagnostics<cr>", desc="Open Diagnostics" },
    { "<leader>c", group = "Code" },
	{ "<leader>cr", "<CMD>RunCode<CR>", desc="Run" },
	{ "<leader>ca", group = "Code Action" },
	    { "<leader>caf", "<Plug>(coc-codeaction-source)", desc="File Code Action" },
	    { "<leader>cac", "<Plug>(coc-codeaction-cursor)", desc="Cursor Code Action" },
	    { "<leader>cas", "<Plug>(coc-codeaction-selected)", desc="Selected Code Action" },
    { "<leader>f", group = "File" },
	{ "<leader>ff", "<CMD>Format<CR>", desc="Format File" },
	{ "<leader>fs",  source_file, desc="Source File" },
    { "<leader>g", group = "Git" },
	{ "<leader>gs", "<CMD>Git<CR>G", desc="Git Status" },
	{ "<leader>gp", "<CMD>Git push<CR>", desc="Git Push" },
    { "<leader>r", "<Plug>(coc-rename)", desc="Rename" },
    { "<leader>s", group = "Show" },
	{ "<leader>sd", show_docs, desc="Show Documentation" },
    { "<leader>u", vim.cmd.UndotreeToggle, desc="Unto Tree Toggle" },
    { "<leader>j", group = "Jump to" },
	{"<leader>jp", "<Plug>(coc-diagnostic-prev)", desc = "Jump to previous diagnostics" },
	{"<leader>jn", "<Plug>(coc-diagnostic-next)", desc = "Jump to next diagnostics" },
	{ "<leader>jd", "<Plug>(coc-definition)", desc="Jump to definition" },
	{ "<leader>ji", "<Plug>(coc-implementation)", desc="Jump to implementation" },
    { "<leader>n", "<CMD>lua require('yazi').yazi()<CR>", desc="Open Yazi" },
})
