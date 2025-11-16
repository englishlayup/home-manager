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
          sql = { inherit_defaults = true, 'dadbod' },
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
          buffer = {
            -- keep case of first char
            transform_items = function(a, items)
              local keyword = a.get_keyword()
              local correct, case
              if keyword:match '^%l' then
                correct = '^%u%l+$'
                case = string.lower
              elseif keyword:match '^%u' then
                correct = '^%l+$'
                case = string.upper
              else
                return items
              end

              -- avoid duplicates from the corrections
              local seen = {}
              local out = {}
              for _, item in ipairs(items) do
                local raw = item.insertText
                if raw:match(correct) then
                  local text = case(raw:sub(1, 1)) .. raw:sub(2)
                  item.insertText = text
                  item.label = text
                end
                if not seen[item.insertText] then
                  seen[item.insertText] = true
                  table.insert(out, item)
                end
              end
              return out
            end
          },
          snippets = {
            opts = {
              extended_filetypes = {
                templ = { 'html' },
              }
            }
          }
        },
      },
    },
    opts_extend = { 'sources.default' }
  },
}
