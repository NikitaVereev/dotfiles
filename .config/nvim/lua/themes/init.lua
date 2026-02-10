local M = {}

M.default = "everforest"

function M.get_current()
	local theme_file = vim.fn.stdpath("config") .. "/themes/current"
	if vim.fn.filereadable(theme_file) == 1 then
		local content = vim.fn.readfile(theme_file)
		if content and content[1] then
			return vim.trim(content[1])
		end
	end
	return M.default
end

function M.load(theme_name)
	theme_name = theme_name or M.get_current()

	-- Clear module cache so SIGUSR1 reload picks up changes
	package.loaded["themes." .. theme_name] = nil

	local ok, theme = pcall(require, "themes." .. theme_name)
	if not ok or not theme.setup then
		vim.notify("Theme '" .. theme_name .. "' not found, falling back to " .. M.default, vim.log.levels.WARN)
		package.loaded["themes." .. M.default] = nil
		theme = require("themes." .. M.default)
	end

	vim.cmd("highlight clear")
	theme.setup()
end

return M
