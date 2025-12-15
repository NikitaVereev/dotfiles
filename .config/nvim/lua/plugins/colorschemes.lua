return {
  "sainnhe/everforest",
  lazy = false,
  priority = 1000,
  config = function()
    vim.g.everforest_background = "medium"
    vim.g.everforest_better_performance = 1
    vim.cmd("colorscheme everforest")
    
    -- === ФИКС ТУСКЛОСТИ В SNACKS ===
    -- Яркие цвета для untracked/ignored файлов
    vim.api.nvim_set_hl(0, "SnacksPickerGitStatusUntracked", { 
      fg = "#d3c6aa",  -- основной цвет текста everforest
      bg = "NONE" 
    })
    
    -- На всякий случай переопределим и базовый NonText
    vim.api.nvim_set_hl(0, "NonText", { 
      fg = "#859289"  -- чуть тусклее, но не сильно
    })
  end,
}

