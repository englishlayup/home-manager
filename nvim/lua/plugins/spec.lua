-- Plugins that don't need their own file
return {
  -- Package manager for LSP
  {
    'williamboman/mason.nvim',
    opts = {},
  },
  -- Gruvbox theme
  {
    'ellisonleao/gruvbox.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'gruvbox'
      vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
    end,
  },
  -- Auto-pairs brackets
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
    opts = {
      check_ts = true,
    }
  },
  -- "gc" to comment visual regions/lines
  {
    'numToStr/Comment.nvim',
    opts = {}
  },
  -- Add indentation guides
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
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
}
