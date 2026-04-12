vim.keymap.set('n', '<space><space>x', '<cmd>!bash %<CR>', { buffer = 0, desc = 'Execute file' })
vim.keymap.set('n', '<space>x', ':.w !bash<CR>', { buffer = 0, desc = 'Execute current line' })
vim.keymap.set('v', '<space>x', ':w !bash<CR>', { buffer = 0, desc = 'Execute selection' })
