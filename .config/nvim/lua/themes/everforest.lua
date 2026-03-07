-- ═══════════════════════════════════════════════════════════════════════════
-- EVERFOREST — Dark Medium
-- https://github.com/sainnhe/everforest
-- ═══════════════════════════════════════════════════════════════════════════

local M = {}

M.colors = {
	-- ── Backgrounds (darkest → lightest) ───────────────────────────────────
	bg0 = "#232A2E", -- bg_dim  — sidebar, neotree
	bg1 = "#2D353B", -- bg0     — main editor background
	bg2 = "#343F44", -- bg1     — floats, popups
	bg3 = "#3D484D", -- bg2     — cursorline, selections
	bg4 = "#475258", -- bg3     — visual mode

	-- ── Foregrounds ────────────────────────────────────────────────────────
	fg        = "#D3C6AA",
	fg_dim    = "#859289", -- grey1
	fg_bright = "#E8DCCA", -- brighter warm white
	fg_muted  = "#7A8478", -- grey0

	-- ── Accents (official everforest palette) ──────────────────────────────
	red    = "#E67E80",
	orange = "#E69875",
	yellow = "#DBBC7F",
	green  = "#A7C080",
	aqua   = "#83C092",
	blue   = "#7FBBB3",
	purple = "#D699B6",

	-- ── Semantic bg tints ──────────────────────────────────────────────────
	bg_red    = "#514045",
	bg_visual = "#543A48",

	-- ── Grays ──────────────────────────────────────────────────────────────
	gray0 = "#7A8478", -- grey0
	gray1 = "#859289", -- grey1
	gray2 = "#9DA9A0", -- grey2

	-- ── Semantic ───────────────────────────────────────────────────────────
	success = "#A7C080",
	warning = "#DBBC7F",
	error   = "#E67E80",
	info    = "#7FBBB3",

	-- ── Git ────────────────────────────────────────────────────────────────
	git_add      = "#A7C080",
	git_change   = "#7FBBB3",
	git_delete   = "#E67E80",
	git_conflict = "#E69875",

	-- ── Diagnostics ────────────────────────────────────────────────────────
	diagnostic_error = "#E67E80",
	diagnostic_warn  = "#DBBC7F",
	diagnostic_info  = "#7FBBB3",
	diagnostic_hint  = "#A7C080",

	-- ── UI ─────────────────────────────────────────────────────────────────
	cursor     = "#A7C080",
	cursor_bg  = "#2D353B",
	line       = "#343F44",
	visual     = "#543A48", -- bg_visual
	selection  = "#475258",
	border     = "#859289",
	border_dim = "#7A8478",

	-- ── Syntax ─────────────────────────────────────────────────────────────
	-- NOTE: strings use aqua, functions use green — visually distinct
	comment  = "#859289",
	constant = "#D699B6",
	string   = "#83C092", -- aqua  (distinct from functions)
	func     = "#A7C080", -- green
	keyword  = "#E67E80",
	variable = "#D3C6AA",
	type     = "#7FBBB3",
	operator = "#E69875",
	number   = "#D699B6",

	none = "NONE",
}

-- ═══════════════════════════════════════════════════════════════════════════

