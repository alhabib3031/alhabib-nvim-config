-- lua/custom/plugins/tools/debugger.lua
-- ══════════════════════════════════════════════════════════════
-- nvim-dap UI — Rider-style debug panels
--
-- Note: Extended with manual netcoredbg setup to support Razor files.
-- This file handles UI layout, DAP keymaps, and .NET adapters.
-- ══════════════════════════════════════════════════════════════

return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
	},
	keys = {
		{
			"<F5>",
			function()
				require("dap").continue()
			end,
			desc = "Debug: Start/Continue",
		},
		{
			"<F10>",
			function()
				require("dap").step_over()
			end,
			desc = "Debug: Step Over",
		},
		{
			"<F11>",
			function()
				require("dap").step_into()
			end,
			desc = "Debug: Step Into",
		},
		{
			"<S-F11>",
			function()
				require("dap").step_out()
			end,
			desc = "Debug: Step Out",
		},
		{
			"<leader>b",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "Debug: Toggle Breakpoint",
		},
		{
			"<leader>B",
			function()
				require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end,
			desc = "Debug: Conditional Breakpoint",
		},
		{
			"<F7>",
			function()
				require("dapui").toggle()
			end,
			desc = "Debug: Toggle UI",
		},
		{
			"<leader>dR",
			function()
				require("dap").repl.open()
			end,
			desc = "Debug: Open REPL",
		},
		{
			"<leader>dq",
			function()
				require("dap").terminate()
			end,
			desc = "Debug: Stop",
		},
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		-- Required for debugging .NET Core, MAUI, and Blazor apps
		-- ── 1. NetCoreDbg Adapter Setup (Fixed Path for Windows) ──
		-- Function to fix slashes for Windows
		local function fix_path(path)
			return path:gsub("/", "\\")
		end

		local mason_path = vim.fn.stdpath("data") .. "/mason/bin/netcoredbg.exe"
		local final_path = fix_path(mason_path)

		dap.adapters.coreclr = {
			type = "executable",
			command = final_path,
			args = { "--interpreter=vscode" },
		}

		-- ── 2. .NET Configuration for MAUI/Blazor ────────────────
		dap.configurations.cs = {
			{
				type = "coreclr",
				name = "Launch - NetCoreDbg",
				request = "launch",
				program = function()
					-- Automatically look for the executable in the bin folder
					local paths = vim.fn.glob(vim.fn.getcwd() .. "/bin/Debug/**/*.exe", true, true)

					if #paths > 0 then
						-- Clean paths for Windows to avoid ENOENT
						for i, p in ipairs(paths) do
							paths[i] = fix_path(p)
						end

						if #paths == 1 then
							return paths[1]
						end
						return vim.fn.input("Select Executable: ", paths[1], "file")
					end

					return vim.fn.input("Path to exe: ", fix_path(vim.fn.getcwd() .. "/bin/Debug/"), "file")
				end,
			},
		}

		-- ── 3. Razor Support ─────────────────────────────────────
		dap.configurations.razor = dap.configurations.cs

		-- ── DAP UI Layout ────────────────────────────────────────
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

		-- Auto open/close DAP UI on debug session events
		---@diagnostic disable-next-line: undefined-field
		dap.listeners.after.event_initialized["dapui_config"] = dapui.open
		---@diagnostic disable-next-line: undefined-field
		dap.listeners.before.event_terminated["dapui_config"] = dapui.close
		---@diagnostic disable-next-line: undefined-field
		dap.listeners.before.event_exited["dapui_config"] = dapui.close

		-- ── Breakpoint signs (Rider style) ───────────────────────
		vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError", linehl = "", numhl = "" })
		vim.fn.sign_define(
			"DapBreakpointCondition",
			{ text = "◆", texthl = "DiagnosticWarn", linehl = "", numhl = "" }
		)
		vim.fn.sign_define(
			"DapStopped",
			{ text = "▶", texthl = "DiagnosticInfo", linehl = "DiagnosticUnderlineInfo", numhl = "" }
		)
		vim.fn.sign_define(
			"DapBreakpointRejected",
			{ text = "✖", texthl = "DiagnosticError", linehl = "", numhl = "" }
		)
	end,
}
