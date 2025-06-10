return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      {
        'j-hui/fidget.nvim',
        tag = 'v1.5.0',
        opts = {}
      },
    },
    opts = {
      servers = {
        lua_ls = {},
        clangd = {},
        gopls = {},
        pyright = {
          settings = {
            pyright = {
              disableOrganizeImports = true,
            },
            python = {
              analysis = {
                typeCheckingMode = 'strict',
              },
            },
          },
        },
        ruff = {},
        bashls = {},
        bzl = {},
      }
    },
    config = function(_, opts)
      for server, config in pairs(opts.servers) do
        config.capabilities = require 'blink.cmp'.get_lsp_capabilities(config.capabilities)
        vim.lsp.config(server, config)
        vim.lsp.enable { server }
      end
    end,
  }
}