function M.setup()
	local c = M.colors

	local highlights = {
		-- ── Editor ─────────────────────────────────────────────────────────
		Normal      = { fg = c.fg, bg = c.none },
		NormalFloat = { fg = c.fg, bg = c.bg2  },
		NormalNC    = { fg = c.fg, bg = c.none },

		Cursor       = { fg = c.cursor_bg, bg = c.cursor },
		CursorLine   = { bg = c.line },
		CursorColumn = { bg = c.line },
		ColorColumn  = { bg = c.bg2 },

		LineNr       = { fg = c.gray1 },
		CursorLineNr = { fg = c.yellow, bold = true },
		SignColumn   = { fg = c.gray1, bg = c.none },

		Visual    = { bg = c.visual },
		VisualNOS = { bg = c.visual },

		Search    = { fg = c.bg0, bg = c.yellow },
		IncSearch = { fg = c.bg0, bg = c.orange },
		CurSearch = { fg = c.bg0, bg = c.red    },

		Pmenu      = { fg = c.fg,        bg = c.bg2 },
		PmenuSel   = { fg = c.fg_bright, bg = c.bg3, bold = true },
		PmenuSbar  = { bg = c.bg3 },
		PmenuThumb = { bg = c.green },

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
		ModeMsg    = { fg = c.green,   bold = true },
		MoreMsg    = { fg = c.success, bold = true },
		Question   = { fg = c.blue    },

		NonText = { fg = c.fg },
		SnacksPickerGitStatusUntracked = { fg = c.fg, bg = c.none },

		-- ── Syntax ─────────────────────────────────────────────────────────
		Comment = { fg = c.comment, italic = true },

		Constant  = { fg = c.constant },
		String    = { fg = c.string   },
		Character = { fg = c.string   },
		Number    = { fg = c.number   },
		Boolean   = { fg = c.constant },
		Float     = { fg = c.number   },

		Identifier = { fg = c.variable },
		Function   = { fg = c.func, bold = true },

		Statement   = { fg = c.keyword, bold = true },
		Conditional = { fg = c.keyword },
		Repeat      = { fg = c.keyword },
		Label       = { fg = c.keyword },
		Operator    = { fg = c.operator },
		Keyword     = { fg = c.keyword },
		Exception   = { fg = c.red     },

		PreProc   = { fg = c.purple },
		Include   = { fg = c.purple },
		Define    = { fg = c.purple },
		Macro     = { fg = c.purple },
		PreCondit = { fg = c.purple },

		Type         = { fg = c.type    },
		StorageClass = { fg = c.keyword },
		Structure    = { fg = c.type    },
		Typedef      = { fg = c.type    },

		Special        = { fg = c.orange  },
		SpecialChar    = { fg = c.purple  },
		Tag            = { fg = c.orange  },
		Delimiter      = { fg = c.fg_dim  },
		SpecialComment = { fg = c.purple, italic = true },
		Debug          = { fg = c.red     },

		Underlined = { underline = true },
		Ignore     = { fg = c.gray1 },
		Error      = { fg = c.error, bold = true },
		Todo       = { fg = c.yellow, bg = c.bg3, bold = true },

		-- ── LSP ────────────────────────────────────────────────────────────
		DiagnosticError = { fg = c.diagnostic_error },
		DiagnosticWarn  = { fg = c.diagnostic_warn  },
		DiagnosticInfo  = { fg = c.diagnostic_info  },
		DiagnosticHint  = { fg = c.diagnostic_hint  },

		DiagnosticUnderlineError = { sp = c.diagnostic_error, undercurl = true },
		DiagnosticUnderlineWarn  = { sp = c.diagnostic_warn,  undercurl = true },
		DiagnosticUnderlineInfo  = { sp = c.diagnostic_info,  undercurl = true },
		DiagnosticUnderlineHint  = { sp = c.diagnostic_hint,  undercurl = true },

		["@lsp.type.class"]         = { fg = c.type     },
		["@lsp.type.decorator"]     = { fg = c.purple   },
		["@lsp.type.enum"]          = { fg = c.type     },
		["@lsp.type.enumMember"]    = { fg = c.constant },
		["@lsp.type.function"]      = { fg = c.func, bold = true },
		["@lsp.type.interface"]     = { fg = c.type     },
		["@lsp.type.macro"]         = { fg = c.purple   },
		["@lsp.type.method"]        = { fg = c.func     },
		["@lsp.type.namespace"]     = { fg = c.type     },
		["@lsp.type.parameter"]     = { fg = c.variable },
		["@lsp.type.property"]      = { fg = c.variable },
		["@lsp.type.struct"]        = { fg = c.type     },
		["@lsp.type.type"]          = { fg = c.type     },
		["@lsp.type.typeParameter"] = { fg = c.type     },
		["@lsp.type.variable"]      = { fg = c.variable },

		-- ── Treesitter ─────────────────────────────────────────────────────
		["@variable"]           = { fg = c.variable },
		["@variable.builtin"]   = { fg = c.blue     },
		["@variable.parameter"] = { fg = c.variable },
		["@variable.member"]    = { fg = c.variable },

		["@constant"]         = { fg = c.constant },
		["@constant.builtin"] = { fg = c.constant },
		["@constant.macro"]   = { fg = c.purple   },

		["@string"]        = { fg = c.string  },
		["@string.escape"] = { fg = c.orange  },
		["@string.regexp"] = { fg = c.orange  },

		["@character"] = { fg = c.string  },
		["@number"]    = { fg = c.number  },
		["@boolean"]   = { fg = c.constant },
		["@float"]     = { fg = c.number  },

		["@function"]         = { fg = c.func, bold = true },
		["@function.builtin"] = { fg = c.func   },
		["@function.macro"]   = { fg = c.purple },
		["@function.call"]    = { fg = c.func   },
		["@method"]           = { fg = c.func   },
		["@method.call"]      = { fg = c.func   },
		["@constructor"]      = { fg = c.type   },

		["@keyword"]             = { fg = c.keyword, bold = true },
		["@keyword.function"]    = { fg = c.keyword },
		["@keyword.operator"]    = { fg = c.operator },
		["@keyword.return"]      = { fg = c.keyword  },
		["@keyword.conditional"] = { fg = c.keyword  },
		["@keyword.repeat"]      = { fg = c.keyword  },
		["@keyword.exception"]   = { fg = c.red      },

		["@operator"] = { fg = c.operator },

		["@type"]            = { fg = c.type },
		["@type.builtin"]    = { fg = c.type },
		["@type.definition"] = { fg = c.type },

		["@punctuation.delimiter"] = { fg = c.fg_dim  },
		["@punctuation.bracket"]   = { fg = c.fg_dim  },
		["@punctuation.special"]   = { fg = c.orange  },

		["@comment"]         = { fg = c.comment, italic = true },
		["@comment.todo"]    = { fg = c.yellow,  bg = c.bg3, bold = true },
		["@comment.warning"] = { fg = c.warning, bold = true },
		["@comment.note"]    = { fg = c.info,    bold = true },
		["@comment.error"]   = { fg = c.error,   bold = true },

		["@tag"]           = { fg = c.orange },
		["@tag.attribute"] = { fg = c.purple },
		["@tag.delimiter"] = { fg = c.fg_dim },

		-- ── Git ────────────────────────────────────────────────────────────
		GitSignsAdd    = { fg = c.git_add    },
		GitSignsChange = { fg = c.git_change },
		GitSignsDelete = { fg = c.git_delete },

		-- ── Telescope ──────────────────────────────────────────────────────
		TelescopeBorder        = { fg = c.border     },
		TelescopePromptBorder  = { fg = c.green      },
		TelescopeResultsBorder = { fg = c.border_dim },
		TelescopePreviewBorder = { fg = c.border_dim },
		TelescopeSelection     = { fg = c.fg_bright, bg = c.bg3, bold = true },
		TelescopeMatching      = { fg = c.green, bold = true },

		-- ── Neo-tree ───────────────────────────────────────────────────────
		NeoTreeNormal         = { fg = c.fg,    bg = c.bg0 },
		NeoTreeNormalNC       = { fg = c.fg,    bg = c.bg0 },
		NeoTreeRootName       = { fg = c.green, bold = true },
		NeoTreeFileName       = { fg = c.fg    },
		NeoTreeFileNameOpened = { fg = c.green },
		NeoTreeGitAdded       = { fg = c.git_add      },
		NeoTreeGitModified    = { fg = c.git_change   },
		NeoTreeGitDeleted     = { fg = c.git_delete   },
		NeoTreeGitConflict    = { fg = c.git_conflict },
		NeoTreeIndentMarker   = { fg = c.gray1        },

		-- ── Which-key ──────────────────────────────────────────────────────
		WhichKey          = { fg = c.green  },
		WhichKeyGroup     = { fg = c.purple },
		WhichKeyDesc      = { fg = c.fg     },
		WhichKeySeparator = { fg = c.gray1  },
		WhichKeyFloat     = { bg = c.bg2    },

		-- ── Completion ─────────────────────────────────────────────────────
		CmpItemAbbrMatch      = { fg = c.green, bold = true },
		CmpItemAbbrMatchFuzzy = { fg = c.green },
		CmpItemKindFunction   = { fg = c.func     },
		CmpItemKindMethod     = { fg = c.func     },
		CmpItemKindVariable   = { fg = c.variable },
		CmpItemKindKeyword    = { fg = c.keyword  },
		CmpItemKindText       = { fg = c.fg       },
		CmpItemKindClass      = { fg = c.type     },
		CmpItemKindInterface  = { fg = c.type     },

		-- ── Indent blankline ───────────────────────────────────────────────
		IndentBlanklineChar        = { fg = c.bg3   },
		IndentBlanklineContextChar = { fg = c.green },

		-- ── Dashboard ──────────────────────────────────────────────────────
		DashboardHeader   = { fg = c.green  },
		DashboardCenter   = { fg = c.aqua   },
		DashboardShortCut = { fg = c.purple },
		DashboardFooter   = { fg = c.blue,  italic = true },

		-- ── Notify ─────────────────────────────────────────────────────────
		NotifyBackground  = { bg = c.bg1    },
		NotifyERRORBorder = { fg = c.error  },
		NotifyWARNBorder  = { fg = c.warning },
		NotifyINFOBorder  = { fg = c.info   },
		NotifyDEBUGBorder = { fg = c.purple },
		NotifyTRACEBorder = { fg = c.purple },

		-- ── Flash ──────────────────────────────────────────────────────────
		FlashLabel   = { fg = c.bg0,  bg = c.green, bold = true },
		FlashMatch   = { fg = c.green },
		FlashCurrent = { fg = c.red,  bold = true },

		-- ── Snacks ─────────────────────────────────────────────────────────
		SnacksNotifierBorderInfo  = { fg = c.info    },
		SnacksNotifierBorderWarn  = { fg = c.warning },
		SnacksNotifierBorderError = { fg = c.error   },
		SnacksNotifierBorderDebug = { fg = c.purple  },
		SnacksNotifierBorderTrace = { fg = c.purple  },
	}

	for group, settings in pairs(highlights) do
		vim.api.nvim_set_hl(0, group, settings)
	end
end

return M
