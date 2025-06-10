return {
  'stevearc/conform.nvim',
  opts = {
    formatters_by_ft = {
      bzl = { 'buildifier' },
      c = { 'clang-format' },
      nix = { 'nixfmt' },
    },
  },
}
