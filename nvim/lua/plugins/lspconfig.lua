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
        clangd = { _watch_files = true },
        gopls = { _watch_files = true },
        ty = {},
        ruff = {},
        bashls = {},
        starpls = {},
        nil_ls = {},
        templ = { _watch_files = true },
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
        -- Enable file watching for servers that use external code generators
        -- (sqlc, templ, protoc, etc.). Disabled by default on Linux due to
        -- inotify scaling concerns with large directories.
        if config._watch_files then
          config._watch_files = nil
          config.capabilities = vim.tbl_deep_extend('force', config.capabilities, {
            workspace = {
              didChangeWatchedFiles = {
                dynamicRegistration = true,
              },
            },
          })
        end
        vim.lsp.config(server, config)
        vim.lsp.enable { server }
      end
    end,
  }
}
