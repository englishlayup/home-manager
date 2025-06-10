vim.keymap.set('n', '<space><space>x', '<cmd>source %<CR>', { desc = 'Execute file' })
vim.keymap.set('n', '<space>x', ':.lua<CR>', { desc = 'Execute current line' })
vim.keymap.set('v', '<space>x', ':lua<CR>', { desc = 'Execute selection' })
