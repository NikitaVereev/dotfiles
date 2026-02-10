-- ================================================================================================
-- COLORSCHEMES
-- ================================================================================================

return {
	{ "sainnhe/everforest", priority = 1000 },
	{ "catppuccin/nvim", priority = 1000 },

	{
		dir = vim.fn.stdpath("config"),
		name = "theme-manager",
		lazy = false,
		priority = 1001,
		config = function()
			local theme_file = vim.fn.stdpath("config") .. "/themes/current"
			local theme = "everforest"

			if vim.fn.filereadable(theme_file) == 1 then
				theme = vim.trim(vim.fn.readfile(theme_file)[1] or "everforest")
			end

			if theme == "everforest" then
				vim.g.everforest_background = "medium"
				vim.g.everforest_better_performance = 1
				vim.g.everforest_transparent_background = 2
				vim.cmd.colorscheme("everforest")
			elseif theme == "bloodmoon" then
				require("themes.bloodmoon").setup()
			elseif theme == "catppuccin" then
				vim.cmd.colorscheme("catppuccin-mocha")
			end

			vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
			vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
			vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
			vim.api.nvim_set_hl(0, "SignColumn", { bg = "NONE" })
			vim.api.nvim_set_hl(0, "StatusLine", { bg = "NONE" })
			vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "NONE" })
			vim.api.nvim_set_hl(0, "SnacksPickerGitStatusUntracked", {
				fg = "#D3C6AA",
				bg = "NONE",
			})
			vim.api.nvim_set_hl(0, "NonText", {
				fg = "#D3C6AA",
			})
		end,
	},
}
