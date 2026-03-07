-- ═══════════════════════════════════════════════════════════════════════════
-- CATPPUCCIN MOCHA — Official palette
-- https://github.com/catppuccin/catppuccin
-- ═══════════════════════════════════════════════════════════════════════════

local M = {}

M.colors = {
	-- ── Backgrounds (darkest → lightest) ───────────────────────────────────
	bg0 = "#11111B", -- crust    — sidebar, neotree
	bg1 = "#181825", -- mantle   — floats, popups (slightly darker than base)
	bg2 = "#1E1E2E", -- base     — main editor background
	bg3 = "#313244", -- surface0 — cursorline, selections
	bg4 = "#45475A", -- surface1 — visual mode, active selections

	-- ── Foregrounds ────────────────────────────────────────────────────────
	fg        = "#CDD6F4", -- text
	fg_dim    = "#A6ADC8", -- subtext0
	fg_bright = "#FFFFFF",
	fg_muted  = "#6C7086", -- overlay0

	-- ── Accents ────────────────────────────────────────────────────────────
	red     = "#F38BA8", -- red
	maroon  = "#EBA0AC", -- maroon (softer red)
	orange  = "#FAB387", -- peach
	yellow  = "#F9E2AF", -- yellow
	green   = "#A6E3A1", -- green
	teal    = "#94E2D5", -- teal
	sky     = "#89DCEB", -- sky
	blue    = "#89B4FA", -- blue
	lavender = "#B4BEFE",-- lavender
	purple  = "#CBA6F7", -- mauve
	pink    = "#F5C2E7", -- pink
	flamingo = "#F2CDCD",-- flamingo
	rosewater = "#F5E0DC",

	-- ── Grays ──────────────────────────────────────────────────────────────
	gray0 = "#585B70", -- surface2
	gray1 = "#6C7086", -- overlay0
	gray2 = "#7F849C", -- overlay1
	gray3 = "#9399B2", -- overlay2

	-- ── Semantic ───────────────────────────────────────────────────────────
	success = "#A6E3A1",
	warning = "#F9E2AF",
	error   = "#F38BA8",
	info    = "#89B4FA",

	-- ── Git ────────────────────────────────────────────────────────────────
	git_add      = "#A6E3A1",
	git_change   = "#F9E2AF",
	git_delete   = "#F38BA8",
	git_conflict = "#FAB387",

	-- ── Diagnostics ────────────────────────────────────────────────────────
	diagnostic_error = "#F38BA8",
	diagnostic_warn  = "#F9E2AF",
	diagnostic_info  = "#89B4FA",
	diagnostic_hint  = "#94E2D5",

	-- ── UI ─────────────────────────────────────────────────────────────────
	cursor     = "#F5E0DC", -- rosewater
	cursor_bg  = "#1E1E2E",
	line       = "#313244", -- surface0
	visual     = "#45475A", -- surface1
	selection  = "#585B70", -- surface2
	border     = "#89B4FA", -- blue
	border_dim = "#6C7086", -- overlay0

	-- ── Syntax aliases ─────────────────────────────────────────────────────
	comment  = "#6C7086",
	constant = "#FAB387",
	string   = "#A6E3A1",
	func     = "#89B4FA",
	keyword  = "#CBA6F7",
	variable = "#CDD6F4",
	type     = "#F9E2AF",
	operator = "#89DCEB",
	number   = "#FAB387",

	none = "NONE",
}

-- ═══════════════════════════════════════════════════════════════════════════

