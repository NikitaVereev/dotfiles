-- ═══════════════════════════════════════════════════════════════════════════
-- BLOODMOON — Vivid Crimson Dark
-- Structure mirrors oxocarbon: bright fg, vivid syntax, dark backgrounds.
-- ═══════════════════════════════════════════════════════════════════════════

local M = {}

M.colors = {
	-- ── Backgrounds ────────────────────────────────────────────────────────
	bg0 = "#0D0A0A",
	bg1 = "#131010",
	bg2 = "#1E1616",
	bg3 = "#2A1E1E",
	bg4 = "#362828",

	-- ── Foregrounds (bright — mirrors oxocarbon #f2f4f8 approach) ──────────
	fg        = "#F2E8E4",
	fg_dim    = "#D8CECA",
	fg_bright = "#FFF5F2",
	fg_muted  = "#9A8280",

	-- ── Crimson — primary accent ────────────────────────────────────────────
	red        = "#E03050",
	red_bright = "#FF4060",
	red_dim    = "#7A1828",

	-- ── Amber / Gold — secondary accent ────────────────────────────────────
	amber        = "#E09030",
	amber_bright = "#F0A840",
	amber_dim    = "#A06020",

	-- ── Syntax ─────────────────────────────────────────────────────────────
	green  = "#5AAA6A", -- strings
	steel  = "#6A9EC8", -- types
	ochre  = "#D09828", -- constants / numbers
	rust   = "#C07050", -- special chars
	purple = "#C878C0", -- preprocessor / macros

	-- ── Grays (red-tinted, same relative lightness as oxocarbon) ────────────
	comment = "#8A7270",
	gray0   = "#362828",
	gray1   = "#5A4442",
	gray2   = "#8A7270",
	gray3   = "#A08888",

	-- ── Semantic ───────────────────────────────────────────────────────────
	success = "#5AAA6A",
	warning = "#E09030",
	error   = "#FF4060",
	info    = "#6A9EC8",

	-- ── Git ────────────────────────────────────────────────────────────────
	git_add      = "#5AAA6A",
	git_change   = "#E09030",
	git_delete   = "#FF4060",
	git_conflict = "#E03050",

	-- ── Diagnostics ────────────────────────────────────────────────────────
	diagnostic_error = "#FF4060",
	diagnostic_warn  = "#E09030",
	diagnostic_info  = "#6A9EC8",
	diagnostic_hint  = "#5AAA6A",

	-- ── UI ─────────────────────────────────────────────────────────────────
	cursor     = "#E03050",
	cursor_bg  = "#0D0A0A",
	line       = "#1E1616",
	visual     = "#2A1E1E",
	selection  = "#362828",
	border     = "#7A1828",
	border_dim = "#3A1010",

	none = "NONE",
}

-- ═══════════════════════════════════════════════════════════════════════════

function M.setup()
	local c = M.colors

	local highlights = {
		-- ── Editor ─────────────────────────────────────────────────────────
		Normal      = { fg = c.fg, bg = c.none },
		NormalFloat = { fg = c.fg, bg = c.none },
		NormalNC    = { fg = c.fg, bg = c.none },

		Cursor       = { fg = c.cursor_bg, bg = c.cursor },
		CursorLine   = { bg = c.line },
		CursorColumn = { bg = c.line },
		ColorColumn  = { bg = c.bg2 },

		LineNr       = { fg = c.gray1 },
		CursorLineNr = { fg = c.amber, bold = true },
		SignColumn   = { fg = c.gray1, bg = c.none },

		Visual    = { bg = c.visual },
		VisualNOS = { bg = c.visual },

		Search    = { fg = c.bg0, bg = c.ochre  },
		IncSearch = { fg = c.bg0, bg = c.amber  },
		CurSearch = { fg = c.bg0, bg = c.red    },

		Pmenu      = { fg = c.fg,        bg = c.bg2 },
		PmenuSel   = { fg = c.fg_bright, bg = c.bg3, bold = true },
		PmenuSbar  = { bg = c.bg3 },
		PmenuThumb = { bg = c.red_dim },

		StatusLine   = { fg = c.fg,    bg = c.none },
		StatusLineNC = { fg = c.gray1, bg = c.none },

		TabLine     = { fg = c.gray2,    bg = c.bg2 },
		TabLineSel  = { fg = c.fg_bright, bg = c.bg3, bold = true },
		TabLineFill = { bg = c.bg1 },

		VertSplit    = { fg = c.border_dim },
		WinSeparator = { fg = c.border_dim },
		FloatBorder  = { fg = c.border, bg = c.bg2 },

		Folded     = { fg = c.gray2, bg = c.bg2 },
		FoldColumn = { fg = c.gray1, bg = c.bg1 },

		DiffAdd    = { fg = c.git_add,    bg = c.bg2 },
		DiffChange = { fg = c.git_change, bg = c.bg2 },
		DiffDelete = { fg = c.git_delete, bg = c.bg2 },
		DiffText   = { fg = c.fg_bright,  bg = c.bg3, bold = true },

		SpellBad   = { sp = c.error,   undercurl = true },
		SpellCap   = { sp = c.warning, undercurl = true },
		SpellLocal = { sp = c.info,    undercurl = true },
		SpellRare  = { sp = c.purple,  undercurl = true },

		ErrorMsg   = { fg = c.error,   bold = true },
		WarningMsg = { fg = c.warning, bold = true },
		ModeMsg    = { fg = c.amber,   bold = true },
		MoreMsg    = { fg = c.success, bold = true },
		Question   = { fg = c.steel },

		NonText = { fg = c.fg },
		SnacksPickerGitStatusUntracked = { fg = c.fg, bg = c.none },

		-- ── Syntax ─────────────────────────────────────────────────────────
		Comment = { fg = c.comment, italic = true },

		Constant  = { fg = c.ochre },
		String    = { fg = c.green },
		Character = { fg = c.green },
		Number    = { fg = c.ochre },
		Boolean   = { fg = c.ochre },
		Float     = { fg = c.ochre },

		Identifier = { fg = c.fg },
		Function   = { fg = c.amber, bold = true },

		Statement   = { fg = c.red,       bold = true },
		Conditional = { fg = c.red },
		Repeat      = { fg = c.red },
		Label       = { fg = c.red },
		Operator    = { fg = c.gray3 },
		Keyword     = { fg = c.red },
		Exception   = { fg = c.red_bright },

		PreProc   = { fg = c.purple },
		Include   = { fg = c.purple },
		Define    = { fg = c.purple },
		Macro     = { fg = c.purple },
		PreCondit = { fg = c.purple },

		Type         = { fg = c.steel },
		StorageClass = { fg = c.red },
		Structure    = { fg = c.steel },
		Typedef      = { fg = c.steel },

		Special        = { fg = c.amber_bright },
		SpecialChar    = { fg = c.rust },
		Tag            = { fg = c.amber },
		Delimiter      = { fg = c.fg_dim },
		SpecialComment = { fg = c.rust, italic = true },
		Debug          = { fg = c.red_bright },

		Underlined = { underline = true },
		Ignore     = { fg = c.gray1 },
		Error      = { fg = c.error, bold = true },
		Todo       = { fg = c.ochre, bg = c.bg3, bold = true },

		-- ── LSP ────────────────────────────────────────────────────────────
		DiagnosticError = { fg = c.diagnostic_error },
		DiagnosticWarn  = { fg = c.diagnostic_warn },
		DiagnosticInfo  = { fg = c.diagnostic_info },
		DiagnosticHint  = { fg = c.diagnostic_hint },

		DiagnosticUnderlineError = { sp = c.diagnostic_error, undercurl = true },
		DiagnosticUnderlineWarn  = { sp = c.diagnostic_warn,  undercurl = true },
		DiagnosticUnderlineInfo  = { sp = c.diagnostic_info,  undercurl = true },
		DiagnosticUnderlineHint  = { sp = c.diagnostic_hint,  undercurl = true },

		["@lsp.type.class"]         = { fg = c.steel },
		["@lsp.type.decorator"]     = { fg = c.purple },
		["@lsp.type.enum"]          = { fg = c.steel },
		["@lsp.type.enumMember"]    = { fg = c.ochre },
		["@lsp.type.function"]      = { fg = c.amber, bold = true },
		["@lsp.type.interface"]     = { fg = c.steel },
		["@lsp.type.macro"]         = { fg = c.purple },
		["@lsp.type.method"]        = { fg = c.amber },
		["@lsp.type.namespace"]     = { fg = c.steel },
		["@lsp.type.parameter"]     = { fg = c.fg },
		["@lsp.type.property"]      = { fg = c.fg },
		["@lsp.type.struct"]        = { fg = c.steel },
		["@lsp.type.type"]          = { fg = c.steel },
		["@lsp.type.typeParameter"] = { fg = c.steel },
		["@lsp.type.variable"]      = { fg = c.fg },

		-- ── Treesitter ─────────────────────────────────────────────────────
		["@variable"]           = { fg = c.fg },
		["@variable.builtin"]   = { fg = c.red },
		["@variable.parameter"] = { fg = c.fg },
		["@variable.member"]    = { fg = c.fg },

		["@constant"]         = { fg = c.ochre },
		["@constant.builtin"] = { fg = c.ochre },
		["@constant.macro"]   = { fg = c.purple },

		["@string"]        = { fg = c.green },
		["@string.escape"] = { fg = c.rust },
		["@string.regexp"] = { fg = c.rust },

		["@character"] = { fg = c.green },
		["@number"]    = { fg = c.ochre },
		["@boolean"]   = { fg = c.ochre },
		["@float"]     = { fg = c.ochre },

		["@function"]         = { fg = c.amber, bold = true },
		["@function.builtin"] = { fg = c.amber },
		["@function.macro"]   = { fg = c.purple },
		["@function.call"]    = { fg = c.amber },
		["@method"]           = { fg = c.amber },
		["@method.call"]      = { fg = c.amber },
		["@constructor"]      = { fg = c.steel },

		["@keyword"]             = { fg = c.red, bold = true },
		["@keyword.function"]    = { fg = c.red },
		["@keyword.operator"]    = { fg = c.gray3 },
		["@keyword.return"]      = { fg = c.red_bright },
		["@keyword.conditional"] = { fg = c.red },
		["@keyword.repeat"]      = { fg = c.red },
		["@keyword.exception"]   = { fg = c.red_bright },

		["@operator"] = { fg = c.gray3 },

		["@type"]            = { fg = c.steel },
		["@type.builtin"]    = { fg = c.steel },
		["@type.definition"] = { fg = c.steel },

		["@punctuation.delimiter"] = { fg = c.fg_dim },
		["@punctuation.bracket"]   = { fg = c.fg_dim },
		["@punctuation.special"]   = { fg = c.amber_bright },

		["@comment"]         = { fg = c.comment, italic = true },
		["@comment.todo"]    = { fg = c.ochre,   bg = c.bg3, bold = true },
		["@comment.warning"] = { fg = c.warning, bold = true },
		["@comment.note"]    = { fg = c.info,    bold = true },
		["@comment.error"]   = { fg = c.error,   bold = true },

		["@tag"]           = { fg = c.red },
		["@tag.attribute"] = { fg = c.amber },
		["@tag.delimiter"] = { fg = c.fg_dim },

		-- ── Git ────────────────────────────────────────────────────────────
		GitSignsAdd    = { fg = c.git_add },
		GitSignsChange = { fg = c.git_change },
		GitSignsDelete = { fg = c.git_delete },

		-- ── Telescope ──────────────────────────────────────────────────────
		TelescopeBorder        = { fg = c.border },
		TelescopePromptBorder  = { fg = c.red },
		TelescopeResultsBorder = { fg = c.border_dim },
		TelescopePreviewBorder = { fg = c.border_dim },
		TelescopeSelection     = { fg = c.fg_bright, bg = c.bg3, bold = true },
		TelescopeMatching      = { fg = c.amber, bold = true },

		-- ── Neo-tree ───────────────────────────────────────────────────────
		NeoTreeNormal         = { fg = c.fg,    bg = c.bg0 },
		NeoTreeNormalNC       = { fg = c.fg,    bg = c.bg0 },
		NeoTreeRootName       = { fg = c.red,   bold = true },
		NeoTreeFileName       = { fg = c.fg },
		NeoTreeFileNameOpened = { fg = c.amber },
		NeoTreeGitAdded       = { fg = c.git_add },
		NeoTreeGitModified    = { fg = c.git_change },
		NeoTreeGitDeleted     = { fg = c.git_delete },
		NeoTreeGitConflict    = { fg = c.git_conflict },
		NeoTreeIndentMarker   = { fg = c.gray1 },

		-- ── Which-key ──────────────────────────────────────────────────────
		WhichKey          = { fg = c.amber },
		WhichKeyGroup     = { fg = c.purple },
		WhichKeyDesc      = { fg = c.fg },
		WhichKeySeparator = { fg = c.gray1 },
		WhichKeyFloat     = { bg = c.bg2 },

		-- ── Completion ─────────────────────────────────────────────────────
		CmpItemAbbrMatch      = { fg = c.amber, bold = true },
		CmpItemAbbrMatchFuzzy = { fg = c.amber },
		CmpItemKindFunction   = { fg = c.amber },
		CmpItemKindMethod     = { fg = c.amber },
		CmpItemKindVariable   = { fg = c.fg },
		CmpItemKindKeyword    = { fg = c.red },
		CmpItemKindText       = { fg = c.fg },
		CmpItemKindClass      = { fg = c.steel },
		CmpItemKindInterface  = { fg = c.steel },

		-- ── Indent blankline ───────────────────────────────────────────────
		IndentBlanklineChar        = { fg = c.bg3 },
		IndentBlanklineContextChar = { fg = c.red_dim },

		-- ── Dashboard ──────────────────────────────────────────────────────
		DashboardHeader   = { fg = c.red,   bold = true },
		DashboardCenter   = { fg = c.amber },
		DashboardShortCut = { fg = c.purple },
		DashboardFooter   = { fg = c.rust,  italic = true },

		-- ── Notify ─────────────────────────────────────────────────────────
		NotifyBackground  = { bg = c.bg1 },
		NotifyERRORBorder = { fg = c.error },
		NotifyWARNBorder  = { fg = c.warning },
		NotifyINFOBorder  = { fg = c.info },
		NotifyDEBUGBorder = { fg = c.purple },
		NotifyTRACEBorder = { fg = c.rust },

		-- ── Flash ──────────────────────────────────────────────────────────
		FlashLabel   = { fg = c.bg0, bg = c.red, bold = true },
		FlashMatch   = { fg = c.amber },
		FlashCurrent = { fg = c.red_bright, bold = true },

		-- ── Snacks ─────────────────────────────────────────────────────────
		SnacksNotifierBorderInfo  = { fg = c.info },
		SnacksNotifierBorderWarn  = { fg = c.warning },
		SnacksNotifierBorderError = { fg = c.error },
		SnacksNotifierBorderDebug = { fg = c.purple },
		SnacksNotifierBorderTrace = { fg = c.rust },
	}

	for group, settings in pairs(highlights) do
		vim.api.nvim_set_hl(0, group, settings)
	end
end

return M
