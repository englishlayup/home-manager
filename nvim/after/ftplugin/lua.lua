vim.keymap.set('n', '<space><space>x', '<cmd>source %<CR>', { buffer = 0, desc = 'Execute file' })
vim.keymap.set('n', '<space>x', ':.lua<CR>', { buffer = 0, desc = 'Execute current line' })
vim.keymap.set('v', '<space>x', ':lua<CR>', { buffer = 0, desc = 'Execute selection' })
