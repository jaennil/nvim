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

wk.register({
	["<F5>"] = { ":lua require'dap'.continue()<CR>", "Debug Continue" },
	["<F10>"] = { ":lua require'dap'.step_over()<CR>", "Debug Step Over" },
	["<F11>"] = { ":lua require'dap'.step_into()<CR>", "Debug Step Into" },
	["<F12>"] = { ":lua require'dap'.step_out()<CR>", "Debug Step Out" },
})

wk.register({
	t = {
		name = "Telescope",
		f = { ":Telescope find_files theme=dropdown<cr>", "Telescope find files" },
		l = { ":Telescope live_grep theme=dropdown<cr>", "Telescope live grep" },
		b = { ":Telescope buffers theme=dropdown<cr>", "Telescope buffers" },
		g = { ":Telescope git_files theme=dropdown<cr>", "Telescope git files" },
		s = { ":Telescope grep_string theme=dropdown<cr>", "Telescope grep string" },
		c = { ":Telescope git_commits theme=dropdown<cr>", "Telescope git commits" },
	},
	d = {
		name = "Debug",
		t = {
			name = "Toggle",
			b = { ":lua require'dap'.toggle_breakpoint()<CR>", "Breakpoint" },
		},
		s = { ":lua require'dap'.disconnect()<CR>", "Stop" },
		-- s = {
		-- 	name = "Set",
		-- 	b = { ":lua 
		-- },
	},
	o = {
		name = "Open",
		n = { ":Explore<cr>", "Open Netrw" },
		r = { "<Plug>(coc-references)", "References of element under cursor" },
		d = { ":<C-u>CocList diagnostics<cr>", "Open Diagnostics" },
	},
	c = {
		name = "Code",
		a = {
			name = "Action",
			f = { "<Plug>(coc-codeaction-source)", "File Code Action" },
			c = { "<Plug>(coc-codeaction-cursor)", "Cursor Code Action" },
			s = { "<Plug>(coc-codeaction-selected)", "Selected Code Action" },
		},
	},
	f = {
		name = "File",
		f = { ":Format<cr>", "Format File" },
		s = { source_file, "Source File" },
	},
	g = {
		name = "Git",
		s = { ":Git<cr>G", "Git Status" },
		p = { ":Git push<cr>", "Git Push" },
	},
	r = { "<Plug>(coc-rename)", "Rename" },
	s = {
		name = "Show",
		d = { show_docs, "Show Documentation" },
	},
	u = { vim.cmd.UndotreeToggle, "Unto Tree Toggle" },
	j = {
		name = "Jump to",
		p = {
			name = "Previous",
			d = { "<Plug>(coc-diagnostic-prev)", "Jump to prev diagnostic" },
		},
		n = {
			name = "Next",
			d = { "<Plug>(coc-diagnostic-next)", "Jump to next diagnostic" },
		},
		d = { "<Plug>(coc-definition)", "Jump to definition" },
		i = { "<Plug>(coc-implementation)", "Jump to implementation" },
	},
}, { prefix = "<leader>" })
