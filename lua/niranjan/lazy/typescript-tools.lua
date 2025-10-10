return {
  "pmizio/typescript-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    local capabilities = require("niranjan.lsp").get_capabilities()
    require("typescript-tools").setup({
      capabilities = capabilities,
      settings = {
        -- Add your typescript-tools settings here
        separate_diagnostic_server = true,
        publish_diagnostic_on = "insert_leave",
        expose_as_code_action = "all",
        tsserver_path = nil,
        tsserver_plugins = {},
        tsserver_max_memory = "auto",
        tsserver_format_options = {
          insertSpaceAfterCommaDelimiter = true,
          insertSpaceAfterSemicolonInForStatements = true,
          insertSpaceBeforeAndAfterBinaryOperators = true,
          insertSpaceAfterKeywordsInControlFlowStatements = true,
          insertSpaceAfterFunctionKeywordForAnonymousFunctions = true,
          insertSpaceAfterOpeningAndBeforeClosingNonemptyParenthesis = false,
          insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets = false,
          insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = true,
          insertSpaceAfterOpeningAndBeforeClosingTemplateStringBraces = false,
          insertSpaceAfterOpeningAndBeforeClosingJsxExpressionBraces = false,
          insertSpaceBeforeFunctionParenthesis = false,
          placeOpenBraceOnNewLineForFunctions = false,
          placeOpenBraceOnNewLineForControlBlocks = false,
        },
        tsserver_file_preferences = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayVariableTypeHintsWhenTypeMatchesName = false,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
          importModuleSpecifierPreference = "non-relative",
          quotePreference = "auto",
        },
        tsserver_locale = "en",
        complete_function_calls = false,
        include_completions_with_insert_text = true,
        code_lens = "off",
        disable_member_code_lens = true,
        jsx_close_tag = {
          enable = false,
          filetypes = { "javascriptreact", "typescriptreact" },
        },
      },
    })
  end,
}
