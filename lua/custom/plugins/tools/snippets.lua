-- lua/custom/plugins/tools/snippets.lua
-- ══════════════════════════════════════════════════════════════
-- LuaSnip — snippet engine with VSCode compat + custom C# / Lua snippets
-- ══════════════════════════════════════════════════════════════

return {
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		build = "make install_jsregexp",
		dependencies = {
			-- VSCode-style snippets from the community
			"rafamadriz/friendly-snippets",
		},
		config = function()
			local ls  = require("luasnip")
			local s   = ls.snippet
			local t   = ls.text_node
			local i   = ls.insert_node
			local fmt = require("luasnip.extras.fmt").fmt

			-- ── Load community (VSCode) snippets ─────────────────────────
			require("luasnip.loaders.from_vscode").lazy_load()

			-- ── Snippet expansion keymaps ────────────────────────────────
			vim.keymap.set({ "i", "s" }, "<Tab>", function()
				if ls.expand_or_jumpable() then
					ls.expand_or_jump()
				else
					vim.api.nvim_feedkeys(
						vim.api.nvim_replace_termcodes("<Tab>", true, false, true),
						"n", false
					)
				end
			end, { silent = true, desc = "Snippet: expand or jump forward" })

			vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
				if ls.jumpable(-1) then ls.jump(-1) end
			end, { silent = true, desc = "Snippet: jump backward" })

			-- ── C# snippets ───────────────────────────────────────────────
			ls.add_snippets("cs", {
				-- XML doc summary
				s("/// summary", fmt(
					[[
///<summary>
/// {}
///</summary>
					]], { i(1) }
				)),

				-- Auto-property
				s("prop", fmt(
					"public {} {} {{ get; set; }}",
					{ i(1, "string"), i(2, "Name") }
				)),

				-- Constructor
				s("ctor", fmt(
					[[
public {}({})
{{
	{}
}}
					]], { i(1, "ClassName"), i(2), i(3) }
				)),

				-- Null check
				s("nn", fmt(
					[[
ArgumentNullException.ThrowIfNull({});
					]], { i(1, "value") }
				)),

				-- DI field
				s("di", fmt(
					"private readonly {} _{};",
					{ i(1, "IService"), i(2, "service") }
				)),

				-- Async method
				s("asyncm", fmt(
					[[
public async Task<{}> {}({})
{{
	{}
}}
					]], { i(1, "T"), i(2, "MethodName"), i(3), i(4) }
				)),

				-- Console.WriteLine
				s("cw", fmt(
					'Console.WriteLine({});',
					{ i(1, "\"message\"") }
				)),
			})

			-- ── Lua snippets ───────────────────────────────────────────────
			ls.add_snippets("lua", {
				s("hello", {
					t('print("Hello, World!")')
				}),
				s("req", fmt(
					'local {} = require("{}")',
					{ i(1, "module"), i(2, "module") }
				)),
			})
		end,
	},
}
