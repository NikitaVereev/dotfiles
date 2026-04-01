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

--- Get current theme name from vim.g.colors_name or file
function M.get_current()
	-- First, try to get from vim.g.colors_name (set by theme-manager.py)
	if vim.g.colors_name then
		return vim.g.colors_name:lower()
	end

	-- Second, try to read from current_theme file (set by theme-manager.py)
	local theme_file = vim.fn.stdpath("config") .. "/themes/current_theme"
	if vim.fn.filereadable(theme_file) == 1 then
		local content = vim.fn.readfile(theme_file)
		if content and #content > 0 then
			return vim.trim(content[1]):lower()
		end
	end

	-- Final fallback: default
	return M.default
end

--- Load theme by name
function M.load(theme_name)
	theme_name = theme_name or M.get_current()

	-- Map theme name to colorscheme name
	local colorscheme_name = M.theme_map[theme_name] or theme_name

	-- Clear module cache for local themes
	package.loaded["themes." .. theme_name] = nil

	-- Try to load local theme first
	local local_theme_ok, local_theme = pcall(require, "themes." .. theme_name)

	if local_theme_ok and local_theme.setup then
		-- Use local theme
		vim.cmd("highlight clear")
		local_theme.setup()
		vim.g.colors_name = theme_name
	else
		-- Use plugin colorscheme
		local ok = pcall(vim.cmd, "colorscheme " .. colorscheme_name)
		if not ok then
			vim.notify("Theme '" .. theme_name .. "' not found, falling back to " .. M.default, vim.log.levels.WARN)
			vim.cmd("colorscheme " .. (M.theme_map[M.default] or M.default))
		end
		vim.g.colors_name = theme_name
	end
end

--- Set theme and apply
function M.set(theme_name)
	M.load(theme_name)
end

return M
