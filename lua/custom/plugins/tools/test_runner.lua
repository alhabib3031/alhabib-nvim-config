-- lua/custom/plugins/test_runner.lua
-- .NET Test Runner (like Rider's test panel)

return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"Issafalcon/neotest-dotnet",
	},
	keys = {
		{ "<leader>nt", function() require("neotest").run.run() end, desc = "Run nearest test" },
		{ "<leader>nf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run file tests" },
		{ "<leader>ns", function() require("neotest").summary.toggle() end, desc = "Test summary" },
		{ "<leader>no", function() require("neotest").output.open({ enter = true }) end, desc = "Test output" },
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-dotnet")({ dap = { justMyCode = false } }),
			},
		})
	end,
}
