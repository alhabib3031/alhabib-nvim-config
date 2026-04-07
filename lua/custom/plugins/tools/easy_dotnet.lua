-- lua/custom/plugins/tools/easy_dotnet.lua
-- ══════════════════════════════════════════════════════════════
-- easy-dotnet.nvim — All-in-one .NET development plugin
-- https://github.com/GustavEikaas/easy-dotnet.nvim
--
-- Handles: Run, Build, Test, Debug, Roslyn LSP, User Secrets,
--          Workspace Diagnostics, NuGet, EF Core migrations
-- ══════════════════════════════════════════════════════════════

return {
	"GustavEikaas/easy-dotnet.nvim",
	-- branch = "feat/initial-razor",
	lazy = false,
	ft = { "cs", "razor" },
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
		"mfussenegger/nvim-dap",
	},
	config = function()
		local dotnet = require("easy-dotnet")

		dotnet.setup({
			-- ── Managed terminal (runs build/run/test inside Neovim) ─
			managed_terminal = {
				auto_hide = true, -- Auto-close on success
				auto_hide_delay = 1500, -- 1.5s delay before hiding
			},

			-- ── Roslyn LSP (replaces roslyn.nvim) ────────────────────
			lsp = {
				enabled = true, -- Standalone roslyn.nvim will handle this now
				preload_roslyn = true, -- Load Roslyn before any buffer
				roslynator_enabled = true, -- Enable Roslynator analyzer
				easy_dotnet_analyzeir_enabled = true, -- easy-dotnet's own analyzer
				auto_refresh_codelens = true,
				analyzer_assemblies = {},
				config = {
					handlers = {
						["textDocument/signatureHelp"] = function(err, result, ctx, config)
							if not result then
								-- معالجة الاستجابة nil حتى لا يحدث خطأ
								return nil
							end
							-- استدعاء handler الافتراضي في Neovim
							return vim.lsp.handlers["textDocument/signatureHelp"](err, result, ctx, config)
						end,
					},
					settings = {
						["csharp|background_analysis"] = {
							-- ⚡ Only analyze open files for better performance
							dotnet_analyzer_diagnostics_scope = "openFiles",
							dotnet_compiler_diagnostics_scope = "openFiles",
						},
						["csharp|inlay_hints"] = {
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
						["csharp|code_lens"] = {
							dotnet_enable_references_code_lens = true,
						},
						["csharp|completion"] = {
							dotnet_show_completion_items_from_unimported_namespaces = true,
							dotnet_show_name_completion_suggestions = true,
						},
					},
				},
			},

			-- ── Debugger (netcoredbg via easy-dotnet-server) ─────────
			debugger = {
				bin_path = nil, -- Let easy-dotnet manage netcoredbg
				console = "internalConsole", -- Run app inside Neovim
				apply_value_converters = true,
				auto_register_dap = true,
				mappings = {
					open_variable_viewer = { lhs = "T", desc = "Open variable viewer" },
				},
			},

			-- ── Test Runner (Rider-like panel) ────────────────────────
			test_runner = {
				auto_start_testrunner = true,
				hide_legend = false,
				viewmode = "float",
				icons = {
					passed = "",
					skipped = "",
					failed = "",
					success = "",
					reload = "",
					test = "",
					sln = "󰘐",
					project = "󰘐",
					dir = "",
					package = "",
					class = "",
					build_failed = "󰒡",
				},
				mappings = {
					run_test_from_buffer = { lhs = "<leader>r", desc = "Run test from buffer" },
					get_build_errors = { lhs = "<leader>e", desc = "Get build errors" },
					peek_stack_trace_from_buffer = { lhs = "<leader>p", desc = "Peek stack trace" },
					debug_test_from_buffer = { lhs = "<leader>d", desc = "Debug test from buffer" },
					debug_test = { lhs = "<leader>d", desc = "Debug test" },
					go_to_file = { lhs = "g", desc = "Go to file" },
					run_all = { lhs = "<leader>R", desc = "Run all tests" },
					run = { lhs = "<leader>r", desc = "Run test" },
					peek_stacktrace = { lhs = "<leader>p", desc = "Peek stacktrace" },
					expand = { lhs = "o", desc = "Expand" },
					expand_node = { lhs = "E", desc = "Expand node" },
					collapse_all = { lhs = "W", desc = "Collapse all" },
					close = { lhs = "q", desc = "Close test runner" },
					refresh_testrunner = { lhs = "<C-r>", desc = "Refresh test runner" },
					cancel = { lhs = "<C-c>", desc = "Cancel operation" },
				},
			},

			-- ── New project defaults ──────────────────────────────────
			new = {
				project = {
					prefix = "sln", -- Auto-add new projects to solution
				},
			},
		})

		-- ── Notify on LSP attach ──────────────────────────────────
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				if not client then
					return
				end
				if client.name == "roslyn" or client.name == "easy-dotnet-roslyn" then
					vim.notify("Roslyn LSP attached ✓", vim.log.levels.INFO, { title = ".NET" })
				end
			end,
		})

		-- ── Keymaps ───────────────────────────────────────────────
		local map = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { desc = desc, silent = true })
		end

		-- Run & Build
		map("<leader>dr", function()
			dotnet.run()
		end, "[D]otnet [R]un")
		map("<leader>dw", function()
			dotnet.run_with_args()
		end, "[D]otnet Run [W]ith Args")
		map("<leader>db", function()
			dotnet.build()
		end, "[D]otnet [B]uild")
		map("<leader>dB", function()
			dotnet.build_solution()
		end, "[D]otnet [B]uild Solution")
		map("<leader>dC", function()
			dotnet.clean()
		end, "[D]otnet [C]lean")
		map("<leader>do", function()
			dotnet.restore()
		end, "[D]otnet Rest[o]re")

		-- Watch Run (Hot Reload) — replaces old <C-F5> ToggleTerm workaround
		map("<C-F5>", function()
			dotnet.run({ watch = true })
		end, "Dotnet Watch Run (Hot Reload)")

		-- Test Runner (replaces neotest-dotnet keymaps)
		map("<leader>nt", function()
			dotnet.test()
		end, "[N]eotest: Run nearest [T]est")
		map("<leader>nf", function()
			dotnet.test_solution()
		end, "[N]eotest: Run [F]ile / Solution tests")
		map("<leader>ns", function()
			dotnet.open_testrunner()
		end, "[N]eotest: Toggle test [S]ummary panel")

		-- NuGet / Packages
		map("<leader>dn", function()
			dotnet.nuget_search()
		end, "[D]otnet [N]uGet search")
		map("<leader>da", function()
			dotnet.add()
		end, "[D]otnet [A]dd package")

		-- Secrets & config
		map("<leader>ds", function()
			dotnet.user_secrets()
		end, "[D]otnet [S]ecrets")

		-- Workspace diagnostics (full solution errors)
		map("<leader>dD", function()
			dotnet.workspace_diagnostics()
		end, "[D]otnet Workspace [D]iagnostics")

		-- Entity Framework
		map("<leader>de", function()
			dotnet.entity_framework()
		end, "[D]otnet [E]ntityFramework")

		-- Outdated packages (virtual text)
		map("<leader>du", function()
			dotnet.outdated()
		end, "[D]otnet Outdated ([U]pdate check)")

		-- Solution / project management
		map("<leader>dp", function()
			dotnet.project()
		end, "[D]otnet [P]roject view")

		-- New project/file templates
		map("<leader>dN", function()
			dotnet.new()
		end, "[D]otnet [N]ew template")
	end,
}
