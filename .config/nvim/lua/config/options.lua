-- ============
-- TITLE: Neovim Options
-- ABOUT: Core editor settings and behavior configuration
-- ============

-- Basic Settings
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers for easy jumps (5j, 3k)
vim.opt.cursorline = true -- Highlight current line
vim.opt.scrolloff = 10 -- Keep cursor centered vertically (10 lines padding)
vim.opt.sidescrolloff = 8 -- Keep cursor centered horizontally (8 columns padding)
vim.opt.wrap = false -- Disable line wrapping
vim.opt.cmdheight = 1 -- Command line height
vim.opt.spelllang = { "en", "ru" } -- Spell check languages

-- Tabbing / Indentation
vim.opt.tabstop = 2 -- Tab display width
vim.opt.shiftwidth = 2 -- Indent width for >> and <<
vim.opt.softtabstop = 2 -- Tab key behavior
vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.smartindent = true -- Language-aware auto-indenting
vim.opt.autoindent = true -- Copy indent from previous line
vim.opt.grepprg = "rg --vimgrep" -- Use ripgrep for :grep command
vim.opt.grepformat = "%f:%l:%c:%m" -- Grep output format: file:line:col:message

-- Search Settings
vim.opt.ignorecase = true -- Case-insensitive search by default
vim.opt.smartcase = true -- Case-sensitive in pattern contains uppercase
vim.opt.hlsearch = false -- Don`t highlight search results permanently
vim.opt.incsearch = true -- Show matches while typing

-- Visual Settings
vim.opt.termguicolors = true -- Enable 24-bit colors
vim.opt.signcolumn = "yes" -- Always show sign column (git/LSP/indicators)
vim.opt.colorcolumn = "100" -- Show vertical line at column 100
vim.opt.showmatch = true -- Highlight matching brackets
vim.opt.matchtime = 2 -- Bracket highlight duration (tenths of second)
vim.opt.completeopt = "menuone,noinsert,noselect" -- Completion menu behavior
vim.opt.showmode = false -- Don`t show mode (INSERT/VISUAL) in cmdline
vim.opt.pumheight = 10 -- Max completion menu items
vim.opt.pumblend = 10 -- Completion menu transparency (0-100)
vim.opt.winblend = 0 -- Floating window transparency
vim.opt.conceallevel = 0 -- Don`t hide markup characters (JSON quotes, MD links)
vim.opt.concealcursor = "" -- Show concealed text on cursor line
vim.opt.lazyredraw = false -- Redraw screen during macros (better UX)
vim.opt.redrawtime = 10000 -- Syntax redraw timeout (ms)
vim.opt.maxmempattern = 20000 -- Max memory for pattern matching
vim.opt.synmaxcol = 300 -- Don`t syntax highlight long lines

-- File Handling
vim.opt.backup = false -- Dont create backup files
vim.opt.writebackup = false -- Don`t backup before overwriting
vim.opt.swapfile = false -- Don`t create swap files
vim.opt.undofile = true -- Enable persistent undo history
vim.opt.updatetime = 300 -- CursorHold event delay (affects LSP responsiveness)
vim.opt.timeoutlen = 500 -- Keymap sequence timeout (mc)
vim.opt.ttimeoutlen = 0 -- No delay for key codes
vim.opt.autoread = true -- Auto-reload externally modified files
vim.opt.autowrite = false -- Don`t auto-save on buffer switch
vim.opt.diffopt:append("vertical") -- Vertical diff splits
vim.opt.diffopt:append("algorithm:patience") -- Better diff algorithm
vim.opt.diffopt:append("linematch:60") -- Improved line matching in diffs

-- Undo directory setup (persistent undo across sessions)
local undodir = "~/.local/share/nvim/undodir"
vim.opt.undodir = vim.fn.expand(undodir)
local undodir_path = vim.fn.expand(undodir)
if vim.fn.isdirectory(undodir_path) == 0 then
	vim.fn.mkdir(undodir_path, "p") -- Create directory if midding
end

-- Behavior Settings
vim.opt.errorbells = false -- Disable error sounds
vim.opt.backspace = "indent,eol,start" -- Backspace over everything in insert mode
vim.opt.autochdir = false -- Don`t change working directory automatically
vim.opt.iskeyword:append("-") -- Treat kebab-case as one word
vim.opt.path:append("**") -- Recursive file search with gf
vim.opt.selection = "inclusive" -- Include last character in selection
vim.opt.mouse = "a" -- Enable mouse in all modes
vim.opt.clipboard:append("unnamedplus") -- Sync with system clipboard
vim.opt.modifiable = true -- Allow buffer modifications
vim.opt.encoding = "UTF-8" -- Use UTF-8 encoding
vim.opt.wildmenu = true -- Enhanced command-line completion
vim.opt.wildmode = "longest:full,full" -- Completion behavior
vim.opt.wildignorecase = true -- Case-insensitive command completion

-- Cursor Settings
vim.opt.guicursor = {
	"n-v-c-sm:block", -- Block cursor in normal/visual/command modes
	"i-ci-ve:block", -- Block cursor in insert mode
	"r-cr:hor20", -- Horizontal bar in replace mode (20% height)
	"o:hor50", -- Horizontal bar in operator-pending (50% height)
	"a:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor", -- Blinking settings
	"sm:block-blinkwait175-blinkoff150-blinkon175", -- Showmatch cursor
}

-- Folding Settings (Treesitter-based)
vim.opt.foldmethod = "expr" -- Use expression for folding
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()" -- Treesitter fold expression
vim.opt.foldlevel = 99 -- All folds open by default

-- Split Behavior
vim.opt.splitbelow = true -- Horizontal splits open below
vim.opt.splitright = true -- Vertical splits open to the right

-- Disable Built-in Plugins (use modern alternatives)
vim.g.loaded_netrw = 1 -- Disable netrw file explorer
vim.g.loaded_netrwPlugin = 1 -- Disable netrw plugin

-- Filetype Detection (custom patterns)
vim.filetype.add({
	extension = { env = "dotenv" },
	filename = { [".env"] = "dotenv", ["env"] = "dotenv" },
	pattern = {
		["[jt]sconfig.*.json"] = "jsonc", -- TypeScript/JavaScript config as JSONC
		["%.env%.[%w_.-]+"] = "dotenv", -- .env.* files as dotenv
	},
})
