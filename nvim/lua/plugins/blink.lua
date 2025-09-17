return {
  {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets' },
    version = 'v1.*',
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = 'default',
        ['<C-l>'] = { 'snippet_forward', 'fallback' },
        ['<C-h>'] = { 'snippet_backward', 'fallback' },
      },
      signature = { enabled = true },
      sources = {
        per_filetype = {
          sql = { 'dadbod' },
          lua = { inherit_defaults = true, 'lazydev' },
        },
        providers = {
          dadbod = { module = 'vim_dadbod_completion.blink' },
          lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
            score_offset = 100,
          },
          path = {
            opts = {
              get_cwd = function(_)
                return vim.fn.getcwd()
              end,
            },
          },
        },
      },
    },
    opts_extend = { 'sources.default' }
  },
}
