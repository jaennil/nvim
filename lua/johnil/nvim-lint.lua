require("lint").linters_by_ft = {
	python = { "pylint" },
}

-- enable linting on save
vim.api.nvim_create_autocmd({"BufWrite, InsertLeave, TextChanged"}, {
  callback = function()
    require("lint").try_lint()
  end,
})
