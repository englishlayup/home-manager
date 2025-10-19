return {
  {
    'nvim-mini/mini.nvim',
    version = false,
    deps = {
      'tpope/vim-fugitive',
    },
    config = function()
      require 'mini.ai'.setup { n_lines = 500 }
      require 'mini.statusline'.setup {
        content = {
          active = function()
            local mode, mode_hl = MiniStatusline.section_mode { trunc_width = 120 }
            local git           = '%{FugitiveStatusline()}'
            local diff          = MiniStatusline.section_diff { trunc_width = 75 }
            local diagnostics   = MiniStatusline.section_diagnostics { trunc_width = 75 }
            local lsp           = MiniStatusline.section_lsp { trunc_width = 75 }
            local filename      = MiniStatusline.section_filename { trunc_width = 140 }
            local fileinfo      = MiniStatusline.section_fileinfo { trunc_width = 120 }
            local location      = MiniStatusline.section_location { trunc_width = 75 }
            local search        = MiniStatusline.section_searchcount { trunc_width = 75 }

            return MiniStatusline.combine_groups {
              { hl = mode_hl,                 strings = { mode } },
              { hl = 'MiniStatuslineDevinfo', strings = { git, diff, diagnostics, lsp } },
              '%<', -- Mark general truncate point
              { hl = 'MiniStatuslineFilename', strings = { filename } },
              '%=', -- End left alignment
              { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
              { hl = mode_hl,                  strings = { search, location } },
            }
          end
        },
      }
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
