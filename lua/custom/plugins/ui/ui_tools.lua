-- lua/custom/plugins/ui_tools.lua
-- UI panels: Explorer, Tabs, Code Structure — Rider-inspired layout

return {
	-- ─────────────────────────────────────────────────────────────
	-- Neo-tree: Solution Explorer panel (left sidebar)
	-- ─────────────────────────────────────────────────────────────
	{
		"nvim-neo-tree/neo-tree.nvim",
		-- branch = "v3.x",
		lazy = false,
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-tree/nvim-web-devicons",
				config = function()
					require("nvim-web-devicons").setup({
						override_by_extension = {
							["sln"] = { icon = "", color = "#854CC7", name = "Solution" },
							["csproj"] = { icon = "󰌛", color = "#512BD4", name = "CSharpProject" },
						},
					})
				end,
			},
			"MunifTanjim/nui.nvim",
		},
		config = function()
			require("neo-tree").setup({
				close_if_last_window = false,
				enable_diagnostics = true,
				diagnostics_update_trigger = "InsertLeave", -- or "BufWritePost"
				enable_git_status = true,

				default_component_configs = {
					indent = {
						indent_size = 2,
						padding = 1, -- extra padding for cleaner look
						with_directives = true,
						with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
						expander_collapsed = "",
						expander_expanded = "",
						expander_highlight = "NeoTreeExpander",
					},
					icon = {
						folder_closed = "",
						folder_open = "",
						folder_empty = "󰜌",
						-- The next two settings are safely managed by nvim-web-devicons
						default = "󰈚",
						highlight = "NeoTreeFileIcon"
					},
					modified = {
						symbol = "●",
						highlight = "NeoTreeModified",
					},
					name = {
						trailing_slash = false,
						use_git_status_colors = true,
						highlight = "NeoTreeFileName",
					},
					git_status = {
						symbols = {
							-- Change type
							added     = "✚", 
							modified  = "",
							deleted   = "✖",
							renamed   = "󰁕",
							-- Status type
							untracked = "★",
							ignored   = "",
							unstaged  = "󰄱",
							staged    = "",
							conflict  = "",
						}
					},
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
			
			-- ── Global UI Consistency ──────────────────────────────────
			local cyan = "#00d4ff"
			vim.api.nvim_set_hl(0, "NeoTreeCursorLine", { bg = "#1e2233", bold = true })
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
					separator_style = "thick", -- Solid block separator
					enforce_regular_tabs = true,
					always_show_bufferline = true,
					show_buffer_close_icons = true,
					show_close_icon = false,
					max_name_length = 25,
					tab_size = 20,
					diagnostics = "nvim_lsp",
					diagnostics_indicator = function(count, level)
						local icon = level:match("error") and " " or (level:match("warning") and " " or " ")
						return " " .. icon .. count
					end,
					indicator = {
						style = 'box', -- Box indicator creates the full border feel for the card
					},
					buffer_close_icon = '󰅖', -- Cleaner icon (cross)
					modified_icon = '●',
					close_icon = '',
					left_trunc_marker = '',
					right_trunc_marker = '',
					offsets = {
						{
							filetype = "neo-tree",
							text = " EXPLORER ",
							text_align = "center",
							separator = true,
						},
					},
					color_icons = true,
				},
				highlights = {
					buffer_selected = {
						fg = "#ffffff",
						bg = "NONE",
						bold = true,
						italic = false,
						sp = "#00d4ff",
						underline = true,
					},
					-- Card border effects for active tab (Full outline feel)
					indicator_selected = {
						fg = "#00d4ff", 
						bg = "NONE",
					},
					separator = {
						fg = "#24283b", 
						bg = "NONE",
					},
					separator_selected = {
						fg = "#00d4ff", -- Cyan frame sides
						bg = "NONE",
					},
					modified_selected = {
						fg = "#00d4ff",
						bg = "NONE",
					},
					close_button_selected = {
						fg = "#f7768e",
						bg = "NONE",
					},
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

	-- ─────────────────────────────────────────────────────────────
	-- Lightbulb: Rider-style code action suggestions
	-- ─────────────────────────────────────────────────────────────
	{
		"kosayoda/nvim-lightbulb",
		event = "LspAttach",
		config = function()
			require("nvim-lightbulb").setup({
				autocmd = { enabled = true },
				sign = {
					enabled = true,
					-- Rider's yellow suggestion lightbulb
					text = "💡",
					lens_text = "💡",
				},
				virtual_text = {
					enabled = false,
				},
				float = {
					enabled = false,
				},
			})
		end,
	},
}
