-- lua/keymaps-dotnet.lua
-- .NET and DAP specific keymaps (moved out of main keymaps)

local keymap = vim.keymap.set
local opts   = { noremap = true, silent = true }

-- DAP mappings (F-keys)
keymap("n", "<F5>",    function() require("dap").continue()   end, { desc = "Debug: Start/Continue" })
keymap("n", "<F10>",   function() require("dap").step_over()  end, { desc = "Debug: Step Over" })
keymap("n", "<F11>",   function() require("dap").step_into()  end, { desc = "Debug: Step Into" })
keymap("n", "<S-F11>", function() require("dap").step_out()   end, { desc = "Debug: Step Out" })
keymap("n", "<leader>b", function() require("dap").toggle_breakpoint() end, { desc = "Debug: Toggle Breakpoint" })
keymap("n", "<leader>B", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, { desc = "Debug: Conditional Breakpoint" })
keymap("n", "<F7>",       function() require("dapui").toggle()  end, { desc = "Debug: Toggle UI" })
keymap("n", "<leader>dR", function() require("dap").repl.open() end, { desc = "Debug: Open REPL" })
keymap("n", "<leader>dq", function() require("dap").terminate() end, { desc = "Debug: Stop" })

-- .NET / easy-dotnet mappings
keymap("n", "<leader>dr", function() require("easy-dotnet").run()             end, { desc = "[D]otnet [R]un" })
keymap("n", "<leader>dw", function() require("easy-dotnet").run_with_args()   end, { desc = "[D]otnet Run [W]ith Args" })
keymap("n", "<leader>db", function() require("easy-dotnet").build()           end, { desc = "[D]otnet [B]uild" })
keymap("n", "<leader>dB", function() require("easy-dotnet").build_solution()  end, { desc = "[D]otnet [B]uild Solution" })
keymap("n", "<leader>dC", function() require("easy-dotnet").clean()           end, { desc = "[D]otnet [C]lean" })
keymap("n", "<leader>do", function() require("easy-dotnet").restore()         end, { desc = "[D]otnet Rest[o]re" })
keymap("n", "<C-F5>",     function() require("easy-dotnet").run({ watch = true }) end, { desc = "Dotnet Watch Run (Hot Reload)" })

-- NuGet
keymap("n", "<leader>dn", function() require("easy-dotnet").nuget_search()       end, { desc = "[D]otnet [N]uGet Search" })
keymap("n", "<leader>da", function() require("easy-dotnet").add()                end, { desc = "[D]otnet [A]dd Package" })
keymap("n", "<leader>du", function() require("easy-dotnet").outdated()           end, { desc = "[D]otnet Outdated ([U]pdate check)" })

-- Secrets & Diagnostics
keymap("n", "<leader>ds", function() require("easy-dotnet").user_secrets()          end, { desc = "[D]otnet [S]ecrets" })
keymap("n", "<leader>dD", function() require("easy-dotnet").workspace_diagnostics() end, { desc = "[D]otnet Workspace [D]iagnostics" })

-- Entity Framework
keymap("n", "<leader>de", function() require("easy-dotnet").entity_framework() end, { desc = "[D]otnet [E]ntityFramework" })

-- Project / Template
keymap("n", "<leader>dp", function() require("easy-dotnet").project()          end, { desc = "[D]otnet [P]roject view" })
keymap("n", "<leader>dN", function() require("easy-dotnet").new()              end, { desc = "[D]otnet [N]ew template" })

-- Test Runner (easy-dotnet)
keymap("n", "<leader>nt", function() require("easy-dotnet").test()             end, { desc = "[N]eotest: Run nearest [T]est" })
keymap("n", "<leader>nf", function() require("easy-dotnet").test_solution()    end, { desc = "[N]eotest: Run [F]ile/Solution" })
keymap("n", "<leader>ns", function() require("easy-dotnet").open_testrunner()  end, { desc = "[N]eotest: Toggle [S]ummary panel" })

return {}
