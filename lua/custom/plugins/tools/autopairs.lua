-- lua/custom/plugins/autopairs.lua
-- Auto-bracket/tag management

return {
	-- Autopairs
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {
			check_ts = true,
			ts_config = {
				lua = { "string" }, -- don't add pairs in lua string nodes
				javascript = { "template_string" },
			},
			disable_filetype = { "TelescopePrompt", "vim" },
		},
	},
}
