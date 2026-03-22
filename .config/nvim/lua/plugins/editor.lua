-- Editor: Navigation, text objects, pairs, statusline, and utilities
return {
	-- ════════════════════════════════════════════════════════════════════════════
	-- Flash (quick navigation)
	-- ════════════════════════════════════════════════════════════════════════════
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		---@type Flash.Config
		opts = {},
    -- stylua: ignore
    keys = {
      { "s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
      { "S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
      { "r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
      { "R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
	},

	-- ════════════════════════════════════════════════════════════════════════════
	-- Mini.nvim (text objects, surround, pairs, statusline, icons)
	-- ════════════════════════════════════════════════════════════════════════════
	{
		"echasnovski/mini.nvim",
		config = function()
			-- Better Around/Inside textobjects
			-- Examples:
			--  - va)  - [V]isually select [A]round [)]paren
			--  - yinq - [Y]ank [I]nside [N]ext [']quote
			--  - ci'  - [C]hange [I]nside [']quote
			require("mini.ai").setup({ n_lines = 500 })

			-- Add/delete/replace surroundings (brackets, quotes, etc.)
			-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
			-- - sd'   - [S]urround [D]elete [']quotes
			-- - sr)'  - [S]urround [R]eplace [)] [']
			require("mini.surround").setup()

			require("mini.pairs").setup()

			local statusline = require("mini.statusline")
			statusline.setup({
				use_icons = vim.g.have_nerd_font,
				set_vim_settings = false,
			})
			---@diagnostic disable-next-line: duplicate-set-field
			statusline.section_location = function()
				return "%2l:%-2v"
			end
		end,
	},

	{
		"echasnovski/mini.icons",
		enabled = true,
		lazy = false,
		priority = 1000,
		opts = {
			style = "glyph",
		},
	},

	-- ════════════════════════════════════════════════════════════════════════════
	-- Persistence (session management)
	-- ════════════════════════════════════════════════════════════════════════════
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = {},
	},

	-- ════════════════════════════════════════════════════════════════════════════
	-- Which-key (keybinding popup)
	-- ════════════════════════════════════════════════════════════════════════════
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			plugins = { spelling = true },
			spec = {
				{ "<leader>c", group = "code", mode = { "n", "v" } },
				{ "<leader>l", group = "lsp" },
				{ "<leader>b", group = "buffer" },
				{ "<leader>f", group = "file/find" },
				{ "<leader>g", group = "git" },
				{ "<leader>q", group = "quit" },
			},
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Keymaps",
			},
		},
	},

	-- ════════════════════════════════════════════════════════════════════════════
	-- Todo-comments (highlight TODO, FIXME, etc.)
	-- ════════════════════════════════════════════════════════════════════════════
	{
		"folke/todo-comments.nvim",
		event = "BufReadPre",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			signs = false,
			sign_priority = 8,
			keywords = {
				FIX = { icon = " ", color = "error", alt = { "FIXME", "BUG", "FIXIT" } },
				TODO = { icon = "󰗡 ", color = "info" },
				HACK = { icon = " ", color = "warning" },
				WARN = { icon = " ", color = "warning", alt = { "WARNING" } },
				PERF = { icon = "󰅒 ", color = "default", alt = { "PERFORMANCE" } },
				NOTE = { icon = "󰍨 ", color = "hint", alt = { "INFO" } },
			},
		},
		keys = {
			{ "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo" },
			{ "[t", function() require("todo-comments").jump_prev() end, desc = "Prev Todo" },
			{ "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
			{ "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
			{ "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo (Telescope)" },
		},
	},
}
