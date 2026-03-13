-- lua/custom/plugins/dotnet_tools.lua
-- All .NET-related tooling: LSP, debugging, test runner

return {
  -- ─────────────────────────────────────────────────────────────
  -- Roslyn LSP: full C# IntelliSense (like Rider's ReSharper engine)
  -- ─────────────────────────────────────────────────────────────
  {
    'seblyng/roslyn.nvim',
    ft = { 'cs', 'csproj', 'sln' },
    dependencies = { 'mason-org/mason.nvim' },
    opts = {
      filewatching = 'roslyn',
      -- Enable all Roslyn features
      config = {
        settings = {
          ['csharp|inlay_hints'] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
            csharp_enable_inlay_hints_for_lambda_parameter_types = true,
            csharp_enable_inlay_hints_for_types = true,
            dotnet_enable_inlay_hints_for_indexer_parameters = true,
            dotnet_enable_inlay_hints_for_literal_parameters = true,
            dotnet_enable_inlay_hints_for_object_creation_parameters = true,
            dotnet_enable_inlay_hints_for_other_parameters = true,
            dotnet_enable_inlay_hints_for_parameters = true,
            dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
            dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
          },
          ['csharp|code_lens'] = {
            dotnet_enable_references_code_lens = true,
          },
        },
      },
    },
  },

  -- ─────────────────────────────────────────────────────────────
  -- Razor / Blazor support
  -- ─────────────────────────────────────────────────────────────
  {
    'tris203/rzls.nvim',
    ft = { 'razor', 'cshtml' },
    opts = {},
  },

  -- ─────────────────────────────────────────────────────────────
  -- DAP: .NET debugger (like Rider's debugger panel)
  -- ─────────────────────────────────────────────────────────────
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',
      'mason-org/mason.nvim',
    },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'

      -- ── UI Setup ──────────────────────────────────────────────
      dapui.setup {
        icons = { expanded = '', collapsed = '', current_frame = '' },
        layouts = {
          {
            elements = {
              { id = 'scopes', size = 0.40 },
              { id = 'breakpoints', size = 0.15 },
              { id = 'stacks', size = 0.30 },
              { id = 'watches', size = 0.15 },
            },
            size = 40,
            position = 'left',
          },
          {
            elements = {
              { id = 'repl', size = 0.5 },
              { id = 'console', size = 0.5 },
            },
            size = 12,
            position = 'bottom',
          },
        },
      }

      -- Auto open/close UI
      dap.listeners.after.event_initialized['dapui_config'] = dapui.open
      dap.listeners.before.event_terminated['dapui_config'] = dapui.close
      dap.listeners.before.event_exited['dapui_config'] = dapui.close

      -- ── .NET CoreCLR adapter ──────────────────────────────────
      dap.adapters.coreclr = {
        type = 'executable',
        command = 'netcoredbg',
        args = { '--interpreter=vscode' },
      }

      dap.configurations.cs = {
        {
          type = 'coreclr',
          name = 'Launch (netcoredbg)',
          request = 'launch',
          program = function()
            -- Auto-detect the project DLL from the nearest .csproj
            local csproj = vim.fn.glob(vim.fn.getcwd() .. '/**/*.csproj', true, true)[1]
            if csproj then
              local proj_name = vim.fn.fnamemodify(csproj, ':t:r')
              local dll = vim.fn.glob(vim.fn.fnamemodify(csproj, ':h') .. '/bin/Debug/**/' .. proj_name .. '.dll', true, true)[1]
              if dll then return dll end
            end
            return vim.fn.input('Path to .dll: ', vim.fn.getcwd() .. '/bin/Debug/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopAtEntry = false,
          console = 'internalConsole',
        },
        {
          type = 'coreclr',
          name = 'Attach to process',
          request = 'attach',
          processId = require('dap.utils').pick_process,
        },
      }

      -- Breakpoint icons
      vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DiagnosticError', linehl = '', numhl = '' })
      vim.fn.sign_define('DapBreakpointCondition', { text = '', texthl = 'DiagnosticWarn', linehl = '', numhl = '' })
      vim.fn.sign_define('DapStopped', { text = '', texthl = 'DiagnosticInfo', linehl = 'DiagnosticUnderlineInfo', numhl = '' })
      vim.fn.sign_define('DapBreakpointRejected', { text = '', texthl = 'DiagnosticError', linehl = '', numhl = '' })
    end,
  },

  -- ─────────────────────────────────────────────────────────────
  -- Neotest: run .NET tests inline (like Rider's test runner)
  -- ─────────────────────────────────────────────────────────────
  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
      'Issafalcon/neotest-dotnet',
    },
    keys = {
      { '<leader>nt', function() require('neotest').run.run() end, desc = 'Run nearest test' },
      { '<leader>nf', function() require('neotest').run.run(vim.fn.expand '%') end, desc = 'Run file tests' },
      { '<leader>ns', function() require('neotest').summary.toggle() end, desc = 'Test summary' },
      { '<leader>no', function() require('neotest').output.open { enter = true } end, desc = 'Test output' },
    },
    config = function()
      require('neotest').setup {
        adapters = {
          require 'neotest-dotnet' {
            dap = { justMyCode = false },
          },
        },
      }
    end,
  },
}
