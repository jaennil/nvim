vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, { desc = "Rename" })
vim.keymap.set("n", "<leader>df", vim.diagnostic.open_float, { desc = "Open diagnostics float" })

vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
	local client = vim.lsp.get_client_by_id(args.data.client_id)
	if client.supports_method('textDocument/implementation') then
	    -- Create a keymap for vim.lsp.buf.implementation
	end
	if client.supports_method('textDocument/completion') then
	    -- Enable auto-completion
	    -- TODO: completion is nil for some reason
	    -- vim.lsp.completion.enable(true, client.id, args.buf, {autotrigger = true})
	end
	if client.supports_method('textDocument/formatting') then
	    -- Formatting
	    vim.keymap.set("n",
		"<leader>f",
		function()
		    vim.lsp.buf.format({bufnr = args.buf, id = client.id})
		end,
		{ desc = "Exit terminal mode" }
	    )
	end
    end
})
