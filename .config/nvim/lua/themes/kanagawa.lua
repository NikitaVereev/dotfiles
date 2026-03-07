-- ═══════════════════════════════════════════════════════════════════════════
-- KANAGAWA WAVE — Light / Woodblock Print
-- Katsushika Hokusai, "The Great Wave off Kanagawa", 1831
-- Warm cream sky · prussian blue waves · ochre highlights
-- ═══════════════════════════════════════════════════════════════════════════
--
-- Contrast ratios against main bg (#F4EAD0, L≈0.818):
--   fg     #1A3A5C  → ~10.2:1   keywords  #8B2A2A  → ~7.1:1
--   func   #1A5C78  → ~6.1:1    string    #3D6B3D  → ~5.4:1
--   type   #2E5F8A  → ~5.6:1    constant  #8A5A20  → ~4.8:1
--   number #7A3048  → ~7.6:1    comment   #7A6A58  → ~4.3:1
--   LineNr #706050  → ~4.7:1
--
-- ═══════════════════════════════════════════════════════════════════════════

local M = {}

M.colors = {
	-- ── Backgrounds (sandy cream, darkest → lightest) ──────────────────────
	-- bg0 (darkest sand) used for sidebar/neotree contrast
	bg0 = "#E2D4B0", -- deep sand    — sidebar, neotree
	bg1 = "#F4EAD0", -- main cream   — editor background
	bg2 = "#EDE3C6", -- warm cream   — floats, popups
	bg3 = "#E4D8BA", -- mid sand     — cursorline
	bg4 = "#D8CCA8", -- dark sand    — visual mode

	-- ── Foregrounds (prussian blue hierarchy) ──────────────────────────────
	fg        = "#1A3A5C", -- deep prussian blue   ~10.2:1
	fg_dim    = "#2E5F8A", -- medium prussian blue  ~5.6:1
	fg_bright = "#0D2540", -- darkest ink          ~12.1:1
	fg_muted  = "#706050", -- warm brown-gray       ~4.7:1

	-- ── Reds — vermillion lacquer ───────────────────────────────────────────
	red        = "#A03030", -- vermillion lacquer  ~7.3:1
	red_bright = "#C83838", -- brighter vermillion ~6.4:1

	-- ── Ochre / Gold — wave highlights ─────────────────────────────────────
	amber  = "#906010", -- true ochre gold     ~5.2:1
	yellow = "#7A5010", -- deep ochre          ~6.4:1

	-- ── Print-derived accents ───────────────────────────────────────────────
	green  = "#2A6030", -- pine shore          ~5.8:1
	teal   = "#1A6878", -- rich prussian teal  ~4.8:1
	blue   = "#1A4A90", -- rich prussian blue  ~7.0:1
	indigo = "#6A2088", -- deep indigo         ~9.7:1
	rose   = "#8B2A4A", -- deep rose           ~7.8:1
	brown  = "#5A3A20", -- dark wood brown     ~8.7:1

	-- ── Grays — warm, sandy ─────────────────────────────────────────────────
	comment = "#7A6A58", -- warm gray comments  ~4.3:1
	gray0   = "#B0A090", -- light warm gray     (bg decorations only)
	gray1   = "#706050", -- LineNr, secondary   ~4.7:1
	gray2   = "#5A4A38", -- darker warm gray    ~7.0:1

	-- ── Semantic ───────────────────────────────────────────────────────────
	success = "#2A6030",
	warning = "#906010",
	error   = "#A03030",
	info    = "#1A4A90",

	-- ── Git ────────────────────────────────────────────────────────────────
	git_add      = "#2A6030",
	git_change   = "#906010",
	git_delete   = "#A03030",
	git_conflict = "#C83838",

	-- ── Diagnostics ────────────────────────────────────────────────────────
	diagnostic_error = "#A03030",
	diagnostic_warn  = "#906010",
	diagnostic_info  = "#1A4A90",
	diagnostic_hint  = "#1A6878",

	-- ── UI ─────────────────────────────────────────────────────────────────
	cursor     = "#C8882A",
	cursor_bg  = "#F4EAD0",
	line       = "#E4D8BA",
	visual     = "#C8D8E8", -- pale wave blue — selection echoes the print
	selection  = "#B8CCE0",
	border     = "#8A7A68",
	border_dim = "#B0A090",

	-- ── Syntax ─────────────────────────────────────────────────────────────
	constant = "#906010", -- true ochre      ~5.2:1
	string   = "#2A6030", -- pine green      ~5.8:1
	func     = "#1A6878", -- rich teal       ~4.8:1
	keyword  = "#A03030", -- vermillion red  ~7.3:1
	variable = "#1A3A5C", -- prussian blue   ~10.2:1
	type     = "#1A4A90", -- rich prussian   ~7.0:1
	operator = "#5A3A20", -- dark wood brown ~8.7:1
	number   = "#8B2A4A", -- deep rose       ~7.8:1

	none = "NONE",
}

-- ═══════════════════════════════════════════════════════════════════════════

function M.setup()
	local c = M.colors

	vim.o.background = "light"

	local highlights = {
		-- ── Editor ─────────────────────────────────────────────────────────
		Normal      = { fg = c.fg, bg = c.none },
		NormalFloat = { fg = c.fg, bg = c.bg2  },
		NormalNC    = { fg = c.fg_dim, bg = c.none },

		Cursor       = { fg = c.cursor_bg, bg = c.cursor },
		CursorLine   = { bg = c.line },
		CursorColumn = { bg = c.line },
		ColorColumn  = { bg = c.bg2 },

		LineNr       = { fg = c.gray1 },
		CursorLineNr = { fg = c.amber, bold = true },
		SignColumn   = { fg = c.gray1, bg = c.none },

		Visual    = { bg = c.visual },
		VisualNOS = { bg = c.visual },

		Search    = { fg = c.bg1,  bg = c.blue   },
		IncSearch = { fg = c.bg1,  bg = c.teal   },
		CurSearch = { fg = c.bg1,  bg = c.amber  },

		Pmenu      = { fg = c.fg,        bg = c.bg2 },
		PmenuSel   = { fg = c.bg1,       bg = c.blue, bold = true },
		PmenuSbar  = { bg = c.bg3 },
		PmenuThumb = { bg = c.amber },

		StatusLine   = { fg = c.fg,    bg = c.bg3 },
		StatusLineNC = { fg = c.gray1, bg = c.bg2 },

		TabLine     = { fg = c.gray2,  bg = c.bg3 },
		TabLineSel  = { fg = c.bg1,    bg = c.blue, bold = true },
		TabLineFill = { bg = c.bg2 },

		VertSplit    = { fg = c.border_dim },
		WinSeparator = { fg = c.border_dim },
		FloatBorder  = { fg = c.border, bg = c.bg2 },

		Folded     = { fg = c.gray2, bg = c.bg3 },
		FoldColumn = { fg = c.gray1, bg = c.bg2 },

		DiffAdd    = { bg = "#D0E0D0" },
		DiffChange = { bg = "#E8DCC8" },
		DiffDelete = { bg = "#E8C8C8" },
		DiffText   = { fg = c.fg_bright, bg = c.visual, bold = true },

		SpellBad   = { sp = c.error,   undercurl = true },
		SpellCap   = { sp = c.warning, undercurl = true },
		SpellLocal = { sp = c.info,    undercurl = true },
		SpellRare  = { sp = c.indigo,  undercurl = true },

		ErrorMsg   = { fg = c.error,   bold = true },
		WarningMsg = { fg = c.warning, bold = true },
		ModeMsg    = { fg = c.green,   bold = true },
		MoreMsg    = { fg = c.success, bold = true },
		Question   = { fg = c.teal    },

		NonText = { fg = c.gray1 },
		SnacksPickerGitStatusUntracked = { fg = c.fg_muted, bg = c.none },

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
		Exception   = { fg = c.red_bright },

		PreProc   = { fg = c.indigo },
		Include   = { fg = c.indigo },
		Define    = { fg = c.indigo },
		Macro     = { fg = c.indigo },
		PreCondit = { fg = c.indigo },

		Type         = { fg = c.type    },
		StorageClass = { fg = c.keyword },
		Structure    = { fg = c.type    },
		Typedef      = { fg = c.type    },

		Special        = { fg = c.amber   },
		SpecialChar    = { fg = c.rose    },
		Tag            = { fg = c.amber   },
		Delimiter      = { fg = c.fg_muted },
		SpecialComment = { fg = c.rose, italic = true },
		Debug          = { fg = c.red_bright },

		Underlined = { underline = true },
		Ignore     = { fg = c.gray1 },
		Error      = { fg = c.error, bold = true },
		Todo       = { fg = c.amber, bg = c.bg3, bold = true },

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
		["@lsp.type.decorator"]     = { fg = c.indigo   },
		["@lsp.type.enum"]          = { fg = c.type     },
		["@lsp.type.enumMember"]    = { fg = c.constant },
		["@lsp.type.function"]      = { fg = c.func, bold = true },
		["@lsp.type.interface"]     = { fg = c.type     },
		["@lsp.type.macro"]         = { fg = c.indigo   },
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
		["@variable.builtin"]   = { fg = c.red      },
		["@variable.parameter"] = { fg = c.variable },
		["@variable.member"]    = { fg = c.variable },

		["@constant"]         = { fg = c.constant },
		["@constant.builtin"] = { fg = c.constant },
		["@constant.macro"]   = { fg = c.indigo   },

		["@string"]        = { fg = c.string  },
		["@string.escape"] = { fg = c.amber   },
		["@string.regexp"] = { fg = c.amber   },

		["@character"] = { fg = c.string  },
		["@number"]    = { fg = c.number  },
		["@boolean"]   = { fg = c.constant },
		["@float"]     = { fg = c.number  },

		["@function"]         = { fg = c.func, bold = true },
		["@function.builtin"] = { fg = c.teal   },
		["@function.macro"]   = { fg = c.indigo },
		["@function.call"]    = { fg = c.func   },
		["@method"]           = { fg = c.func   },
		["@method.call"]      = { fg = c.func   },
		["@constructor"]      = { fg = c.type   },

		["@keyword"]             = { fg = c.keyword, bold = true },
		["@keyword.function"]    = { fg = c.keyword  },
		["@keyword.operator"]    = { fg = c.operator },
		["@keyword.return"]      = { fg = c.red_bright },
		["@keyword.conditional"] = { fg = c.keyword  },
		["@keyword.repeat"]      = { fg = c.keyword  },
		["@keyword.exception"]   = { fg = c.red_bright },

		["@operator"] = { fg = c.operator },

		["@type"]            = { fg = c.type },
		["@type.builtin"]    = { fg = c.type },
		["@type.definition"] = { fg = c.type },

		["@punctuation.delimiter"] = { fg = c.fg_muted },
		["@punctuation.bracket"]   = { fg = c.gray2   },
		["@punctuation.special"]   = { fg = c.amber   },

		["@comment"]         = { fg = c.comment, italic = true },
		["@comment.todo"]    = { fg = c.amber,   bg = c.bg3, bold = true },
		["@comment.warning"] = { fg = c.warning, bold = true },
		["@comment.note"]    = { fg = c.info,    bold = true },
		["@comment.error"]   = { fg = c.error,   bold = true },

		["@tag"]           = { fg = c.amber   },
		["@tag.attribute"] = { fg = c.indigo  },
		["@tag.delimiter"] = { fg = c.fg_muted },

		-- ── Git ────────────────────────────────────────────────────────────
		GitSignsAdd    = { fg = c.git_add    },
		GitSignsChange = { fg = c.git_change },
		GitSignsDelete = { fg = c.git_delete },

		-- ── Telescope ──────────────────────────────────────────────────────
		TelescopeBorder        = { fg = c.border     },
		TelescopePromptBorder  = { fg = c.blue       },
		TelescopeResultsBorder = { fg = c.border_dim },
		TelescopePreviewBorder = { fg = c.border_dim },
		TelescopeSelection     = { fg = c.bg1, bg = c.blue, bold = true },
		TelescopeMatching      = { fg = c.amber, bold = true },

		-- ── Neo-tree ───────────────────────────────────────────────────────
		NeoTreeNormal         = { fg = c.fg,    bg = c.bg0 },
		NeoTreeNormalNC       = { fg = c.fg,    bg = c.bg0 },
		NeoTreeRootName       = { fg = c.blue,  bold = true },
		NeoTreeFileName       = { fg = c.fg    },
		NeoTreeFileNameOpened = { fg = c.amber  },
		NeoTreeGitAdded       = { fg = c.git_add      },
		NeoTreeGitModified    = { fg = c.git_change   },
		NeoTreeGitDeleted     = { fg = c.git_delete   },
		NeoTreeGitConflict    = { fg = c.git_conflict },
		NeoTreeIndentMarker   = { fg = c.gray0        },

		-- ── Which-key ──────────────────────────────────────────────────────
		WhichKey          = { fg = c.amber  },
		WhichKeyGroup     = { fg = c.blue   },
		WhichKeyDesc      = { fg = c.fg     },
		WhichKeySeparator = { fg = c.gray1  },
		WhichKeyFloat     = { bg = c.bg3    },

		-- ── Completion ─────────────────────────────────────────────────────
		CmpItemAbbrMatch      = { fg = c.blue, bold = true },
		CmpItemAbbrMatchFuzzy = { fg = c.teal },
		CmpItemKindFunction   = { fg = c.func     },
		CmpItemKindMethod     = { fg = c.func     },
		CmpItemKindVariable   = { fg = c.variable },
		CmpItemKindKeyword    = { fg = c.keyword  },
		CmpItemKindText       = { fg = c.fg       },
		CmpItemKindClass      = { fg = c.type     },
		CmpItemKindInterface  = { fg = c.type     },

		-- ── Indent blankline ───────────────────────────────────────────────
		IndentBlanklineChar        = { fg = c.bg4   },
		IndentBlanklineContextChar = { fg = c.teal  },

		-- ── Dashboard ──────────────────────────────────────────────────────
		DashboardHeader   = { fg = c.blue,  bold = true },
		DashboardCenter   = { fg = c.teal   },
		DashboardShortCut = { fg = c.amber  },
		DashboardFooter   = { fg = c.green, italic = true },

		-- ── Notify ─────────────────────────────────────────────────────────
		NotifyBackground  = { bg = c.bg2   },
		NotifyERRORBorder = { fg = c.error  },
		NotifyWARNBorder  = { fg = c.warning },
		NotifyINFOBorder  = { fg = c.info   },
		NotifyDEBUGBorder = { fg = c.indigo },
		NotifyTRACEBorder = { fg = c.rose   },

		-- ── Flash ──────────────────────────────────────────────────────────
		FlashLabel   = { fg = c.bg1,  bg = c.blue, bold = true },
		FlashMatch   = { fg = c.blue  },
		FlashCurrent = { fg = c.red,  bold = true },

		-- ── Snacks ─────────────────────────────────────────────────────────
		SnacksNotifierBorderInfo  = { fg = c.info   },
		SnacksNotifierBorderWarn  = { fg = c.warning },
		SnacksNotifierBorderError = { fg = c.error  },
		SnacksNotifierBorderDebug = { fg = c.indigo },
		SnacksNotifierBorderTrace = { fg = c.rose   },
	}

	for group, settings in pairs(highlights) do
		vim.api.nvim_set_hl(0, group, settings)
	end
end

return M
