-- ═══════════════════════════════════════════════════════════════════════════════
-- Theme Manager for Neovim
-- Loads themes from centralized palette system
-- ═══════════════════════════════════════════════════════════════════════════════

local M = {}

-- Default theme (used if no theme is specified)
M.default = "gruvbox"

-- Map of theme names to colorscheme names
M.theme_map = {
	gruvbox = "gruvbox",
	catppuccin = "catppuccin",
	everforest = "everforest",
	kanagawa = "kanagawa",
	oxocarbon = "oxocarbon",
}

--- Get current theme name from file (for SIGUSR1 reload)
function M.get_current()
	-- First, try to read from current_theme file (set by theme-manager.py)
	local theme_file = vim.fn.stdpath("config") .. "/themes/current_theme"
	if vim.fn.filereadable(theme_file) == 1 then
		local content = vim.fn.readfile(theme_file)
		-- content is a table/array of lines, get first line
		if content and #content > 0 then
			local theme = vim.trim(content[1])
			-- Print for debugging
			vim.notify("Reading theme from file: " .. theme, vim.log.levels.DEBUG)
			return theme:lower()
		end
	end

	-- Fallback: try vim.g.colors_name
	if vim.g.colors_name then
		return vim.g.colors_name:lower()
	end

	-- Final fallback: default
	return M.default
end

--- Load theme by name
function M.load(theme_name)
	theme_name = theme_name or M.get_current()

	-- Map theme name to colorscheme name
	local colorscheme_name = M.theme_map[theme_name] or theme_name

	-- Clear module cache
	package.loaded["themes." .. theme_name] = nil

	-- Check if local theme file exists (explicit check)
	local local_theme_path = vim.fn.stdpath("config") .. "/lua/themes/" .. theme_name .. ".lua"
	local local_theme_exists = vim.loop.fs_stat(local_theme_path) ~= nil

	-- Try to load local theme first (only if file exists)
	if local_theme_exists then
		local local_theme_ok, local_theme = pcall(require, "themes." .. theme_name)

		if local_theme_ok and type(local_theme) == "table" and local_theme.setup then
			-- Use local theme
			vim.cmd("highlight clear")
			local_theme.setup()
			vim.g.colors_name = theme_name
			vim.notify("Theme: " .. theme_name .. " (local)", vim.log.levels.INFO)
			return
		else
			-- Local theme failed, fall through to plugin
			vim.notify("Local theme failed, using plugin: " .. colorscheme_name, vim.log.levels.WARN)
		end
	end

	-- Use plugin colorscheme - force reload
	vim.cmd("highlight clear")
	
	-- Check if colorscheme is available
	local available_colorschemes = vim.fn.getcompletion("", "color")
	local has_colorscheme = vim.tbl_contains(available_colorschemes, colorscheme_name)
	
	if has_colorscheme then
		vim.cmd("colorscheme " .. colorscheme_name)
		vim.g.colors_name = theme_name
		vim.notify("Theme: " .. colorscheme_name .. " (plugin)", vim.log.levels.INFO)
	else
		-- Colorscheme not loaded, try to load plugin first
		vim.notify("Colorscheme '" .. colorscheme_name .. "' not found, loading plugin...", vim.log.levels.WARN)
		
		-- Try to require the plugin to load it
		local plugin_ok, plugin = pcall(require, colorscheme_name)
		if plugin_ok and type(plugin) == "table" and plugin.setup then
			plugin.setup()
			vim.cmd("colorscheme " .. colorscheme_name)
			vim.g.colors_name = theme_name
			vim.notify("Theme: " .. colorscheme_name .. " (plugin loaded)", vim.log.levels.INFO)
		else
			vim.notify("Failed to load '" .. colorscheme_name .. "', falling back to " .. M.default, vim.log.levels.ERROR)
			vim.cmd("colorscheme " .. (M.theme_map[M.default] or M.default))
			vim.g.colors_name = M.default
		end
	end
end

--- Set theme and apply
function M.set(theme_name)
	M.load(theme_name)
end

return M
