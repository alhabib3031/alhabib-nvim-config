-- lua/custom/plugins/lsp_csharp.lua
-- Roslyn LSP: C# IntelliSense, diagnostics & code actions (like Rider)

return {
	"seblyng/roslyn.nvim",
	ft = { "cs", "razor", "cshtml" },
	dependencies = { "mason-org/mason.nvim" },

	---@module 'roslyn.config'
	---@type RoslynNvimConfig
	opts = {
		broad_search = true,
		filewatching = "roslyn",
	},

	config = function(_, opts)
		-- Configure Roslyn LSP settings (diagnostics, IntelliSense, etc.)
		vim.lsp.config("roslyn", {
			settings = {
				["csharp|background_analysis"] = {
					dotnet_analyzer_diagnostics_scope = "fullSolution",
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
					dotnet_show_completion_items_from_unimported_namespaces = true,
					dotnet_show_name_completion_suggestions = true,
				},
			},
		})

		-- Setup the plugin
		require("roslyn").setup(opts)

		-- Notify when Roslyn attaches successfully
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function(args)
				local client = vim.lsp.get_client_by_id(args.data.client_id)
				if not client or client.name ~= "roslyn" then
					return
				end
				vim.notify("Roslyn LSP attached ✓", vim.log.levels.INFO, { title = ".NET" })
			end,
		})
	end,
}
