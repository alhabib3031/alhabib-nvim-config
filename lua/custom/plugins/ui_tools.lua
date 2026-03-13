-- lua/custom/plugins/ui_tools.lua
-- UI panels: Explorer, Tabs, Code Structure — Rider-inspired layout

return {
	-- ─────────────────────────────────────────────────────────────
	-- Neo-tree: Solution Explorer panel (left sidebar)
	-- ─────────────────────────────────────────────────────────────
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		config = function()
			require("neo-tree").setup({
				close_if_last_window = false,
				enable_diagnostics = true,
				enable_git_status = true,

				default_component_configs = {
					indent = { indent_size = 2, with_expanders = true },
					-- neo-tree v3.x requires `default` field in icon config
					---@diagnostic disable-next-line: missing-fields
					icon = {
						default = "",
						folder_closed = "",
						folder_open = "",
						folder_empty = "",
					},
					git_status = {
						symbols = {
							added = "",
							modified = "",
							deleted = "✖",
							renamed = "󰁕",
							untracked = "",
							ignored = "",
							unstaged = "󰄱",
							staged = "",
							conflict = "",
						},
					},
					file_size = { enabled = true },
					-- neo-tree v3.x requires `format` field in last_modified
					last_modified = {
						enabled = false,
						format = "%Y-%m-%d %H:%M",
					},
				},

				window = {
					position = "left",
					width = 35,
					mappings = {
						["\\"] = "close_window",
						["<space>"] = "toggle_node",
						["o"] = "open",
						["<cr>"] = "open",
						["S"] = "open_split",
						["s"] = "open_vsplit",
						["t"] = "open_tabnew",
						["R"] = "refresh",
						["a"] = { "add", config = { show_path = "relative" } },
						["d"] = "delete",
						["r"] = "rename",
						["c"] = "copy",
						["m"] = "move",
						["q"] = "close_window",
						["?"] = "show_help",
					},
				},

				filesystem = {
					filtered_items = {
						hide_dotfiles = false,
						hide_gitignored = false,
						hide_by_name = { "node_modules", ".git", "bin", "obj", ".vs" },
					},
					follow_current_file = { enabled = true },
					use_libuv_file_watcher = true,
				},
			})
		end,
	},

	-- ─────────────────────────────────────────────────────────────
	-- Bufferline: IDE-style tabs at the top
	-- ─────────────────────────────────────────────────────────────
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			require("bufferline").setup({
				options = {
					mode = "buffers",
					style_preset = require("bufferline").style_preset.default,
					numbers = "none",
					close_command = "bdelete! %d",
					diagnostics = "nvim_lsp",
					diagnostics_indicator = function(count, level)
						local icon = level:match("error") and " " or " "
						return " " .. icon .. count
					end,
					offsets = {
						{
							filetype = "neo-tree",
							text = "  Explorer",
							text_align = "left",
							separator = true,
						},
					},
					color_icons = true,
					show_buffer_close_icons = true,
					show_close_icon = true,
					separator_style = "thin",
					hover = { enabled = true, delay = 100, reveal = { "close" } },
				},
			})
		end,
	},

	-- ─────────────────────────────────────────────────────────────
	-- Symbols Outline: Code Structure panel (like Rider's Structure)
	-- ─────────────────────────────────────────────────────────────
	{
		"simrat39/symbols-outline.nvim",
		config = function()
			require("symbols-outline").setup({
				highlight_hovered_item = true,
				show_guides = true,
				auto_preview = false,
				position = "right",
				width = 30,
				symbols = {
					File = { icon = "", hl = "@text.uri" },
					Module = { icon = "", hl = "@namespace" },
					Namespace = { icon = "", hl = "@namespace" },
					Package = { icon = "", hl = "@namespace" },
					Class = { icon = "", hl = "@type" },
					Method = { icon = "󰊕", hl = "@method" },
					Property = { icon = "", hl = "@method" },
					Field = { icon = "", hl = "@field" },
					Constructor = { icon = "", hl = "@constructor" },
					Enum = { icon = "", hl = "@type" },
					Interface = { icon = "", hl = "@type" },
					Function = { icon = "󰊕", hl = "@function" },
					Variable = { icon = "", hl = "@constant" },
					Constant = { icon = "", hl = "@constant" },
					String = { icon = "", hl = "@string" },
					Number = { icon = "#", hl = "@number" },
					Boolean = { icon = "⊨", hl = "@boolean" },
					Array = { icon = "", hl = "@constant" },
				},
			})
		end,
		keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Code Structure" } },
	},

	-- ─────────────────────────────────────────────────────────────
	-- Noice: Better command line & notifications (like Rider's popups)
	-- ─────────────────────────────────────────────────────────────
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
		opts = {
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
				signature = { enabled = false }, -- handled by blink.cmp
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
				inc_rename = false,
			},
			routes = {
				-- Hide "written" messages
				{ filter = { event = "msg_show", kind = "", find = "written" }, opts = { skip = true } },
				-- Hide search count noise
				{ filter = { event = "msg_show", kind = "search_count" }, opts = { skip = true } },
			},
		},
	},
}
