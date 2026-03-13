-- Terminal ops in Neovim
-- Start terminal in insert mode and disable line numbers
vim.cmd [[autocmd TermOpen * startinsert | setlocal nonumber norelativenumber]]

vim.api.nvim_create_user_command('PythonRepl', function()
  vim.cmd.term 'python3'
end, {
  desc = 'Launch a Python repl',
})

vim.keymap.set('n', '<leader>py', '<cmd>PythonRepl<CR>', { desc = 'Start [Py]thon REPL' })

vim.keymap.set('n', '<leader>gg', function()
  vim.cmd 'tabnew'
  vim.fn.termopen('lazygit', {
    on_exit = function() vim.cmd 'tabc' end,
  })
end, { desc = 'Open Lazy[G]it in new tab' })


vim.keymap.set('n', '<leader>t', function()
  vim.cmd 'tabnew | term'
end, { desc = '[T]erminal: create new Terminal tab' })
