-- ═══════════════════════════════════════════════════════════════════════════
-- KANAGAWA WAVE THEME FOR NEOVIM
-- Inspired by Katsushika Hokusai — official palette
-- ═══════════════════════════════════════════════════════════════════════════

local M = {}

-- ═══════════════════════════════════════════════════════════════════════════
-- COLOR PALETTE
-- ═══════════════════════════════════════════════════════════════════════════

M.colors = {
	-- Backgrounds
	bg0 = "#16161D", -- sumiInk0
	bg1 = "#1F1F28", -- sumiInk1
	bg2 = "#2A2A37", -- sumiInk2
	bg3 = "#363646", -- sumiInk3
	bg4 = "#54546D", -- sumiInk4

	-- Foregrounds
	fg = "#DCD7BA", -- fujiWhite
	fg_dim = "#C8C093", -- oldWhite
	fg_bright = "#DCD7BA", -- fujiWhite
	fg_muted = "#727169", -- fujiGray

	-- Primary accents
	red = "#E46876", -- waveRed
	red_bright = "#FF5D62", -- peachRed
	red_dim = "#43242B", -- winterRed

	orange = "#FFA066", -- surimiOrange
	orange_bright = "#FFA066",
	orange_dim = "#FFA066",

	pink = "#D27E99", -- sakuraPink
	pink_bright = "#D27E99",
	pink_dim = "#D27E99",

	-- Additional colors
	yellow = "#E6C384", -- carpYellow
	gold = "#C0A36E", -- boatYellow2

	green = "#98BB6C", -- springGreen
	aqua = "#7AA89F", -- waveAqua2
	blue = "#7E9CD8", -- crystalBlue

	purple = "#957FB8", -- oniViolet
	magenta = "#938AA9", -- springViolet1

	-- Neutral accents
	gray0 = "#727169", -- fujiGray
	gray1 = "#717C7C", -- katanaGray
	gray2 = "#938AA9", -- springViolet1
	gray3 = "#9CABCA", -- springViolet2

	-- Semantic colors
	success = "#98BB6C", -- springGreen
	warning = "#FF9E3B", -- roninYellow
	error = "#E82424", -- samuraiRed
	info = "#6A9589", -- waveAqua1

	-- UI elements
	cursor = "#E6C384", -- carpYellow
	cursor_bg = "#1F1F28", -- sumiInk1
	line = "#2A2A37", -- sumiInk2
	visual = "#223249", -- waveBlue1
	selection = "#2D4F67", -- waveBlue2

	border = "#54546D", -- sumiInk4
	border_dim = "#363646", -- sumiInk3

	-- Syntax
	comment = "#727169", -- fujiGray
	constant = "#FFA066", -- surimiOrange
	string = "#98BB6C", -- springGreen
	func = "#7E9CD8", -- crystalBlue
	keyword = "#957FB8", -- oniViolet
	variable = "#DCD7BA", -- fujiWhite
	type = "#7AA89F", -- waveAqua2
	operator = "#C0A36E", -- boatYellow2
	number = "#D27E99", -- sakuraPink

	-- Git
	git_add = "#76946A", -- autumnGreen
	git_change = "#DCA561", -- autumnYellow
	git_delete = "#C34043", -- autumnRed
	git_conflict = "#FF9E3B", -- roninYellow

	-- Diagnostics
	diagnostic_error = "#E82424", -- samuraiRed
	diagnostic_warn = "#FF9E3B", -- roninYellow
	diagnostic_info = "#6A9589", -- waveAqua1
	diagnostic_hint = "#658594", -- dragonBlue

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
		LineNr = { fg = c.gray0 },
		CursorLineNr = { fg = c.yellow, bold = true },
		SignColumn = { fg = c.gray0, bg = c.none },

		-- Visual mode
		Visual = { bg = c.visual },
		VisualNOS = { bg = c.visual },

		-- Search
		Search = { fg = c.bg0, bg = c.yellow },
		IncSearch = { fg = c.bg0, bg = c.orange },
		CurSearch = { fg = c.bg0, bg = c.red_bright },

		-- Popup menu
		Pmenu = { fg = c.fg, bg = c.bg2 },
		PmenuSel = { fg = c.fg_bright, bg = c.selection, bold = true },
		PmenuSbar = { bg = c.bg3 },
		PmenuThumb = { bg = c.blue },

		-- Statusline
		StatusLine = { fg = c.fg, bg = c.none },
		StatusLineNC = { fg = c.gray0, bg = c.none },

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
		FoldColumn = { fg = c.gray0, bg = c.bg1 },

		-- Diff
		DiffAdd = { bg = "#2B3328" }, -- winterGreen
		DiffChange = { bg = "#49443C" }, -- winterYellow
		DiffDelete = { bg = "#43242B" }, -- winterRed
		DiffText = { fg = c.fg_bright, bg = "#252535", bold = true }, -- winterBlue

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

		PreProc = { fg = c.red },
		Include = { fg = c.purple },
		Define = { fg = c.purple },
		Macro = { fg = c.purple },
		PreCondit = { fg = c.purple },

		Type = { fg = c.type },
		StorageClass = { fg = c.keyword },
		Structure = { fg = c.type },
		Typedef = { fg = c.type },

		Special = { fg = c.orange },
		SpecialChar = { fg = c.pink },
		Tag = { fg = c.orange },
		Delimiter = { fg = c.fg_dim },
		SpecialComment = { fg = c.pink, italic = true },
		Debug = { fg = c.red_bright },

		Underlined = { underline = true },
		Ignore = { fg = c.gray0 },
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
		["@variable.builtin"] = { fg = c.red },
		["@variable.parameter"] = { fg = c.variable },
		["@variable.member"] = { fg = c.variable },

		["@constant"] = { fg = c.constant },
		["@constant.builtin"] = { fg = c.constant },
		["@constant.macro"] = { fg = c.purple },

		["@string"] = { fg = c.string },
		["@string.escape"] = { fg = c.orange },
		["@string.regexp"] = { fg = c.gold },

		["@character"] = { fg = c.string },
		["@number"] = { fg = c.number },
		["@boolean"] = { fg = c.constant },
		["@float"] = { fg = c.number },

		["@function"] = { fg = c.func, bold = true },
		["@function.builtin"] = { fg = "#7FB4CA" }, -- springBlue
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
		["@punctuation.bracket"] = { fg = c.gray3 },
		["@punctuation.special"] = { fg = c.orange },

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
		TelescopePromptBorder = { fg = c.yellow },
		TelescopeResultsBorder = { fg = c.border_dim },
		TelescopePreviewBorder = { fg = c.border_dim },
		TelescopeSelection = { fg = c.fg_bright, bg = c.selection, bold = true },
		TelescopeMatching = { fg = c.yellow, bold = true },

		-- NeoTree
		NeoTreeNormal = { fg = c.fg, bg = c.bg0 },
		NeoTreeNormalNC = { fg = c.fg, bg = c.bg0 },
		NeoTreeRootName = { fg = c.yellow, bold = true },
		NeoTreeFileName = { fg = c.fg },
		NeoTreeFileNameOpened = { fg = c.yellow },
		NeoTreeGitAdded = { fg = c.git_add },
		NeoTreeGitModified = { fg = c.git_change },
		NeoTreeGitDeleted = { fg = c.git_delete },
		NeoTreeGitConflict = { fg = c.git_conflict },
		NeoTreeIndentMarker = { fg = c.gray0 },

		-- Which-key
		WhichKey = { fg = c.yellow },
		WhichKeyGroup = { fg = c.purple },
		WhichKeyDesc = { fg = c.fg },
		WhichKeySeparator = { fg = c.gray0 },
		WhichKeyFloat = { bg = c.bg2 },

		-- Cmp (completion)
		CmpItemAbbrMatch = { fg = c.yellow, bold = true },
		CmpItemAbbrMatchFuzzy = { fg = c.yellow },
		CmpItemKindFunction = { fg = c.func },
		CmpItemKindMethod = { fg = c.func },
		CmpItemKindVariable = { fg = c.variable },
		CmpItemKindKeyword = { fg = c.keyword },
		CmpItemKindText = { fg = c.fg },
		CmpItemKindClass = { fg = c.type },
		CmpItemKindInterface = { fg = c.type },

		-- Indent Blankline
		IndentBlanklineChar = { fg = c.bg3 },
		IndentBlanklineContextChar = { fg = c.yellow },

		-- Dashboard
		DashboardHeader = { fg = c.yellow },
		DashboardCenter = { fg = c.aqua },
		DashboardShortCut = { fg = c.purple },
		DashboardFooter = { fg = c.green, italic = true },

		-- Notify
		NotifyBackground = { bg = c.bg1 },
		NotifyERRORBorder = { fg = c.error },
		NotifyWARNBorder = { fg = c.warning },
		NotifyINFOBorder = { fg = c.info },
		NotifyDEBUGBorder = { fg = c.purple },
		NotifyTRACEBorder = { fg = c.pink },

		-- Flash
		FlashLabel = { fg = c.bg0, bg = c.yellow, bold = true },
		FlashMatch = { fg = c.yellow },
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
