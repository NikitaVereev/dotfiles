-- ================================================================================================
-- TITLE  : bufferline.nvim
-- ABOUT  : A snazzy buffer line for Neovim (like tabs in WebStorm)
-- LINKS  : https://github.com/akinsho/bufferline.nvim
-- ================================================================================================

return {
  "akinsho/bufferline.nvim",
  version = "*",
  dependencies = "nvim-tree/nvim-web-devicons",
  event = "VeryLazy",
  
  config = function()
    require("bufferline").setup({
      options = {
        mode = "buffers", -- Показывать буферы (файлы)
        themable = true,
        numbers = "none", -- "none" | "ordinal" | "buffer_id" | "both"
        
        -- Кликабельность
        close_command = "bdelete! %d",
        right_mouse_command = "bdelete! %d",
        left_mouse_command = "buffer %d",
        middle_mouse_command = nil,
        
        -- Индикаторы
        indicator = {
          icon = '▎',
          style = 'icon', -- 'icon' | 'underline' | 'none'
        },
        buffer_close_icon = '󰅖',
        modified_icon = '●',
        close_icon = '',
        left_trunc_marker = '',
        right_trunc_marker = '',
        
        -- Отступ для nvim-tree
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            text_align = "center",
            separator = true,
          }
        },
        
        -- Разделители
        separator_style = "thin", -- "slant" | "slope" | "thick" | "thin" | { 'any', 'any' }
        
        -- Группировка
        groups = {
          options = {
            toggle_hidden_on_enter = true,
          },
          items = {
            require('bufferline.groups').builtin.pinned:with({ icon = "" }),
          }
        },
        
        -- Диагностика
        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(count, level, diagnostics_dict, context)
          local icon = level:match("error") and " " or " "
          return " " .. icon .. count
        end,
        
        -- Показывать только буферы текущей директории
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = false,
        show_tab_indicators = true,
        show_duplicate_prefix = true,
        persist_buffer_sort = true,
        
        -- Сортировка
        sort_by = 'insert_after_current',
        
        -- Всегда показывать tabline
        always_show_bufferline = true,
      },
    })
  end,
  
  keys = {
    -- Навигация между буферами
    { "<leader>bp", "<cmd>BufferLineCyclePrev<CR>", desc = "Previous buffer" },
    { "<leader>bn", "<cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
    
    -- Переместить буфер
    { "<leader>bm", "<cmd>BufferLineMoveNext<CR>", desc = "Move buffer next" },
    { "<leader>bM", "<cmd>BufferLineMovePrev<CR>", desc = "Move buffer prev" },
    
    -- Перейти к буферу по номеру
    { "<leader>1", "<cmd>BufferLineGoToBuffer 1<CR>", desc = "Go to buffer 1" },
    { "<leader>2", "<cmd>BufferLineGoToBuffer 2<CR>", desc = "Go to buffer 2" },
    { "<leader>3", "<cmd>BufferLineGoToBuffer 3<CR>", desc = "Go to buffer 3" },
    { "<leader>4", "<cmd>BufferLineGoToBuffer 4<CR>", desc = "Go to buffer 4" },
    { "<leader>5", "<cmd>BufferLineGoToBuffer 5<CR>", desc = "Go to buffer 5" },
    { "<leader>6", "<cmd>BufferLineGoToBuffer 6<CR>", desc = "Go to buffer 6" },
    { "<leader>7", "<cmd>BufferLineGoToBuffer 7<CR>", desc = "Go to buffer 7" },
    { "<leader>8", "<cmd>BufferLineGoToBuffer 8<CR>", desc = "Go to buffer 8" },
    { "<leader>9", "<cmd>BufferLineGoToBuffer 9<CR>", desc = "Go to buffer 9" },
    
    -- Закрыть буферы
    { "<leader>bc", "<cmd>bdelete<CR>", desc = "Close current buffer" },
    { "<leader>bC", "<cmd>BufferLineCloseOthers<CR>", desc = "Close other buffers" },
    { "<leader>bl", "<cmd>BufferLineCloseLeft<CR>", desc = "Close buffers to the left" },
    { "<leader>br", "<cmd>BufferLineCloseRight<CR>", desc = "Close buffers to the right" },
    
    -- Закрепить буфер (pin)
    { "<leader>bP", "<cmd>BufferLineTogglePin<CR>", desc = "Pin/unpin buffer" },
    
    -- Выбрать буфер для закрытия
    { "<leader>bd", "<cmd>BufferLinePickClose<CR>", desc = "Pick buffer to close" },
    { "<leader>bb", "<cmd>BufferLinePick<CR>", desc = "Pick buffer" },
  },
}

