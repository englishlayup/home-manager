return {
  {
    'nvim-mini/mini.nvim',
    version = false,
    config = function()
      require 'mini.ai'.setup { n_lines = 500 }
      require 'mini.statusline'.setup()
      require 'mini.pairs'.setup()
      require 'mini.diff'.setup
      {
        view = {
          style = 'sign',
          signs = { add = '+', change = '~', delete = '_' },
        }
      }
      local hipatterns = require 'mini.hipatterns'
      hipatterns.setup
      {
        highlighters = {
          -- Highlight hex color strings (`#rrggbb`) using that color
          hex_color = hipatterns.gen_highlighter.hex_color(), },
      }
      vim.keymap.set('n', '<leader>go',
        function() MiniDiff.toggle_overlay(vim.api.nvim_get_current_buf()) end,
        { desc = 'Toggle [G]it Diff [O]verlay' })
    end,
  },
}
