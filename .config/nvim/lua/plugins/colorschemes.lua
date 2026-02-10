-- ================================================================================================
-- COLORSCHEMES
-- ================================================================================================

return {
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
