return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      {
        'j-hui/fidget.nvim',
        tag = 'v1.6.1',
        opts = {}
      },
    },
    opts = {
      servers = {
        lua_ls = {},
        clangd = {},
        gopls = {},
        ty = {},
        ruff = {},
        bashls = {
            filetypes = { 'zsh' },
        },
        starpls = {},
        nil_ls = {},
        templ = {},
        htmx = {},
        html = {
          filetypes = { 'html' },
        },
        tailwindcss = {
          settings = {
            tailwindCSS = {
              includeLanguages = {
                templ = 'html',
              },
            },
          },
        },
        cmake = {},
      },
    },
    config = function(_, opts)
      for server, config in pairs(opts.servers) do
        config.capabilities = require 'blink.cmp'.get_lsp_capabilities(config.capabilities)
        -- Enable file watching on Linux so LSP picks up changes from external
        -- tools (sqlc, templ, etc.) without needing :LspRestart.
        -- Disabled by default on Linux due to scaling concerns with large dirs.
        config.capabilities = vim.tbl_deep_extend('force', config.capabilities, {
          workspace = {
            didChangeWatchedFiles = {
              dynamicRegistration = true,
            },
          },
        })
        vim.lsp.config(server, config)
        vim.lsp.enable { server }
      end
    end,
  }
}
