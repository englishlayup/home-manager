return {
  'mfussenegger/nvim-lint',
  config = function()
    require 'lint'.linters_by_ft = {
      bzl = { 'buildifier' },
      bash = { 'shellcheck' },
      cmake = { 'cmake_lint' },
    }
    vim.api.nvim_create_autocmd({ 'VimEnter', 'BufWritePost' }, {
      callback = function()
        require 'lint'.try_lint()
      end,
    })
  end,
}
