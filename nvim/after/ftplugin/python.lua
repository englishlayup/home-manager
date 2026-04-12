vim.keymap.set('n', '<space><space>x', '<cmd>!python3 %<CR>', { buffer = 0, desc = 'Execute file' })
vim.keymap.set('n', '<space>x', ':.w !python3<CR>', { buffer = 0, desc = 'Execute current line' })
vim.keymap.set('v', '<space>x', ':w !python3<CR>', { buffer = 0, desc = 'Execute selection' })
