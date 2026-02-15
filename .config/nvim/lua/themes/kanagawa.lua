-- ═══════════════════════════════════════════════════════════════════════════
-- KANAGAWA WAVE THEME FOR NEOVIM
-- Katsushika Hokusai — "The Great Wave off Kanagawa", 1831
-- Palette derived directly from the woodblock print
-- ═══════════════════════════════════════════════════════════════════════════

local M = {}

-- ═══════════════════════════════════════════════════════════════════════════
-- COLOR PALETTE
-- ═══════════════════════════════════════════════════════════════════════════

M.colors = {
    -- Backgrounds — layers of the cream/ochre sky
    bg0 = "#E8DAB8", -- darkest sand
    bg1 = "#F2E6C8", -- main cream sky
    bg2 = "#EAD9B5", -- slightly darker sand
    bg3 = "#D6C9A8", -- mid sand
    bg4 = "#C4B490", -- dark sand / paper edge

    -- Foregrounds — prussian blue hierarchy
    fg = "#1A3A5C",        -- deep prussian blue (main text)
    fg_dim = "#2E5F8A",    -- medium blue
    fg_bright = "#0D2540", -- darkest ink blue
    fg_muted = "#706050",  -- warm brown-gray

    -- Primary accents from the print
    red = "#8B2A2A",        -- dark red (boat lacquer)
    red_bright = "#B83232", -- brighter red
    red_dim = "#E8C8C8",    -- pale red bg

    orange = "#C8882A",     -- ochre/gold (wave highlight)
    orange_bright = "#D9A845",
    orange_dim = "#EAD9B5",

    pink = "#B86070", -- muted rose (distant foam)
    pink_bright = "#C87080",
    pink_dim = "#E8D0D4",

    -- Additional tones
    yellow = "#D9A845",  -- warm gold
    gold = "#C8882A",    -- deeper ochre

    green = "#3D6B3D",   -- dark pine (distant shore)
    aqua = "#3A7AA8",    -- mid prussian blue
    blue = "#1A3A5C",    -- deep prussian blue

    purple = "#4A3728",  -- dark brown (boat wood)
    magenta = "#6B4A5A", -- muted purple-brown

    -- Sandy neutral tones
    gray0 = "#A09480", -- warm mid gray
    gray1 = "#8A7A68", -- darker warm gray
    gray2 = "#706050", -- brown-gray
    gray3 = "#C4B490", -- light sand

    -- Semantic colors
    success = "#3D6B3D", -- pine green
    warning = "#C8882A", -- ochre
    error = "#8B2A2A",   -- deep red
    info = "#2E5F8A",    -- medium blue

    -- UI elements
    cursor = "#C8882A",     -- ochre cursor
    cursor_bg = "#F2E6C8",
    line = "#EAD9B5",       -- subtle line highlight
    visual = "#C8D8E8",     -- pale blue selection
    selection = "#A8C0D4",  -- deeper blue selection

    border = "#A09480",     -- warm gray border
    border_dim = "#C4B490", -- light sand border

    -- Syntax
    comment = "#A09480",  -- muted warm gray
    constant = "#C8882A", -- ochre
    string = "#3D6B3D",   -- pine green
    func = "#1A3A5C",     -- deep blue
    keyword = "#0D2540",  -- darkest ink (bold keywords)
    variable = "#1A3A5C", -- prussian blue
    type = "#2E5F8A",     -- medium blue
    operator = "#4A3728", -- dark wood brown
    number = "#B86070",   -- muted rose

    -- Git
    git_add = "#3D6B3D",
    git_change = "#C8882A",
    git_delete = "#8B2A2A",
    git_conflict = "#B83232",

    -- Diagnostics
    diagnostic_error = "#8B2A2A",
    diagnostic_warn = "#C8882A",
    diagnostic_info = "#2E5F8A",
    diagnostic_hint = "#3A7AA8",

    -- Special
    none = "NONE",
}

-- ═══════════════════════════════════════════════════════════════════════════
-- HIGHLIGHT GROUPS
-- ═══════════════════════════════════════════════════════════════════════════

