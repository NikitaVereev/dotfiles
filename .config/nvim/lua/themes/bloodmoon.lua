-- ═══════════════════════════════════════════════════════════════════════════
-- BLOODMOON THEME FOR NEOVIM
-- Полная цветовая схема с поддержкой всех highlight groups
-- ═══════════════════════════════════════════════════════════════════════════

local M = {}

-- ═══════════════════════════════════════════════════════════════════════════
-- COLOR PALETTE
-- ═══════════════════════════════════════════════════════════════════════════

M.colors = {
	-- Backgrounds
	bg0 = "#0D0A0A", -- Deepest background
	bg1 = "#1A0D0D", -- Main background
	bg2 = "#2A1818", -- Secondary background
	bg3 = "#3A2828", -- Tertiary background
	bg4 = "#4A3838", -- Highlight background

	-- Foregrounds
	fg = "#FFEBEE", -- Main foreground
	fg_dim = "#FFB3B3", -- Dimmed foreground
	fg_bright = "#FFF5F5", -- Bright foreground
	fg_muted = "#CC9999", -- Muted foreground

	-- Primary accents
	red = "#DC143C", -- Crimson
	red_bright = "#FF1744", -- Bright red
	red_dim = "#B71C1C", -- Dark red

	orange = "#FF4500", -- OrangeRed
	orange_bright = "#FF6F00", -- Bright orange
	orange_dim = "#E64A19", -- Dark orange

	pink = "#FF69B4", -- HotPink
	pink_bright = "#FF80AB", -- Bright pink
	pink_dim = "#F50057", -- Dark pink

	-- Additional colors
	yellow = "#FFA726", -- Warm yellow
	gold = "#FFB74D", -- Gold

	purple = "#AB47BC", -- Purple
	magenta = "#E91E63", -- Magenta

	-- Neutral accents
	gray0 = "#666666",
	gray1 = "#808080",
	gray2 = "#999999",
	gray3 = "#B0B0B0",

	-- Semantic colors
	success = "#66BB6A", -- Green
	warning = "#FFA726", -- Yellow
	error = "#DC143C", -- Red
	info = "#AB47BC", -- Purple

	-- UI elements
	cursor = "#FF4500",
	cursor_bg = "#0D0A0A",
	line = "#2A1818",
	visual = "#3A2828",
	selection = "#4A3838",

	border = "#DC143C",
	border_dim = "#B71C1C",

	-- Syntax
	comment = "#CC9999",
	constant = "#FF69B4",
	string = "#FFA726",
	func = "#FF4500",
	keyword = "#DC143C",
	variable = "#FFEBEE",
	type = "#AB47BC",
	operator = "#FF6F00",
	number = "#FF80AB",

	-- Git
	git_add = "#66BB6A",
	git_change = "#FFA726",
	git_delete = "#DC143C",
	git_conflict = "#E91E63",

	-- Diagnostics
	diagnostic_error = "#DC143C",
	diagnostic_warn = "#FFA726",
	diagnostic_info = "#AB47BC",
	diagnostic_hint = "#66BB6A",

	-- Special
	none = "NONE",
}

-- ═══════════════════════════════════════════════════════════════════════════
-- HIGHLIGHT GROUPS
-- ═══════════════════════════════════════════════════════════════════════════

