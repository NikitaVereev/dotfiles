-- ============
-- TITLE: Keymaps
-- ABOUT: Custom keybindings for navigation, editing, and window management
-- ============

local opts = { noremap = true, silent = true }

-- Move lines up/down in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", opts)
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", opts)

-- Quick save/quit (commented out, likely using Snacks bufdelete instead)
-- vim.keymap.set("n", "<leader>w", ":write!<CR>", { silent = true, desc = "Save file" })
-- vim.keymap.set("n", "<leader>q", ":q!<CR>", opts)

-- Navigate wrapped lines naturally (j/k move by visual line, not actual line)
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- Indent without losing visual selection (commented out)
-- vim.keymap.set("v", "<", "<gv")
-- vim.keymap.set("v", ">", ">gv")

-- Paste without yanking deleted text (replace without overwriting clipboard)
vim.keymap.set("v", "p", '"_dp')
vim.keymap.set("v", "P", '"_dP')

-- Yank inner curly braces block
-- p pastes after cursor, P pastes before cursor
vim.keymap.set("n", "YY", "va{Vy", opts)

-- Exit insert mode with double key press
vim.keymap.set("i", "jj", "<ESC>", opts)
vim.keymap.set("i", "jk", "<ESC>", opts)

-- Jump to start/end of line (H = start, L = end)
vim.keymap.set({ "n", "x", "o" }, "H", "^", opts)
vim.keymap.set({ "n", "x", "o" }, "L", "g_", opts)

-- Buffer navigation
vim.keymap.set("n", "<leader>bn", "<Cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", "<Cmd>bprevious<CR>", { desc = "Previous buffer" })

-- Resize windows with arrow keys
vim.keymap.set("n", "<C-Up>", "<Cmd>resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", "<Cmd>resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", "<Cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", "<Cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- Navigate between windows (Ctrl+hjkl like tmux)
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Center cursor on jumps/search
vim.keymap.set("n", "n", "nzzzv", { desc = "Next search result (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous search result (centered)" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

-- Split windows
vim.keymap.set("n", "<leader>sv", "<Cmd>vsplit<CR>", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", "<Cmd>split<CR>", { desc = "Split window horizontally" })

-- NOTE: Duplicate resize bindings (already defined above)
vim.keymap.set("n", "<C-Up>", "<Cmd>resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", "<Cmd>resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", "<Cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", "<Cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- Split line at cursor (keeps indentation)
vim.keymap.set("n", "X", ":keeppatterns substitute/\\s*\\%#\\s*/\\r/e <bar> normal! ==^<cr>", { silent = true })

-- Cut line (delete line into clipboard)
vim.keymap.set("n", "<C-x>", "dd", opts)

-- Select all
vim.keymap.set("n", "<C-a>", "ggVG", opts)

-- Create new file in current directory
vim.keymap.set("n", "<C-n>", ":w %:h/", opts)

-- Toggle Go test file (switches between _test.go and .go)
vim.keymap.set("n", "<C-P>", ':lua require("config.utils").toggle_go_test()<CR>', opts)

-- Get line numbers of visual selection (custom utility function)
vim.keymap.set("v", "<leader>ln", ':lua require("config.utils").get_highlighted_line_numbers()<CR>', opts)

-- Clear search highlight
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", opts)
