return {
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
    },
    keys = {
      {
        '<leader>?',
        function()
          require 'which-key'.show { global = false }
        end,
        desc = 'Buffer Local Keymaps (which-key)',
      },
    },
    config = function()
      require 'which-key'.setup()
      require 'which-key'.add {
        { '<leader>d', group = '[D]ap' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>w', group = '[W]orkspace' },
      }
    end,
  },
}
