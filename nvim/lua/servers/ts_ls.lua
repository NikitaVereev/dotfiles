-- ================================================================================================
-- TITLE : ts_ls (TypeScript Language Server) LSP Setup
-- LINKS :
--   > github: https://github.com/typescript-language-server/typescript-language-server
-- ================================================================================================

--- @param capabilities table LSP client capabilities (typically from nvim-cmp or similar)
--- @return nil
return function(capabilities)
  vim.lsp.config('ts_ls', {
    capabilities = capabilities,
    
    filetypes = {
      "typescript",
      "javascript",
      "typescriptreact",
      "javascriptreact",
    },
    
    -- Основные настройки
    init_options = {
      hostInfo = "Neovim",
      maxTsServerMemory = 4096, -- 4GB для больших проектов
      
      preferences = {
        -- Автодополнение и импорты
        includeCompletionsForModuleExports = true,
        includeCompletionsForImportStatements = true,
        includeCompletionsWithSnippetText = true,
        includeCompletionsWithInsertText = true,
        includeAutomaticOptionalChainCompletions = true,
        includeCompletionsWithClassMemberSnippets = true,
        includeCompletionsWithObjectLiteralMethodSnippets = true,
        allowIncompleteCompletions = true,
        
        -- Стиль кода
        quotePreference = "auto", -- или 'single'/'double' по вашему выбору
        importModuleSpecifierPreference = "shortest",
        importModuleSpecifierEnding = "auto",
        
        -- JSX
        jsxAttributeCompletionStyle = "auto",
        
        -- Inlay Hints (подсказки типов прямо в коде)
        includeInlayParameterNameHints = "literals", -- 'none', 'literals' или 'all'
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayVariableTypeHintsWhenTypeMatchesName = false,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
        
        -- Организация импортов
        organizeImportsIgnoreCase = "auto",
        organizeImportsCollation = "ordinal",
        
        -- Рефакторинг и переименование
        allowRenameOfImportPath = true,
        providePrefixAndSuffixTextForRename = true,
        provideRefactorNotApplicableReason = true,
        
        -- Auto-imports из package.json
        includePackageJsonAutoImports = "auto",
      },
      
      -- Настройки tsserver процесса
      tsserver = {
        -- Логирование (оставьте 'off' для production)
        logVerbosity = "off", -- 'off', 'terse', 'normal', 'verbose'
        trace = "off", -- 'off', 'messages', 'verbose'
        
        -- Использовать отдельный syntax server для ускорения
        useSyntaxServer = "auto",
      },
    },
    
    -- Настройки форматирования
    settings = {
      typescript = {
        inlayHints = {
          includeInlayParameterNameHints = "literals",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
        
        -- Code Lens (показывает количество ссылок/реализаций)
        implementationsCodeLens = {
          enabled = true,
        },
        referencesCodeLens = {
          enabled = true,
          showOnAllFunctions = true,
        },
        
        format = {
          indentSize = 2,
          convertTabsToSpaces = true,
          insertSpaceAfterCommaDelimiter = true,
          insertSpaceAfterConstructor = false,
          insertSpaceAfterFunctionKeywordForAnonymousFunctions = true,
          insertSpaceAfterKeywordsInControlFlowStatements = true,
          insertSpaceBeforeAndAfterBinaryOperators = true,
          insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = true,
          insertSpaceAfterOpeningAndBeforeClosingJsxExpressionBraces = false,
          semicolons = "insert", -- 'ignore', 'insert', 'remove'
        },
      },
      
      javascript = {
        inlayHints = {
          includeInlayParameterNameHints = "literals",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
        
        format = {
          indentSize = 2,
          convertTabsToSpaces = true,
        },
      },
      
      -- Автоматическая организация импортов при сохранении
      completions = {
        completeFunctionCalls = true, -- Автодополнение с параметрами функций
      },
    },
    
    -- Code Actions при сохранении
    on_attach = function(client, bufnr)
      -- Keybindings для навигации
  local opts = { buffer = bufnr, silent = true }
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  
  -- Автоматическая синхронизация с nvim-tree при переходе к файлу
  vim.api.nvim_create_autocmd("BufEnter", {
    buffer = bufnr,
    callback = function()
      -- Найти и раскрыть файл в nvim-tree
      require("nvim-tree.api").tree.find_file(vim.api.nvim_buf_get_name(0))
    end,
  })      -- Автоформатирование и организация импортов при сохранении
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.code_action({
            context = {
              only = { "source.organizeImports.ts" },
              diagnostics = {},
            },
            apply = true,
          })
        end,
      })
    end,
  })
end

