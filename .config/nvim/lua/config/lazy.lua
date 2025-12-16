-- ============
-- TITLE: Lazy.nvim Bootstrap & Plugin Setup
-- ABOUT: Bootstraps lazy.nvim plugin manager, loads core configs, and initializes plugins
-- LINKS:
--	> lazy.nvim github : https://github.com/folke/lazy.nvim
-- ============

-- Define lazy.nvim installation path
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Check if lazy.nvim exists, if not clone
---@diagnostic disable-next-line: undefined-field (fs_stat)
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none", -- Partial clone for faster download
		"--branch=stable", -- Use stable branch
		lazyrepo,
		lazypath,
	})

	-- Handle close errors
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end

-- Add lazy.nvim to runtime path
vim.opt.rtp:prepend(lazypath)

-- Load core configuration files (must be loaded before plugins)
require("config.globals")
require("config.options")
require("config.keymaps")
require("config.autocmds")
-- require("config.statusline")

-- Define plugins directory
local plugins_dir = "plugins"

-- Initialize lazy.nvim with configuration
require("lazy").setup({
	spec = {
		{ import = plugins_dir }, -- Auto-import all files from lua/plugins/
	},
	rtp = {
		disabled_plugins = {
			"netrw", -- Disable built-in file explorer
			"netrwPlugin", -- Disable netrw plugin
		},
	},
	checker = { enabled = true }, -- Enable automatic plugin update checks
})
