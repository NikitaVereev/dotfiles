-- ============
-- TITLE : nvim-treesitter
-- ABOUT : Treesitter configurations and abstraction layer for Neovim.
-- LINKS :
--   > github : https://github.com/nvim-treesitter/nvim-treesitter
-- ============

return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = { "BufReadPost", "BufNewFile" },
	lazy = false,
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"bash", "c", "cpp", "css", "dockerfile", "go",
				"html", "javascript", "json", "lua", "markdown",
				"markdown_inline", "python", "rust", "svelte",
				"tsx", "typescript", "vue", "yaml",
			},
			auto_install = true,
			sync_install = false,
			highlight = { enable = true },
			indent = { enable = true },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<CR>",
					node_incremental = "<CR>",
					scope_incremental = "<TAB>",
					node_decremental = "<S-TAB>",
				},
			},
		})
	end,
}

