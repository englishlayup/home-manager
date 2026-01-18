return {
  'folke/snacks.nvim',
  lazy = false,
  priority = 1000,
  ---@type snacks.Config
  opts = {
    picker = {
      layout = {
        cycle = true,
        preset = 'ivy_split',
      },
    },
    indent = {
      animate = {
        enabled = false,
      }
    },
  },
  keys = {
    { '<leader>sf', function() Snacks.picker.smart() end,                                       desc = 'Smart [S]earch [F]iles' },
    { '<leader>b',  function() Snacks.picker.buffers { filter = { filter = function(item) return item.buf and vim.bo[item.buf].buftype ~= 'terminal' end } } end, desc = 'Search [B]uffers' },
    { '<leader>st', function() Snacks.picker.buffers { filter = { filter = function(item) return item.buf and vim.bo[item.buf].buftype == 'terminal' end } } end, desc = '[S]earch [T]erminal Buffers' },
    { '<leader>:',  function() Snacks.picker.command_history() end,                             desc = 'Search Command History' },
    { '<leader>sh', function() Snacks.picker.help() end,                                        desc = 'Search [H]elp Pages' },
    { '<leader>sr', function() Snacks.picker.git_files() end,                                   desc = '[S]earch Git [Repo]' },
    { '<leader>sg', function() Snacks.picker.grep() end,                                        desc = '[S]earch [G]rep' },
    { '<leader>sw', function() Snacks.picker.grep_word() end,                                   desc = 'Search word or visual selection', mode = { 'n', 'x' } },
    { '<leader>sk', function() Snacks.picker.keymaps() end,                                     desc = '[S]earch [K]eymaps' },
    { '<leader>sa', function() Snacks.picker.autocmds() end,                                    desc = '[S]earch [A]utocmds' },
    { '<leader>sn', function() Snacks.picker.files { cwd = vim.fn.stdpath 'config' } end,       desc = '[S]earch [N]eovim Files' },
    { '<leader>n',  function() Snacks.picker.grep { cwd = '~/notes' } end,                      desc = 'Grep ~/[n]otes' },
  },
}
