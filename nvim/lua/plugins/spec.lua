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
        'nvim-mini/mini.icons',
        opts = {}
      }
    },

  },
  -- Paste image into assets/
  {
    'HakonHarnes/img-clip.nvim',
    event = 'VeryLazy',
    opts = {},
    keys = {
      { '<leader>pi', '<cmd>PasteImage<cr>', desc = '[P]aste [I]mage from system clipboard' },
    },
  },
  -- Render markdown
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.nvim' }, -- if you use the mini.nvim suite
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
      completions = { lsp = { enabled = true } },
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
}
