-- ============
-- TITLE: LazyDev.nvim Configuration
-- ABOUT: Enhanced Lua development for Neovim config files (autocomplete, docs, types)
-- LINKS: https://github.com/folke/lazydev.nvim
-- ============

return {
	"folke/lazydev.nvim",
	ft = "lua", -- only load on lua files
	opts = {
		library = {
			-- See the configuration section for more details
			-- Load luvit types when the `vim.uv` word is found
			{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
		},
	},
}
