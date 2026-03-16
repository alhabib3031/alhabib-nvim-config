-- lua/custom/plugins/debugger.lua
-- .NET Debugger (DAP) with Rider-style keybindings

return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
		"mason-org/mason.nvim",
	},
	keys = {
		-- ── Visual Studio / Rider keybindings ──────────────────
		{ "<F5>", function() require("dap").continue() end, desc = "Debug: Start/Continue" },
		{ "<F10>", function() require("dap").step_over() end, desc = "Debug: Step Over" },
		{ "<F11>", function() require("dap").step_into() end, desc = "Debug: Step Into" },
		{ "<S-F11>", function() require("dap").step_out() end, desc = "Debug: Step Out" },
		{ "<leader>b", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle Breakpoint" },
		{
			"<leader>B",
			function()
				require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end,
			desc = "Debug: Conditional Breakpoint",
		},
		{ "<F7>", function() require("dapui").toggle() end, desc = "Debug: Toggle UI" },
		{ "<leader>dr", function() require("dap").repl.open() end, desc = "Debug: Open REPL" },
		{ "<leader>dl", function() require("dap").run_last() end, desc = "Debug: Run Last" },
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		---@diagnostic disable-next-line: missing-fields
		dapui.setup({
			layouts = {
				{
					elements = {
						{ id = "scopes", size = 0.40 },
						{ id = "breakpoints", size = 0.15 },
						{ id = "stacks", size = 0.30 },
						{ id = "watches", size = 0.15 },
					},
					size = 40,
					position = "left",
				},
				{
					elements = {
						{ id = "repl", size = 0.5 },
						{ id = "console", size = 0.5 },
					},
					size = 12,
					position = "bottom",
				},
			},
		})

		-- Auto open/close DAP UI
		---@diagnostic disable-next-line: undefined-field
		dap.listeners.after.event_initialized["dapui_config"] = dapui.open
		---@diagnostic disable-next-line: undefined-field
		dap.listeners.before.event_terminated["dapui_config"] = dapui.close
		---@diagnostic disable-next-line: undefined-field
		dap.listeners.before.event_exited["dapui_config"] = dapui.close

		-- ── .NET CoreCLR adapter via netcoredbg ────────────────
		local netcoredbg_path = vim.fs.joinpath(
			vim.fn.stdpath("data"),
			"mason", "packages", "netcoredbg", "netcoredbg", "netcoredbg.exe"
		)

		---@diagnostic disable-next-line: undefined-field
		dap.adapters.coreclr = {
			type = "executable",
			command = netcoredbg_path,
			args = { "--interpreter=vscode" },
		}

		---@diagnostic disable-next-line: undefined-field
		dap.configurations.cs = {
			{
				type = "coreclr",
				name = "Launch .NET Project",
				request = "launch",
				program = function()
					local csproj = vim.fn.glob(vim.fn.getcwd() .. "/**/*.csproj", true, true)[1]
					if csproj then
						local proj_name = vim.fn.fnamemodify(csproj, ":t:r")
						local dll = vim.fn.glob(
							vim.fn.fnamemodify(csproj, ":h") .. "/bin/Debug/**/" .. proj_name .. ".dll",
							true, true
						)[1]
						if dll then
							return dll
						end
					end
					return vim.fn.input("Path to .dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
				end,
				cwd = "${workspaceFolder}",
				stopAtEntry = false,
				console = "internalConsole",
			},
			{
				type = "coreclr",
				name = "Attach to process",
				request = "attach",
				processId = require("dap.utils").pick_process,
			},
		}

		-- ── Breakpoint signs (Rider style) ─────────────────────
		vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError", linehl = "", numhl = "" })
		vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn", linehl = "", numhl = "" })
		vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticInfo", linehl = "DiagnosticUnderlineInfo", numhl = "" })
		vim.fn.sign_define("DapBreakpointRejected", { text = "✖", texthl = "DiagnosticError", linehl = "", numhl = "" })
	end,
}
