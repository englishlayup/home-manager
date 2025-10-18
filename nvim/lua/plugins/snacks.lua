return {
  'folke/snacks.nvim',
  ---@type snacks.Config
  opts = {
    picker = {
      layout = {
        cycle = true,
        preset = function()
          return vim.o.columns >= 120 and 'ivy_split' or 'vertical'
        end,
      },
    },
  },
  keys = {
    { '<leader>sf', function() Snacks.picker.smart() end,                                 desc = 'Smart [S]earch [F]iles' },
    { '<leader>b',  function() Snacks.picker.buffers() end,                               desc = 'Search [B]uffers' },
    { '<leader>:',  function() Snacks.picker.command_history() end,                       desc = 'Command History' },
    { '<leader>sh', function() Snacks.picker.help() end,                                  desc = 'Search [H]elp Pages' },
    { '<leader>sr', function() Snacks.picker.git_files() end,                             desc = '[S]earch Git [Repo]' },
    { '<leader>sg', function() Snacks.picker.grep() end,                                  desc = '[S]earch [G]rep' },
    { '<leader>sw', function() Snacks.picker.grep_word() end,                             desc = 'Search word or visual selection', mode = { 'n', 'x' } },
    { '<leader>sk', function() Snacks.picker.keymaps() end,                               desc = '[S]earch [K]eymaps' },
    { '<leader>sa', function() Snacks.picker.autocmds() end,                              desc = '[S]earch [A]utocmds' },
    { '<leader>sn', function() Snacks.picker.files { cwd = vim.fn.stdpath 'config' } end, desc = '[S]earch [N]eovim Files' },
  },
}
