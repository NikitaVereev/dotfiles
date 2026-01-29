-- ============
-- TITLE: Autocommands
-- ABOUT: Event-driven automation (format behavior, cursor position ,higlights, etc.)
-- ============

local api = vim.api

-- Disable automatic comment continuation on new line
api.nvim_create_autocmd("BufEnter", {
	command = [[set formatoptions-=cro]],
})

-- Soft wrap for email buffers
api.nvim_create_autocmd("Filetype", {
	pattern = "mail",
	callback = function()
		vim.opt.textwidth = 0
		vim.opt.wrapmargin = 0
		vim.opt.wrap = true
		vim.opt.linebreak = true
		vim.opt.columns = 80
		vim.opt.colorcolumn = "80"
	end,
})

-- Highlight yanked text briefly
api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Restore cursor position on file open
api.nvim_create_autocmd("BufReadPost", {
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- Close man pages with 'q'
api.nvim_create_autocmd("FileType", {
	pattern = "man",
	command = [[nnoremap <buffer><silent> q :quit<CR>]],
})

-- Show cursorline only in active window
local cursorGrp = api.nvim_create_augroup("CursorLine", { clear = true })
api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
	pattern = "*",
	command = "set cursorline",
	group = cursorGrp,
})
api.nvim_create_autocmd(
	{ "InsertEnter", "WinLeave" },
	{ pattern = "*", command = "set nocursorline", group = cursorGrp }
)

-- Enable spell checking for text files
api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.txt", "*.md", "*.tex" },
	callback = function()
		vim.opt.spell = true
		vim.opt.spelllang = "en"
	end,
})

-- Close special buffers with 'q'
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("close_with_q", { clear = true }),
	pattern = {
		"PlenaryTestPopup",
		"help",
		"lspinfo",
		"man",
		"notify",
		"qf",
		"spectre_panel",
		"startuptime",
		"tsplayground",
		"neotest-output",
		"checkhealth",
		"neotest-summary",
		"neotest-output-panel",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})

-- Auto-resize splits on window resize
vim.api.nvim_command("autocmd VimResized * wincmd =")

-- Fix comment string for Terraform/HCL
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("FixTerraformCommentString", { clear = true }),
	callback = function(ev)
		vim.bo[ev.buf].commentstring = "# %s"
	end,
	pattern = { "terraform", "hcl" },
})

-- Auto-start Treesitter for all filetypes
vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		pcall(vim.treesitter.start)
	end,
})

-- Auto-reload externally modified files
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
	command = "if mode() != 'c' | checktime | endif",
	pattern = "*",
})

-- Switch system theme
vim.api.nvim_create_autocmd("Signal", {
	pattern = "SIGUSR1",
	callback = function()
		local theme_file = vim.fn.stdpath("config") .. "/themes/current"
		local theme = "everforest"

		if vim.fn.filereadable(theme_file) == 1 then
			theme = vim.trim(vim.fn.readfile(theme_file)[1] or "everforest")
		end

		vim.schedule(function()
			vim.cmd("silent! colorscheme default")

			if theme == "everforest" then
				vim.g.everforest_background = "medium"
				vim.g.everforest_better_performance = 1
				vim.cmd("colorscheme everforest")
			elseif theme == "bloodmoon" then
				vim.cmd("colorscheme tokyonight-storm")
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
		end)
	end,
	group = vim.api.nvim_create_augroup("ThemeSignal", { clear = true }),
})
