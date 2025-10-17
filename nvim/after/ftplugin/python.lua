vim.keymap.set('n', '<space><space>x', '<cmd>pyfile %<CR>', { desc = 'Execute file' })
vim.keymap.set('n', '<space>x', ':.py<CR>', { desc = 'Execute current line' })
vim.keymap.set('v', '<space>x', ':py<CR>', { desc = 'Execute selection' })