function M.setup()
    local c = M.colors

    -- Set light background
    vim.o.background = "light"

    local highlights = {
        -- ═══════════════════════════════════════════════════════════════════
        -- EDITOR
        -- ═══════════════════════════════════════════════════════════════════
        Normal = { fg = c.fg, bg = c.none },
        NormalFloat = { fg = c.fg, bg = c.none },
        NormalNC = { fg = c.fg_dim, bg = c.none },

        -- Cursor
        Cursor = { fg = c.cursor_bg, bg = c.cursor },
        CursorLine = { bg = c.line },
        CursorColumn = { bg = c.line },
        ColorColumn = { bg = c.bg2 },

        -- Line numbers
        LineNr = { fg = c.gray0 },
        CursorLineNr = { fg = c.orange, bold = true },
        SignColumn = { fg = c.gray0, bg = c.none },

        -- Visual mode
        Visual = { bg = c.visual },
        VisualNOS = { bg = c.visual },

        -- Search
        Search = { fg = c.bg1, bg = c.blue },
        IncSearch = { fg = c.bg1, bg = c.aqua },
        CurSearch = { fg = c.bg1, bg = c.orange },

        -- Popup menu
        Pmenu = { fg = c.fg, bg = c.bg3 },
        PmenuSel = { fg = c.bg1, bg = c.blue, bold = true },
        PmenuSbar = { bg = c.bg4 },
        PmenuThumb = { bg = c.aqua },

        -- Statusline
        StatusLine = { fg = c.fg, bg = c.bg3 },
        StatusLineNC = { fg = c.gray0, bg = c.bg2 },

        -- Tabline
        TabLine = { fg = c.gray1, bg = c.bg3 },
        TabLineSel = { fg = c.bg1, bg = c.blue, bold = true },
        TabLineFill = { bg = c.bg2 },

        -- Windows
        VertSplit = { fg = c.border_dim },
        WinSeparator = { fg = c.border_dim },
        FloatBorder = { fg = c.border, bg = c.bg2 },

        -- Folds
        Folded = { fg = c.gray1, bg = c.bg3 },
        FoldColumn = { fg = c.gray0, bg = c.bg2 },

        -- Diff
        DiffAdd = { bg = "#D0E0D0" },
        DiffChange = { bg = "#E8DCC8" },
        DiffDelete = { bg = "#E8C8C8" },
        DiffText = { fg = c.fg_bright, bg = "#C8D8E8", bold = true },

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
        NonText = { fg = c.gray3 },
        SnacksPickerGitStatusUntracked = { fg = c.fg_muted, bg = c.none },

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
        Delimiter = { fg = c.fg_muted },
        SpecialComment = { fg = c.pink, italic = true },
        Debug = { fg = c.red_bright },

        Underlined = { underline = true },
        Ignore = { fg = c.gray0 },
        Error = { fg = c.error, bold = true },
        Todo = { fg = c.orange, bg = c.bg3, bold = true },

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
        ["@function.builtin"] = { fg = c.aqua },
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

        ["@punctuation.delimiter"] = { fg = c.fg_muted },
        ["@punctuation.bracket"] = { fg = c.gray2 },
        ["@punctuation.special"] = { fg = c.orange },

        ["@comment"] = { fg = c.comment, italic = true },
        ["@comment.todo"] = { fg = c.orange, bg = c.bg3, bold = true },
        ["@comment.warning"] = { fg = c.warning, bold = true },
        ["@comment.note"] = { fg = c.info, bold = true },
        ["@comment.error"] = { fg = c.error, bold = true },

        ["@tag"] = { fg = c.orange },
        ["@tag.attribute"] = { fg = c.purple },
        ["@tag.delimiter"] = { fg = c.fg_muted },

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
        TelescopePromptBorder = { fg = c.blue },
        TelescopeResultsBorder = { fg = c.border_dim },
        TelescopePreviewBorder = { fg = c.border_dim },
        TelescopeSelection = { fg = c.bg1, bg = c.blue, bold = true },
        TelescopeMatching = { fg = c.orange, bold = true },

        -- NeoTree
        NeoTreeNormal = { fg = c.fg, bg = c.bg0 },
        NeoTreeNormalNC = { fg = c.fg, bg = c.bg0 },
        NeoTreeRootName = { fg = c.blue, bold = true },
        NeoTreeFileName = { fg = c.fg },
        NeoTreeFileNameOpened = { fg = c.orange },
        NeoTreeGitAdded = { fg = c.git_add },
        NeoTreeGitModified = { fg = c.git_change },
        NeoTreeGitDeleted = { fg = c.git_delete },
        NeoTreeGitConflict = { fg = c.git_conflict },
        NeoTreeIndentMarker = { fg = c.gray0 },

        -- Which-key
        WhichKey = { fg = c.orange },
        WhichKeyGroup = { fg = c.blue },
        WhichKeyDesc = { fg = c.fg },
        WhichKeySeparator = { fg = c.gray0 },
        WhichKeyFloat = { bg = c.bg3 },

        -- Cmp (completion)
        CmpItemAbbrMatch = { fg = c.blue, bold = true },
        CmpItemAbbrMatchFuzzy = { fg = c.aqua },
        CmpItemKindFunction = { fg = c.func },
        CmpItemKindMethod = { fg = c.func },
        CmpItemKindVariable = { fg = c.variable },
        CmpItemKindKeyword = { fg = c.keyword },
        CmpItemKindText = { fg = c.fg },
        CmpItemKindClass = { fg = c.type },
        CmpItemKindInterface = { fg = c.type },

        -- Indent Blankline
        IndentBlanklineChar = { fg = c.bg4 },
        IndentBlanklineContextChar = { fg = c.aqua },

        -- Dashboard
        DashboardHeader = { fg = c.blue },
        DashboardCenter = { fg = c.aqua },
        DashboardShortCut = { fg = c.orange },
        DashboardFooter = { fg = c.green, italic = true },

        -- Notify
        NotifyBackground = { bg = c.bg2 },
        NotifyERRORBorder = { fg = c.error },
        NotifyWARNBorder = { fg = c.warning },
        NotifyINFOBorder = { fg = c.info },
        NotifyDEBUGBorder = { fg = c.purple },
        NotifyTRACEBorder = { fg = c.pink },

        -- Flash
        FlashLabel = { fg = c.bg1, bg = c.blue, bold = true },
        FlashMatch = { fg = c.blue },
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
