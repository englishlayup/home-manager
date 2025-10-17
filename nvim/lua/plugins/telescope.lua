return {
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      { 'nvim-telescope/telescope-ui-select.nvim' },
    },
    config = function()
      require 'telescope'.setup {
        defaults = {
          sorting_strategy = 'ascending',
          borderchars = {
            '─', -- top
            '│', -- right
            '─', -- bottom
            '│', -- left
            '┌', -- top-left
            '┐', -- top-right
            '┘', -- bottom-right
            '└', -- bottom-left
          },
          path_displays = { 'smart' },
          layout_config = {
            height = 100,
            width = 400,
            prompt_position = 'top',
            preview_cutoff = 40,
          }
        },
      }
      require 'telescope'.load_extension 'fzf'
      require 'telescope'.load_extension 'ui-select'

      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sd', builtin.find_files, { desc = '[S]earch in [D]ir' })
      vim.keymap.set('n', '<leader>sr', builtin.git_files, { desc = '[S]earch in [R]epo' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', require 'telescope.multigrep'.live_multigrep, { desc = '[S]earch with Multi[G]rep' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader>b', function()
        builtin.buffers { sort_mru = true }
      end, { desc = '[S]earch [B]uffers' })

      vim.keymap.set('n', '<leader>/', function()
        builtin.current_buffer_fuzzy_find(require 'telescope.themes'.get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  }
}
