-- ═══════════════════════════════════════════════════════════════════════════
-- EVERFOREST THEME FOR NEOVIM
-- Dark medium variant — official palette
-- ═══════════════════════════════════════════════════════════════════════════

local M = {}

-- ═══════════════════════════════════════════════════════════════════════════
-- COLOR PALETTE
-- ═══════════════════════════════════════════════════════════════════════════

M.colors = {
	-- Backgrounds
	bg0 = "#232A2E", -- bg_dim
	bg1 = "#2D353B", -- bg0
	bg2 = "#343F44", -- bg1
	bg3 = "#3D484D", -- bg2
	bg4 = "#475258", -- bg3

	-- Foregrounds
	fg = "#D3C6AA",
	fg_dim = "#859289", -- grey1
	fg_bright = "#D3C6AA",
	fg_muted = "#7A8478", -- grey0

	-- Primary accents
	red = "#E67E80",
	red_bright = "#E67E80",
	red_dim = "#514045", -- bg_red

	orange = "#E69875",
	orange_bright = "#E69875",
	orange_dim = "#E69875",

	pink = "#D699B6",
	pink_bright = "#D699B6",
	pink_dim = "#D699B6",

	-- Additional colors
	yellow = "#DBBC7F",
	gold = "#DBBC7F",

	green = "#A7C080",
	aqua = "#83C092",
	blue = "#7FBBB3",

	purple = "#D699B6",
	magenta = "#D699B6",

	-- Neutral accents
	gray0 = "#7A8478", -- grey0
	gray1 = "#859289", -- grey1
	gray2 = "#9DA9A0", -- grey2
	gray3 = "#9DA9A0",

	-- Semantic colors
	success = "#A7C080",
	warning = "#DBBC7F",
	error = "#E67E80",
	info = "#7FBBB3",

	-- UI elements
	cursor = "#A7C080",
	cursor_bg = "#2D353B",
	line = "#343F44",
	visual = "#543A48", -- bg_visual
	selection = "#475258",

	border = "#859289",
	border_dim = "#7A8478",

	-- Syntax
	comment = "#859289",
	constant = "#D699B6",
	string = "#A7C080",
	func = "#A7C080",
	keyword = "#E67E80",
	variable = "#D3C6AA",
	type = "#7FBBB3",
	operator = "#E69875",
	number = "#D699B6",

	-- Git
	git_add = "#A7C080",
	git_change = "#7FBBB3",
	git_delete = "#E67E80",
	git_conflict = "#E69875",

	-- Diagnostics
	diagnostic_error = "#E67E80",
	diagnostic_warn = "#DBBC7F",
	diagnostic_info = "#7FBBB3",
	diagnostic_hint = "#A7C080",

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
		CursorLineNr = { fg = c.yellow, bold = true },
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
		PmenuThumb = { bg = c.green },

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
		ModeMsg = { fg = c.green, bold = true },
		MoreMsg = { fg = c.success, bold = true },
		Question = { fg = c.blue },

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
		["@variable.builtin"] = { fg = c.blue },
		["@variable.parameter"] = { fg = c.variable },
		["@variable.member"] = { fg = c.variable },

		["@constant"] = { fg = c.constant },
		["@constant.builtin"] = { fg = c.constant },
		["@constant.macro"] = { fg = c.purple },

		["@string"] = { fg = c.string },
		["@string.escape"] = { fg = c.orange },
		["@string.regexp"] = { fg = c.orange },

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

		-- Telescope
		TelescopeBorder = { fg = c.border },
		TelescopePromptBorder = { fg = c.green },
		TelescopeResultsBorder = { fg = c.border_dim },
		TelescopePreviewBorder = { fg = c.border_dim },
		TelescopeSelection = { fg = c.fg_bright, bg = c.bg3, bold = true },
		TelescopeMatching = { fg = c.green, bold = true },

		-- NeoTree
		NeoTreeNormal = { fg = c.fg, bg = c.bg0 },
		NeoTreeNormalNC = { fg = c.fg, bg = c.bg0 },
		NeoTreeRootName = { fg = c.green, bold = true },
		NeoTreeFileName = { fg = c.fg },
		NeoTreeFileNameOpened = { fg = c.green },
		NeoTreeGitAdded = { fg = c.git_add },
		NeoTreeGitModified = { fg = c.git_change },
		NeoTreeGitDeleted = { fg = c.git_delete },
		NeoTreeGitConflict = { fg = c.git_conflict },
		NeoTreeIndentMarker = { fg = c.gray1 },

		-- Which-key
		WhichKey = { fg = c.green },
		WhichKeyGroup = { fg = c.purple },
		WhichKeyDesc = { fg = c.fg },
		WhichKeySeparator = { fg = c.gray1 },
		WhichKeyFloat = { bg = c.bg2 },

		-- Cmp (completion)
		CmpItemAbbrMatch = { fg = c.green, bold = true },
		CmpItemAbbrMatchFuzzy = { fg = c.green },
		CmpItemKindFunction = { fg = c.func },
		CmpItemKindMethod = { fg = c.func },
		CmpItemKindVariable = { fg = c.variable },
		CmpItemKindKeyword = { fg = c.keyword },
		CmpItemKindText = { fg = c.fg },
		CmpItemKindClass = { fg = c.type },
		CmpItemKindInterface = { fg = c.type },

		-- Indent Blankline
		IndentBlanklineChar = { fg = c.bg3 },
		IndentBlanklineContextChar = { fg = c.green },

		-- Dashboard
		DashboardHeader = { fg = c.green },
		DashboardCenter = { fg = c.aqua },
		DashboardShortCut = { fg = c.purple },
		DashboardFooter = { fg = c.blue, italic = true },

		-- Notify
		NotifyBackground = { bg = c.bg1 },
		NotifyERRORBorder = { fg = c.error },
		NotifyWARNBorder = { fg = c.warning },
		NotifyINFOBorder = { fg = c.info },
		NotifyDEBUGBorder = { fg = c.purple },
		NotifyTRACEBorder = { fg = c.pink },

		-- Flash
		FlashLabel = { fg = c.bg0, bg = c.green, bold = true },
		FlashMatch = { fg = c.green },
		FlashCurrent = { fg = c.red, bold = true },

		-- Snacks
		SnacksNotifierBorderInfo = { fg = c.info },
		SnacksNotifierBorderWarn = { fg = c.warning },
		SnacksNotifierBorderError = { fg = c.error },
		SnacksNotifierBorderDebug = { fg = c.purple },
		SnacksNotifierBorderTrace = { fg = c.pink },
	}

	for group, settings in pairs(highlights) do
		vim.api.nvim_set_hl(0, group, settings)
	end
end

return M
