vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

local johnil_Fugitive = vim.api.nvim_create_augroup("johnil_Fugitive", {})

local autocmd = vim.api.nvim_create_autocmd
autocmd("BufWinEnter", {
	group = johnil_Fugitive,
	pattern = "*",
	callback = function()
		if vim.bo.ft ~= "fugitive" then
			return
		end

		local bufnr = vim.api.nvim_get_current_buf()
		local opts = { buffer = bufnr, remap = false }
	end,
})
