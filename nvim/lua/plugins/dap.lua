return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'leoluz/nvim-dap-go',
      'mfussenegger/nvim-dap-python',
      'rcarriga/nvim-dap-ui',
      'theHamsta/nvim-dap-virtual-text',
      'nvim-neotest/nvim-nio',
      'williamboman/mason.nvim',
    },
    config = function()
      local dap = require 'dap'
      local ui = require 'dapui'
      require 'dapui'.setup()
      require 'dap-go'.setup()
      require 'dap-python'.setup 'uv'
      vim.keymap.set('n', '<leader>db', function() dap.toggle_breakpoint() end, { desc = 'Dap: Toggle Breakpoint (b)' })
      vim.keymap.set('n', '<leader>dr', function() dap.continue() end, { desc = 'Dap: Run/Start (r)' })
      vim.keymap.set('n', '<leader>dc', function() dap.continue() end, { desc = 'Dap: Continue (c)' })
      vim.keymap.set('n', '<leader>dn', function() dap.step_over() end, { desc = 'Dap: Step Over (n)' })
      vim.keymap.set('n', '<leader>ds', function() dap.step_into() end, { desc = 'Dap: Step Into (s)' })
      vim.keymap.set('n', '<leader>df', function() dap.step_out() end, { desc = 'Dap: Step Out/Finish (f)' })
      vim.keymap.set('n', '<leader>dg', function() dap.run_to_cursor() end, { desc = 'Dap: Run to Cursor (g)' })
      vim.keymap.set({ 'n', 'v' }, '<leader>dp', function() dap.repl.run('print ' .. vim.fn.input 'Expr: ') end, { desc = 'Dap: Print Expression (p)' })
      vim.keymap.set('n', '<leader>dR', function() dap.repl.open() end, { desc = 'Dap: Open REPL (R)' })
      vim.keymap.set({ 'n', 'v' }, '<leader>dh', function() require 'dap.ui.widgets'.hover() end, { desc = 'Dap: Hover Values (h)' })
      vim.keymap.set('n', '<leader>di', function() require 'dap.ui.widgets'.centered_float(require 'dap.ui.widgets'.scopes) end,
        { desc = 'Dap: Show Scopes Sidebar (i)' })
      vim.keymap.set('n', '<leader>dq', function() dap.terminate() end, { desc = 'Dap: Terminate Session (q)' })
      vim.keymap.set('n', '<leader>du', function() require 'dapui'.toggle() end, { desc = 'Dap: Toggle UI (u)' })
      dap.listeners.before.attach.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        ui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        ui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        ui.close()
      end
    end,
  },
}