function M.setup()
	local c = M.colors

	local highlights = {
		-- ═══════════════════════════════════════════════════════════════════
		-- EDITOR
		-- ═══════════════════════════════════════════════════════════════════
		Normal = { fg = c.fg, bg = c.none },
		NormalFloat = { fg = c.fg, bg = c.none },
		NormalNC = { fg = c.fg, bg = c.none },

		-- Cursor
		Cursor = { fg = c.cursor_bg, bg = c.cursor },
		CursorLine = { bg = c.line },
		CursorColumn = { bg = c.line },
		ColorColumn = { bg = c.bg2 },

		-- Line numbers
		LineNr = { fg = c.gray1 },
		CursorLineNr = { fg = c.orange, bold = true },
		SignColumn = { fg = c.gray1, bg = c.none },

		-- Visual mode
		Visual = { bg = c.visual },
		VisualNOS = { bg = c.visual },

		-- Search
		Search = { fg = c.bg0, bg = c.yellow },
		IncSearch = { fg = c.bg0, bg = c.orange },
		CurSearch = { fg = c.bg0, bg = c.red },

		-- Popup menu
		Pmenu = { fg = c.fg, bg = c.bg2 },
		PmenuSel = { fg = c.fg_bright, bg = c.bg3, bold = true },
		PmenuSbar = { bg = c.bg3 },
		PmenuThumb = { bg = c.orange },

		-- Statusline
		StatusLine = { fg = c.fg, bg = c.none },
		StatusLineNC = { fg = c.gray1, bg = c.none },

		-- Tabline
		TabLine = { fg = c.gray2, bg = c.bg2 },
		TabLineSel = { fg = c.fg_bright, bg = c.bg3, bold = true },
		TabLineFill = { bg = c.bg1 },

		-- Windows
		VertSplit = { fg = c.border_dim },
		WinSeparator = { fg = c.border_dim },
		FloatBorder = { fg = c.border, bg = c.bg2 },

		-- Folds
		Folded = { fg = c.gray2, bg = c.bg2 },
		FoldColumn = { fg = c.gray1, bg = c.bg1 },

		-- Diff
		DiffAdd = { fg = c.git_add, bg = c.bg2 },
		DiffChange = { fg = c.git_change, bg = c.bg2 },
		DiffDelete = { fg = c.git_delete, bg = c.bg2 },
		DiffText = { fg = c.fg_bright, bg = c.bg3, bold = true },

		-- Spell
		SpellBad = { sp = c.error, undercurl = true },
		SpellCap = { sp = c.warning, undercurl = true },
		SpellLocal = { sp = c.info, undercurl = true },
		SpellRare = { sp = c.purple, undercurl = true },

		-- Messages
		ErrorMsg = { fg = c.error, bold = true },
		WarningMsg = { fg = c.warning, bold = true },
		ModeMsg = { fg = c.orange, bold = true },
		MoreMsg = { fg = c.success, bold = true },
		Question = { fg = c.purple },

		-- Misc
		NonText = { fg = c.fg },
		SnacksPickerGitStatusUntracked = { fg = c.fg, bg = c.none },

		-- ═══════════════════════════════════════════════════════════════════
		-- SYNTAX
		-- ═══════════════════════════════════════════════════════════════════
		Comment = { fg = c.comment, italic = true },

		Constant = { fg = c.constant },
		String = { fg = c.string },
		Character = { fg = c.string },
		Number = { fg = c.number },
		Boolean = { fg = c.constant },
		Float = { fg = c.number },

		Identifier = { fg = c.variable },
		Function = { fg = c.func, bold = true },

		Statement = { fg = c.keyword, bold = true },
		Conditional = { fg = c.keyword },
		Repeat = { fg = c.keyword },
		Label = { fg = c.keyword },
		Operator = { fg = c.operator },
		Keyword = { fg = c.keyword },
		Exception = { fg = c.red_bright },

		PreProc = { fg = c.purple },
		Include = { fg = c.purple },
		Define = { fg = c.purple },
		Macro = { fg = c.purple },
		PreCondit = { fg = c.purple },

		Type = { fg = c.type },
		StorageClass = { fg = c.keyword },
		Structure = { fg = c.type },
		Typedef = { fg = c.type },

		Special = { fg = c.orange_bright },
		SpecialChar = { fg = c.pink },
		Tag = { fg = c.orange },
		Delimiter = { fg = c.fg_dim },
		SpecialComment = { fg = c.pink, italic = true },
		Debug = { fg = c.red_bright },

		Underlined = { underline = true },
		Ignore = { fg = c.gray1 },
		Error = { fg = c.error, bold = true },
		Todo = { fg = c.yellow, bg = c.bg3, bold = true },

		-- ═══════════════════════════════════════════════════════════════════
		-- LSP
		-- ═══════════════════════════════════════════════════════════════════
		-- Diagnostics
		DiagnosticError = { fg = c.diagnostic_error },
		DiagnosticWarn = { fg = c.diagnostic_warn },
		DiagnosticInfo = { fg = c.diagnostic_info },
		DiagnosticHint = { fg = c.diagnostic_hint },

		DiagnosticUnderlineError = { sp = c.diagnostic_error, undercurl = true },
		DiagnosticUnderlineWarn = { sp = c.diagnostic_warn, undercurl = true },
		DiagnosticUnderlineInfo = { sp = c.diagnostic_info, undercurl = true },
		DiagnosticUnderlineHint = { sp = c.diagnostic_hint, undercurl = true },

		-- LSP Semantic
		["@lsp.type.class"] = { fg = c.type },
		["@lsp.type.decorator"] = { fg = c.purple },
		["@lsp.type.enum"] = { fg = c.type },
		["@lsp.type.enumMember"] = { fg = c.constant },
		["@lsp.type.function"] = { fg = c.func, bold = true },
		["@lsp.type.interface"] = { fg = c.type },
		["@lsp.type.macro"] = { fg = c.purple },
		["@lsp.type.method"] = { fg = c.func },
		["@lsp.type.namespace"] = { fg = c.type },
		["@lsp.type.parameter"] = { fg = c.variable },
		["@lsp.type.property"] = { fg = c.variable },
		["@lsp.type.struct"] = { fg = c.type },
		["@lsp.type.type"] = { fg = c.type },
		["@lsp.type.typeParameter"] = { fg = c.type },
		["@lsp.type.variable"] = { fg = c.variable },

		-- ═══════════════════════════════════════════════════════════════════
		-- TREESITTER
		-- ═══════════════════════════════════════════════════════════════════
		["@variable"] = { fg = c.variable },
		["@variable.builtin"] = { fg = c.pink },
		["@variable.parameter"] = { fg = c.variable },
		["@variable.member"] = { fg = c.variable },

		["@constant"] = { fg = c.constant },
		["@constant.builtin"] = { fg = c.constant },
		["@constant.macro"] = { fg = c.purple },

		["@string"] = { fg = c.string },
		["@string.escape"] = { fg = c.pink },
		["@string.regexp"] = { fg = c.pink },

		["@character"] = { fg = c.string },
		["@number"] = { fg = c.number },
		["@boolean"] = { fg = c.constant },
		["@float"] = { fg = c.number },

		["@function"] = { fg = c.func, bold = true },
		["@function.builtin"] = { fg = c.func },
		["@function.macro"] = { fg = c.purple },
		["@function.call"] = { fg = c.func },
		["@method"] = { fg = c.func },
		["@method.call"] = { fg = c.func },
		["@constructor"] = { fg = c.type },

		["@keyword"] = { fg = c.keyword, bold = true },
		["@keyword.function"] = { fg = c.keyword },
		["@keyword.operator"] = { fg = c.operator },
		["@keyword.return"] = { fg = c.keyword },
		["@keyword.conditional"] = { fg = c.keyword },
		["@keyword.repeat"] = { fg = c.keyword },
		["@keyword.exception"] = { fg = c.red_bright },

		["@operator"] = { fg = c.operator },
		["@type"] = { fg = c.type },
		["@type.builtin"] = { fg = c.type },
		["@type.definition"] = { fg = c.type },

		["@punctuation.delimiter"] = { fg = c.fg_dim },
		["@punctuation.bracket"] = { fg = c.fg_dim },
		["@punctuation.special"] = { fg = c.orange_bright },

		["@comment"] = { fg = c.comment, italic = true },
		["@comment.todo"] = { fg = c.yellow, bg = c.bg3, bold = true },
		["@comment.warning"] = { fg = c.warning, bold = true },
		["@comment.note"] = { fg = c.info, bold = true },
		["@comment.error"] = { fg = c.error, bold = true },

		["@tag"] = { fg = c.orange },
		["@tag.attribute"] = { fg = c.purple },
		["@tag.delimiter"] = { fg = c.fg_dim },

		-- ═══════════════════════════════════════════════════════════════════
		-- GIT
		-- ═══════════════════════════════════════════════════════════════════
		GitSignsAdd = { fg = c.git_add },
		GitSignsChange = { fg = c.git_change },
		GitSignsDelete = { fg = c.git_delete },

		-- ═══════════════════════════════════════════════════════════════════
		-- PLUGINS
		-- ═══════════════════════════════════════════════════════════════════

		TelescopeBorder = { fg = c.border },
		TelescopePromptBorder = { fg = c.orange },
		TelescopeResultsBorder = { fg = c.border_dim },
		TelescopePreviewBorder = { fg = c.border_dim },
		TelescopeSelection = { fg = c.fg_bright, bg = c.bg3, bold = true },
		TelescopeMatching = { fg = c.orange, bold = true },

		-- NeoTree / nvim-tree
		NeoTreeNormal = { fg = c.fg, bg = c.bg0 },
		NeoTreeNormalNC = { fg = c.fg, bg = c.bg0 },
		NeoTreeRootName = { fg = c.orange, bold = true },
		NeoTreeFileName = { fg = c.fg },
		NeoTreeFileNameOpened = { fg = c.orange },
		NeoTreeGitAdded = { fg = c.git_add },
		NeoTreeGitModified = { fg = c.git_change },
		NeoTreeGitDeleted = { fg = c.git_delete },
		NeoTreeGitConflict = { fg = c.git_conflict },
		NeoTreeIndentMarker = { fg = c.gray1 },

		-- Which-key
		WhichKey = { fg = c.orange },
		WhichKeyGroup = { fg = c.purple },
		WhichKeyDesc = { fg = c.fg },
		WhichKeySeparator = { fg = c.gray1 },
		WhichKeyFloat = { bg = c.bg2 },

		-- Cmp (completion)
		CmpItemAbbrMatch = { fg = c.orange, bold = true },
		CmpItemAbbrMatchFuzzy = { fg = c.orange },
		CmpItemKindFunction = { fg = c.func },
		CmpItemKindMethod = { fg = c.func },
		CmpItemKindVariable = { fg = c.variable },
		CmpItemKindKeyword = { fg = c.keyword },
		CmpItemKindText = { fg = c.fg },
		CmpItemKindClass = { fg = c.type },
		CmpItemKindInterface = { fg = c.type },

		-- Indent Blankline
		IndentBlanklineChar = { fg = c.bg3 },
		IndentBlanklineContextChar = { fg = c.orange },

		-- Dashboard
		DashboardHeader = { fg = c.red },
		DashboardCenter = { fg = c.orange },
		DashboardShortCut = { fg = c.purple },
		DashboardFooter = { fg = c.pink, italic = true },

		-- Notify
		NotifyBackground = { bg = c.bg1 },
		NotifyERRORBorder = { fg = c.error },
		NotifyWARNBorder = { fg = c.warning },
		NotifyINFOBorder = { fg = c.info },
		NotifyDEBUGBorder = { fg = c.purple },
		NotifyTRACEBorder = { fg = c.pink },

		-- Flash
		FlashLabel = { fg = c.bg0, bg = c.orange, bold = true },
		FlashMatch = { fg = c.orange },
		FlashCurrent = { fg = c.red, bold = true },

		-- Snacks
		SnacksNotifierBorderInfo = { fg = c.info },
		SnacksNotifierBorderWarn = { fg = c.warning },
		SnacksNotifierBorderError = { fg = c.error },
		SnacksNotifierBorderDebug = { fg = c.purple },
		SnacksNotifierBorderTrace = { fg = c.pink },
	}

	-- Apply highlights
	for group, settings in pairs(highlights) do
		vim.api.nvim_set_hl(0, group, settings)
	end
end

return M
