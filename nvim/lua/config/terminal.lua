-- Terminal ops in Neovim

-- Start terminal in insert mode and disable line numbers
vim.cmd [[autocmd TermOpen * startinsert | setlocal nonumber norelativenumber]]

-- Map Ctrl + W to exiting terminal mode
vim.keymap.set('t', '<C-w>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<leader>py', function()
  vim.cmd 'tabnew | terminal python'
  vim.api.nvim_create_autocmd('TermClose', {
    buffer = 0,
    once = true,
    callback = function() vim.cmd 'tabc' end,
  })
end, { desc = 'Start [Py]thon REPL' })

vim.keymap.set('n', '<leader>t', function()
  vim.cmd 'tabnew | term'
end, { desc = '[T]erminal: create new Terminal tab' })
