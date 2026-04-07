-- lua/custom/plugins/lsp/roslyn.lua
-- Standalone Roslyn configuration to allow for specific commits and manual modification

return {
	"seblyng/roslyn.nvim",
	enabled = false,
	commit = "82d0c9724c3f8eab7342a3a136782b4788070bd0",
	lazy = false,
	ft = { "cs" }, --"razor" },
	dependencies = {
		{
			-- For better razor support, you can also use a specific commit for the parser if needed
			"nvim-treesitter/nvim-treesitter",
		},
	},
	opts = {
		-- Turn off neovim filewatching which will make roslyn do the filewatching
		-- This is usually much better for performance and large .NET projects on Windows.
		filewatching = "roslyn",

		config = {
			-- Disable LSP diagnostics from Roslyn to use easy-dotnet diagnostics instead
			handlers = {
				-- ["textDocument/publishDiagnostics"] = function() end,

				["textDocument/hover"] = function(err, result, ctx, config)
					return vim.lsp.handlers["textDocument/hover"](err, result, ctx, vim.tbl_deep_extend("force", config or {}, {
						border = "rounded", -- or "single", "double", "solid"
					}))
				end,

				["textDocument/signatureHelp"] = function(err, result, ctx, config)
					return vim.lsp.handlers["textDocument/signatureHelp"](err, result, ctx, vim.tbl_deep_extend("force", config or {}, {
						border = "rounded",
						focusable = false, -- prevent you from jumping into this popup window
					}))
				end,
			},
			-- Pass standard LSP settings here
			settings = {
				["csharp|background_analysis"] = {
					dotnet_analyzer_diagnostics_scope = "openFiles",
					dotnet_compiler_diagnostics_scope = "fullSolution",
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
					dotnet_provide_regex_completions = true,
					dotnet_show_completion_items_from_unimported_namespaces = true,
					dotnet_show_name_completion_suggestions = true,
				},
				["csharp|symbol_search"] = {
					dotnet_search_reference_assemblies = true,
				},
				["csharp|formatting"] = {
					dotnet_organize_imports_on_format = true,
				},
			},
		},
		-- If you want to use a specific version of the Microsoft.CodeAnalysis.LanguageServer,
		-- you can use exe = { "path/to/server" } or the version option if the plugin supports it
		-- For example:
		-- exe = "Microsoft.CodeAnalysis.LanguageServer",
		-- args = {
		-- 	"--logLevel=Information",
		-- 	"--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.log.get_filename()),
		-- },
	},
}
