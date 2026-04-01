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
