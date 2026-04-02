-- ═══════════════════════════════════════════════════════════════════════════════
-- COLORSCHEMES - Official theme plugins
-- ═══════════════════════════════════════════════════════════════════════════════

return {
	-- ── Gruvbox (Official, Modern) ───────────────────────────────────────────────
	{
		"ellisonleao/gruvbox.nvim",
		lazy = false,
		priority = 1000,
		name = "gruvbox",
		opts = {
			-- Gruvbox configuration
			contrast = "", -- "hard", "soft", or ""
			transparent_background = false,
			terminal_colors = true,
			undercurl = true,
			overrides = {},
		},
	},

	-- ── Catppuccin (Official) ───────────────────────────────────────────────────
	{
		"catppuccin/nvim",
		lazy = false,
		priority = 1000,
		name = "catppuccin",
		opts = {
			-- Catppuccin configuration
			flavour = "mocha", -- "latte", "frappe", "macchiato", "mocha"
			background = {
				light = "latte",
				dark = "mocha",
			},
			transparent_background = false,
			show_end_of_buffer = false,
			term_colors = true,
			dim_inactive = {
				enabled = false,
				shade = "dark",
				percentage = 0.15,
			},
		},
	},

	-- ── Local Theme Manager (symlink-based) ─────────────────────────────────────
	{
		dir = vim.fn.stdpath("config"),
		name = "theme-manager",
		lazy = false,
		priority = 1001,
		config = function()
			require("themes").load()
		end,
	},
}
