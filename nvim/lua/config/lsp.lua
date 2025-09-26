vim.diagnostic.config {
  virtual_lines = { current_line = true },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
      [vim.diagnostic.severity.INFO] = ' ',
    },
  },
  severity_sort = true,
  float = {
    source = 'if_many',
  },
}
-- Diagnostic keymaps
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating [E]rror message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics [Q]uickfix list' })
vim.keymap.set('n', '<leader>wq', function()
  vim.diagnostic.setqflist()
  vim.cmd 'copen'
end, { desc = 'Open [W]orkspace diagnostics in [Q]uickfix' })

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(event)
    local map = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    -- Note: To jump back, press <C-T>
    map('grd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    map('grD', vim.lsp.buf.type_definition, 'Type [D]efinition')
    map('grs', vim.lsp.buf.document_symbol, '[D]ocument [S]ymbols')
    map('grws', vim.lsp.buf.workspace_symbol, '[W]orkspace [S]ymbols')
    map('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client then
      return
    end

    if client.server_capabilities.documentHighlightProvider then
      vim.api.nvim_create_augroup('lsp_document_highlight', {
        clear = false,
      })
      vim.api.nvim_clear_autocmds {
        buffer = event.buf,
        group = 'lsp_document_highlight',
      }
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        group = 'lsp_document_highlight',
        buffer = event.buf,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        group = 'lsp_document_highlight',
        buffer = event.buf,
        callback = vim.lsp.buf.clear_references,
      })
    end
  end,
})
