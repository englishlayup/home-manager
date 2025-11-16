-- Plugins that don't need their own file
return {
  {
    'nvim-treesitter/nvim-treesitter-context',
    opts = {
      max_lines = 1,
    }
  },
  -- Package manager for LSP
  {
    'williamboman/mason.nvim',
    opts = {},
  },
  -- Gruvbox theme
  {
    'ellisonleao/gruvbox.nvim',
    priority = 1000,
    config = true,
    opts = {},
    init = function()
      vim.cmd [[colorscheme gruvbox]]
      vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
    end
  },
  -- "gc" to comment visual regions/lines
  {
    'numToStr/Comment.nvim',
    opts = {}
  },
  -- Highlight TODO comments
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false }
  },
  -- File based operations in a buffer
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    dependencies = {
      {
        'echasnovski/mini.icons',
        opts = {}
      }
    },
  },
  -- Run git commands with :Git or :G
  {
    'tpope/vim-fugitive',
  },
  -- Provides mappings to easily delete, change and add such surroundings in pairs
  {
    'tpope/vim-surround',
  },
  -- "." command support for vim-surround
  {
    'tpope/vim-repeat',
  },
  {
    'mbbill/undotree'
  },
  {
    'HakonHarnes/img-clip.nvim',
    event = 'VeryLazy',
    opts = {},
    keys = {
      { '<leader>i', '<cmd>PasteImage<cr>', desc = '[I]nsert image from system clipboard' },
    },
  }
}
