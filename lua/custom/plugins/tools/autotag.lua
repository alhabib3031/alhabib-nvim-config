-- lua/custom/plugins/tools/autotag.lua
-- Auto-close and auto-rename HTML/XML-like tags (including Razor)

return {
	{
		"windwp/nvim-ts-autotag",
		dependencies = { "nvim-treesitter/nvim-treesitter" },

		-- ✅ FIXED: was BufReadPre — fired BEFORE treesitter loaded.
		-- Now matches treesitter's event so the parser is always ready.
		event = { "BufReadPost", "BufNewFile" },

		opts = {
			-- New nvim-ts-autotag API (v1.0+): works via TreeSitter node types,
			-- no need for explicit filetypes list — if the TS parser is active,
			-- autotag follows automatically (razor now has a working parser).
			opts = {
				enable_close = true, -- type <div → get </div> automatically
				enable_rename = true, -- rename opening tag → closing renames too
				enable_close_on_slash = true, -- type </ → auto-complete closing tag
			},

			-- Per-filetype overrides if needed
			per_filetype = {
				-- Razor mixes HTML + C#; keep all three features on
				["razor"] = {
					enable_close = true,
					enable_rename = true,
					enable_close_on_slash = true,
				},
				-- Plain HTML: some prefer not to auto-close on slash
				["html"] = {
					enable_close_on_slash = false,
				},
			},
		},
	},
}
