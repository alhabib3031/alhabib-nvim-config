-- lua/custom/plugins/ui/dashboard.lua
-- ╔══════════════════════════════════════════╗
-- ║   ALHABIB IDE — Ultra Modern Dashboard  ║
-- ║   Theme: JetBrains Rider Dark 2026      ║
-- ╚══════════════════════════════════════════╝

return {
	"nvimdev/dashboard-nvim",
	event = "VimEnter",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		-- ── Actions from dotnet_actions.lua ─────────────────────────
		local actions_mod = require("custom.dotnet_actions")

		if _G.settings and not _G.settings.enable_dashboard then
			return
		end

		-- ── Safe project opener ──────────────────────────────────────
		local function open_project_dir(dir)
			if _G.OpenProjectDir then
				_G.OpenProjectDir(dir)
			else
				local normalized_path = dir:gsub("\\", "/"):gsub("//", "/")
				normalized_path = vim.fn.fnamemodify(normalized_path, ":p")
				if normalized_path:sub(-1) == "/" then
					normalized_path = normalized_path:sub(1, -2)
				end
				vim.api.nvim_set_current_dir(normalized_path)
				vim.defer_fn(function()
					require("neo-tree.command").execute({
						action = "show",
						source = "filesystem",
						position = "left",
						dir = normalized_path,
						reveal = true,
					})
				end, 60)
			end
		end

		-- ── Collect recent .NET projects (styled like Rider) ─────────
		local function get_recent_projects()
			local results = {}
			local seen_dirs = {}
			local oldfiles = vim.v.oldfiles or {}
			for _, file in ipairs(oldfiles) do
				if #results >= 7 then
					break
				end
				local dir = vim.fn.fnamemodify(file, ":p:h")
				local ext = vim.fn.fnamemodify(file, ":e")

				if
					not seen_dirs[dir]
					and (ext == "cs" or ext == "sln" or ext == "csproj" or ext == "cshtml" or ext == "razor")
				then
					seen_dirs[dir] = true
					local label = vim.fn.fnamemodify(dir, ":t")
					if label == "" then
						label = "Solution"
					end

					local path = vim.fn.fnamemodify(dir, ":~")
					if #path > 60 then
						path = "..." .. path:sub(-57)
					end

					table.insert(results, { path = dir, label = label, full_path = path })
				end
			end
			return results
		end

		-- ════════════════════════════════════════════════════════════════
		--  HEADER  — ALHABIB IDE (Premium 2026)
		-- ════════════════════════════════════════════════════════════════
		local header = {
			"",
			"   █████╗ ██╗     ██╗  ██╗ █████╗ ██████╗ ██╗██████╗    ██╗██████╗ ███████╗",
			"  ██╔══██╗██║     ██║  ██║██╔══██╗██╔══██╗██║██╔══██╗   ██║██╔══██╗██╔════╝",
			"  ███████║██║     ███████║███████║██████╔╝██║██████╔╝   ██║██║  ██║█████╗  ",
			"  ██╔══██║██║     ██╔══██║██╔══██║██╔══██╗██║██╔══██╗   ██║██║  ██║██╔══╝  ",
			"  ██║  ██║███████╗██║  ██║██║  ██║██████╔╝██║██████╔╝   ██║██████╔╝███████╗",
			"  ╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝ ╚═╝╚═════╝    ╚═╝╚═════╝ ╚══════╝",
			"",
			"             ░░░  A L H A B I B  ·  I D E  ·  2 0 2 6  ░░░",
			"",
		}

		-- ════════════════════════════════════════════════════════════════
		--  CENTER MENU — Global Actions (Buttons)
		-- ════════════════════════════════════════════════════════════════
		local items = {
			{
				icon = "󰌛 ",
				desc = " New Project / Solution                ",
				key = "n",
				shortcut = "N",
				action = function()
					require("custom.project_creator").new_project()
				end,
			},
			{
				icon = "󰂬 ",
				desc = " Open Project                          ",
				key = "o",
				shortcut = "O",
				action = "lua OpenProject()",
			},
			{
				icon = " ",
				desc = " Clone Repository                      ",
				key = "c",
				shortcut = "C",
				action = function()
					actions_mod.clone_repo()
				end,
			},
			{
				icon = " ",
				desc = " Git Timeline                          ",
				key = "g",
				shortcut = "G",
				action = function()
					require("custom.git_timeline").git_projects_picker()
				end,
			},
			{
				icon = "⌕ ",
				desc = " Search Projects (Fuzzy)               ",
				key = "f",
				shortcut = "F",
				action = function()
					require("fzf-lua").files()
				end,
			},
			{
				icon = "⚙  ",
				desc = " Settings                              ",
				key = ",",
				shortcut = ",",
				action = "edit " .. vim.fn.stdpath("config") .. "/init.lua",
			},
			{
				icon = " ",
				desc = " Quit                                  ",
				key = "q",
				shortcut = "Q",
				action = "qa",
			},
		}

		-- Inject recent projects with Rider-style formatting
		local recent = get_recent_projects()
		if #recent > 0 then
			table.insert(items, 5, {
				icon = "↪ ",
				desc = " Recent Projects ─────────────────────────────────────────────────────────────────────────────────────",
				action = "",
			})
			for i, proj in ipairs(recent) do
				local pad = string.rep(" ", math.max(0, 40 - #proj.label))
				table.insert(items, 5 + i, {
					icon = " ",
					desc = " " .. proj.label .. pad .. "  " .. proj.full_path,
					key = tostring(i),
					action = function()
						open_project_dir(proj.path)
					end,
				})
			end
		end

		-- ════════════════════════════════════════════════════════════════
		--  SETUP
		-- ════════════════════════════════════════════════════════════════
		require("dashboard").setup({
			theme = "doom",
			hide = { statusline = true, tabline = true, winbar = true },
			config = {
				header = header,
				center = items,
				footer = function()
					local v = vim.version()
					local ver = string.format("%d.%d.%d", v.major, v.minor, v.patch)
					local ok, lazy = pcall(require, "lazy")
					local plugins = ok and tostring(lazy.stats().loaded) or "?"
					return {
						"",
						"   ⚡ Neovim " .. ver .. " · Loaded " .. plugins .. " plugins · ALHABIB IDE 2026",
						"",
					}
				end,
			},
		})

		-- ════════════════════════════════════════════════════════════════
		--  HIGHLIGHTS
		-- ════════════════════════════════════════════════════════════════
		local hl = vim.api.nvim_set_hl

		-- Rider Dark palette
		hl(0, "DashboardHeader", { fg = "#6C95EB", bold = true }) -- Rider Blue
		hl(0, "DashboardCenter", { fg = "#A5A5AA" }) -- Rider foreground
		hl(0, "DashboardIcon", { fg = "#39CC8F", bold = true }) -- Rider bright green
		hl(0, "DashboardDesc", { fg = "#6C95EB" }) -- Rider blue
		hl(0, "DashboardShortCut", { fg = "#ED94C0", bold = true }) -- Rider pink/purple
		hl(0, "DashboardFooter", { fg = "#6A9955", italic = true }) -- Comment green
		hl(0, "DashboardKey", { fg = "#C9A26D", bold = true }) -- Rider yellow/gold
	end,
}