function M.setup()
	local c = M.colors

	local highlights = {
		-- ── Editor ─────────────────────────────────────────────────────────
		Normal      = { fg = c.fg, bg = c.none },
		NormalFloat = { fg = c.fg, bg = c.bg1  },
		NormalNC    = { fg = c.fg, bg = c.none },

		Cursor       = { fg = c.cursor_bg, bg = c.cursor },
		CursorLine   = { bg = c.line },
		CursorColumn = { bg = c.line },
		ColorColumn  = { bg = c.bg3  },

		LineNr       = { fg = c.gray1 },
		CursorLineNr = { fg = c.yellow, bold = true },
		SignColumn   = { fg = c.gray1, bg = c.none },

		Visual    = { bg = c.visual },
		VisualNOS = { bg = c.visual },

		Search    = { fg = c.bg0, bg = c.yellow },
		IncSearch = { fg = c.bg0, bg = c.orange },
		CurSearch = { fg = c.bg0, bg = c.red    },

		Pmenu      = { fg = c.fg,        bg = c.bg1 },
		PmenuSel   = { fg = c.fg_bright, bg = c.bg3, bold = true },
		PmenuSbar  = { bg = c.bg3 },
		PmenuThumb = { bg = c.blue },

		StatusLine   = { fg = c.fg,    bg = c.none },
		StatusLineNC = { fg = c.gray1, bg = c.none },

		TabLine     = { fg = c.gray2,    bg = c.bg1 },
		TabLineSel  = { fg = c.fg_bright, bg = c.bg3, bold = true },
		TabLineFill = { bg = c.bg2 },

		VertSplit    = { fg = c.border_dim },
		WinSeparator = { fg = c.border_dim },
		FloatBorder  = { fg = c.border, bg = c.bg1 },

		Folded     = { fg = c.gray2, bg = c.bg1 },
		FoldColumn = { fg = c.gray1, bg = c.bg2 },

		DiffAdd    = { fg = c.git_add,    bg = c.bg1 },
		DiffChange = { fg = c.git_change, bg = c.bg1 },
		DiffDelete = { fg = c.git_delete, bg = c.bg1 },
		DiffText   = { fg = c.fg_bright,  bg = c.bg3, bold = true },

		SpellBad   = { sp = c.error,   undercurl = true },
		SpellCap   = { sp = c.warning, undercurl = true },
		SpellLocal = { sp = c.info,    undercurl = true },
		SpellRare  = { sp = c.purple,  undercurl = true },

		ErrorMsg   = { fg = c.error,   bold = true },
		WarningMsg = { fg = c.warning, bold = true },
		ModeMsg    = { fg = c.blue,    bold = true },
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
		Exception   = { fg = c.maroon  },

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
		SpecialChar    = { fg = c.pink    },
		Tag            = { fg = c.orange  },
		Delimiter      = { fg = c.fg_dim  },
		SpecialComment = { fg = c.flamingo, italic = true },
		Debug          = { fg = c.maroon  },

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

		["@lsp.type.class"]         = { fg = c.type    },
		["@lsp.type.decorator"]     = { fg = c.purple  },
		["@lsp.type.enum"]          = { fg = c.type    },
		["@lsp.type.enumMember"]    = { fg = c.constant },
		["@lsp.type.function"]      = { fg = c.func, bold = true },
		["@lsp.type.interface"]     = { fg = c.type    },
		["@lsp.type.macro"]         = { fg = c.purple  },
		["@lsp.type.method"]        = { fg = c.func    },
		["@lsp.type.namespace"]     = { fg = c.type    },
		["@lsp.type.parameter"]     = { fg = c.variable },
		["@lsp.type.property"]      = { fg = c.variable },
		["@lsp.type.struct"]        = { fg = c.type    },
		["@lsp.type.type"]          = { fg = c.type    },
		["@lsp.type.typeParameter"] = { fg = c.type    },
		["@lsp.type.variable"]      = { fg = c.variable },

		-- ── Treesitter ─────────────────────────────────────────────────────
		["@variable"]           = { fg = c.variable },
		["@variable.builtin"]   = { fg = c.red      },
		["@variable.parameter"] = { fg = c.variable },
		["@variable.member"]    = { fg = c.variable },

		["@constant"]         = { fg = c.constant },
		["@constant.builtin"] = { fg = c.constant },
		["@constant.macro"]   = { fg = c.purple   },

		["@string"]        = { fg = c.string },
		["@string.escape"] = { fg = c.pink   },
		["@string.regexp"] = { fg = c.pink   },

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
		["@keyword.exception"]   = { fg = c.maroon   },

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

		["@tag"]           = { fg = c.orange  },
		["@tag.attribute"] = { fg = c.purple  },
		["@tag.delimiter"] = { fg = c.fg_dim  },

		-- ── Git ────────────────────────────────────────────────────────────
		GitSignsAdd    = { fg = c.git_add    },
		GitSignsChange = { fg = c.git_change },
		GitSignsDelete = { fg = c.git_delete },

		-- ── Telescope ──────────────────────────────────────────────────────
		TelescopeBorder        = { fg = c.border     },
		TelescopePromptBorder  = { fg = c.blue       },
		TelescopeResultsBorder = { fg = c.border_dim },
		TelescopePreviewBorder = { fg = c.border_dim },
		TelescopeSelection     = { fg = c.fg_bright, bg = c.bg3, bold = true },
		TelescopeMatching      = { fg = c.blue, bold = true },

		-- ── Neo-tree ───────────────────────────────────────────────────────
		NeoTreeNormal         = { fg = c.fg,   bg = c.bg0 },
		NeoTreeNormalNC       = { fg = c.fg,   bg = c.bg0 },
		NeoTreeRootName       = { fg = c.blue, bold = true },
		NeoTreeFileName       = { fg = c.fg   },
		NeoTreeFileNameOpened = { fg = c.blue },
		NeoTreeGitAdded       = { fg = c.git_add      },
		NeoTreeGitModified    = { fg = c.git_change   },
		NeoTreeGitDeleted     = { fg = c.git_delete   },
		NeoTreeGitConflict    = { fg = c.git_conflict },
		NeoTreeIndentMarker   = { fg = c.gray1        },

		-- ── Which-key ──────────────────────────────────────────────────────
		WhichKey          = { fg = c.blue   },
		WhichKeyGroup     = { fg = c.purple },
		WhichKeyDesc      = { fg = c.fg     },
		WhichKeySeparator = { fg = c.gray1  },
		WhichKeyFloat     = { bg = c.bg1    },

		-- ── Completion ─────────────────────────────────────────────────────
		CmpItemAbbrMatch      = { fg = c.blue, bold = true },
		CmpItemAbbrMatchFuzzy = { fg = c.blue },
		CmpItemKindFunction   = { fg = c.func     },
		CmpItemKindMethod     = { fg = c.func     },
		CmpItemKindVariable   = { fg = c.variable },
		CmpItemKindKeyword    = { fg = c.keyword  },
		CmpItemKindText       = { fg = c.fg       },
		CmpItemKindClass      = { fg = c.type     },
		CmpItemKindInterface  = { fg = c.type     },

		-- ── Indent blankline ───────────────────────────────────────────────
		IndentBlanklineChar        = { fg = c.bg3  },
		IndentBlanklineContextChar = { fg = c.blue },

		-- ── Dashboard ──────────────────────────────────────────────────────
		DashboardHeader   = { fg = c.blue   },
		DashboardCenter   = { fg = c.teal   },
		DashboardShortCut = { fg = c.purple },
		DashboardFooter   = { fg = c.flamingo, italic = true },

		-- ── Notify ─────────────────────────────────────────────────────────
		NotifyBackground  = { bg = c.bg2   },
		NotifyERRORBorder = { fg = c.error  },
		NotifyWARNBorder  = { fg = c.warning },
		NotifyINFOBorder  = { fg = c.info   },
		NotifyDEBUGBorder = { fg = c.purple },
		NotifyTRACEBorder = { fg = c.pink   },

		-- ── Flash ──────────────────────────────────────────────────────────
		FlashLabel   = { fg = c.bg0,  bg = c.blue, bold = true },
		FlashMatch   = { fg = c.blue  },
		FlashCurrent = { fg = c.red,  bold = true },

		-- ── Snacks ─────────────────────────────────────────────────────────
		SnacksNotifierBorderInfo  = { fg = c.info    },
		SnacksNotifierBorderWarn  = { fg = c.warning },
		SnacksNotifierBorderError = { fg = c.error   },
		SnacksNotifierBorderDebug = { fg = c.purple  },
		SnacksNotifierBorderTrace = { fg = c.pink    },
	}

	for group, settings in pairs(highlights) do
		vim.api.nvim_set_hl(0, group, settings)
	end
end

return M
