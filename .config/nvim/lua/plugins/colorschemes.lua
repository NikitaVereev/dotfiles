-- ============
-- TITLE: Everforest Colorscheme
-- ABOUT: Warm, forest-themed colorscheme with transparency customization
-- LINKS: https://github.com/sainnhe/everforest
-- ============

return {
	"sainnhe/everforest",
	lazy = false,
	priority = 1000,
	config = function()
		vim.g.everforest_background = "medium"
		vim.g.everforest_better_performance = 1
		vim.g.everforest_transparent_background = 2
		vim.cmd("colorscheme everforest")
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
}
