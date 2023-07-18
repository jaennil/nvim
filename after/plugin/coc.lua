local keyset = vim.keymap.set
function _G.check_back_space()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

keyset("n", "<leader>gpd", "<Plug>(coc-diagnostic-prev)", {silent = true})
keyset("n", "<leader>gnd", "<Plug>(coc-diagnostic-next)", {silent = true})

keyset("n", "<leader>gd", "<Plug>(coc-definition)", {silent = true})
keyset("n", "<leader>gtd", "<Plug>(coc-type-definition)", {silent = true})
keyset("n", "<leader>gi", "<Plug>(coc-implementation)", {silent = true})
keyset("n", "<leader>gr", "<Plug>(coc-references)", {silent = true})

function _G.show_docs()
    local cw = vim.fn.expand('<cword>')
    if vim.fn.index({'vim', 'help'}, vim.bo.filetype) >= 0 then
        vim.api.nvim_command('h ' .. cw)
    elseif vim.api.nvim_eval('coc#rpc#ready()') then
        vim.fn.CocActionAsync('doHover')
    else
        vim.api.nvim_command('!' .. vim.o.keywordprg .. ' ' .. cw)
    end
end
keyset("n", "<leader>sd", '<CMD>lua _G.show_docs()<CR>', {silent = true})

vim.api.nvim_create_augroup("CocGroup", {})
vim.api.nvim_create_autocmd("CursorHold", {
    group = "CocGroup",
    command = "silent call CocActionAsync('highlight')",
    desc = "Highlight symbol under cursor on CursorHold"
})

keyset("n", "<leader>rn", "<Plug>(coc-rename)", {silent = true})

keyset("x", "<leader>f", "ggVG<Plug>(coc-format-selected)", {silent = true})
keyset("n", "<leader>f", "ggVG<Plug>(coc-format-selected)", {silent = true})

local opts = {silent = true, nowait = true}
keyset("n", "<leader>ca", "<Plug>(coc-codeaction-cursor)", opts)
keyset("x", "<leader>sca", "<Plug>(coc-codeaction-selected)", opts)
keyset("n", "<leader>sca", "<Plug>(coc-codeaction-selected)", opts)
keyset("n", "<leader>fca", "<Plug>(coc-codeaction-source)", opts)
vim.api.nvim_create_user_command("Format", "call CocAction('format')", {})

vim.api.nvim_create_user_command("OrganizeImports", "call CocActionAsync('runCommand', 'editor.action.organizeImport')", {})

keyset("n", "<leader>sd", ":<C-u>CocList diagnostics<cr>", opts)
-- TODO: better bind
-- keyset("n", "<leader>o", ":<C-u>CocList outline<cr>", opts)

-- TODO: find out if its working and usefull
-- Use CTRL-S for selections ranges
-- Requires 'textDocument/selectionRange' support of language server
-- keyset("n", "<C-s>", "<Plug>(coc-range-select)", {silent = true})
-- keyset("x", "<C-s>", "<Plug>(coc-range-select)", {silent = true})
