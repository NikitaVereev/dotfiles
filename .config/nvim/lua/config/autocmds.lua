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
		vim.hl.on_yank()
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

-- Enable spell checking for certain file types
api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.txt", "*.md", "*.tex" },
	callback = function()
		vim.opt.spell = true
		vim.opt.spelllang = "en"
	end,
})

-- close some filetypes with <q>
api.nvim_create_autocmd("FileType", {
	group = api.nvim_create_augroup("close_with_q", { clear = true }),
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

-- Resize neovim split when terminal is resized
api.nvim_create_autocmd("VimResized", {
	callback = function()
		vim.cmd("wincmd =")
	end,
})

-- Fix terraform and hcl comment string
api.nvim_create_autocmd("FileType", {
	group = api.nvim_create_augroup("FixTerraformCommentString", { clear = true }),
	pattern = { "terraform", "hcl" },
	callback = function(ev)
		vim.bo[ev.buf].commentstring = "# %s"
	end,
})

-- Check for external file changes (works with Claude Code)
api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, { -- CursorHold
	callback = function()
		if vim.fn.mode() ~= "c" then
			vim.cmd("checktime")
		end
	end,
})

-- Switch system theme
vim.api.nvim_create_autocmd("Signal", {
	pattern = "SIGUSR1",
	callback = function()
		vim.schedule(function()
			require("themes").load()
		end)
	end,
	group = vim.api.nvim_create_augroup("ThemeSignal", { clear = true }),
})
