-- KEYMAPS & OPTIONS

-- Remap space as leader key
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Indent opts
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.autoindent = true
vim.o.breakindent = true

vim.o.relativenumber = true
vim.wo.number = true
vim.o.signcolumn = 'auto'
vim.o.scrolloff = 8
vim.o.cursorline = true

-- Search opts
vim.o.showmatch = true
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true
-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.o.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Preview substitutions live, as you type
vim.opt.inccommand = 'split'

vim.o.showcmd = false
vim.o.errorbells = false
vim.o.swapfile = false
vim.o.backup = false
vim.o.undodir = os.getenv 'HOME' .. '/.vim/undodir'
vim.o.undofile = true
vim.o.termguicolors = true
vim.o.mouse = ''

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace in the editor
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Return to last edit position when opening files
vim.cmd [[autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif]]

-- Treat Jenkinsfile as Groovy
vim.filetype.add { pattern = { ['Jenkinsfile.*'] = 'groovy' } }

vim.keymap.set('n', '-', '<cmd>Oil<CR>', { desc = 'Open parent directory' })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Highlight on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.hl.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Keybinds to make split navigation easier.
--  Use ALT+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<A-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<A-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<A-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<A-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('t', '<A-h>', '<C-\\><C-N><C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('t', '<A-l>', '<C-\\><C-N><C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('t', '<A-j>', '<C-\\><C-N><C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('t', '<A-k>', '<C-\\><C-N><C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('t', '<C-q>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<C-w>+', '<cmd>resize +5<CR>', { desc = 'Increase current window height by 5' })
vim.keymap.set('n', '<C-w>-', '<cmd>resize -5<CR>', { desc = 'Decrease current window height by 5' })
vim.keymap.set('n', '<C-w>>', '<cmd>vertical resize +5<CR>',
  { desc = 'Increase current window width by 5' })
vim.keymap.set('n', '<C-w><', '<cmd>vertical resize -5<CR>',
  { desc = 'Decrease current window width by 5' })

-- Start terminal in insert mode and disable line numbers
vim.cmd [[autocmd TermOpen * startinsert | setlocal nonumber norelativenumber]]

vim.api.nvim_create_user_command('PythonRepl', function()
  vim.cmd.term 'python3'
end, {
  desc = 'Launch a Python repl',
})

vim.keymap.set('n', '<leader>py', '<cmd>PythonRepl<CR>', { desc = 'Start [Py]thon REPL' })

vim.keymap.set('n', 'yd', function()
    -- get 0-based current line
    local row = vim.api.nvim_win_get_cursor(0)[1] - 1
    -- fetch diagnostics for this buffer & line
    local diags = vim.diagnostic.get(0, { lnum = row })
    if vim.tbl_isempty(diags) then
      vim.notify('No diagnostics on this line', vim.log.levels.INFO)
      return
    end
    -- collect messages and join them
    local msgs = vim.tbl_map(function(d) return d.message end, diags)
    local text = table.concat(msgs, '\n')
    -- copy to system clipboard
    vim.fn.setreg('+', text)
    vim.notify('Copied diagnostics', vim.log.levels.INFO)
  end,
  { desc = '[Y]ank [D]iagnostic of current line', silent = true })

vim.keymap.set('v', '<leader>k', function()
    vim.cmd 'normal! "ay'
    vim.cmd '%delete _'
    vim.cmd 'normal! "ap'
    vim.cmd 'normal! gg'
  end,
  { desc = '[K]eep current selection only', silent = true })

vim.keymap.set('n', '<leader>r', function()
    vim.cmd 'make'
  end,
  { desc = 'Make', silent = true })

local qf_shell_cmd = function(cmd)
  local keys = vim.fn.systemlist(cmd)
  local qflist = vim.tbl_map(function(key)
    return { filename = key, lnum = 1, col = 1 }
  end, keys)
  vim.fn.setqflist(qflist)
  vim.cmd 'copen'
end

vim.api.nvim_create_user_command('ShellCmdToQf', function()
  local cmd = vim.fn.input 'Command: '
  qf_shell_cmd(cmd)
end, {})

vim.keymap.set('n', '<leader>c', '1z=e', { desc = '[C]orrect Spelling' })

-- Jump to most recent terminal buffer, or create one at bottom 30%
vim.keymap.set('n', '<leader>t', function()
  local bufs = vim.api.nvim_list_bufs()
  -- Sort by last used (most recent first)
  table.sort(bufs, function(a, b)
    return vim.fn.getbufinfo(a)[1].lastused > vim.fn.getbufinfo(b)[1].lastused
  end)
  for _, buf in ipairs(bufs) do
    if vim.bo[buf].buftype == 'terminal' then
      vim.api.nvim_set_current_buf(buf)
      return
    end
  end
  -- No terminal exists, create one in a vertical split
  vim.cmd('vsplit | term')
end, { desc = '[T]erminal: jump to recent or create' })
