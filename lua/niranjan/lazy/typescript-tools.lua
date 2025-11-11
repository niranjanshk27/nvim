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
        tsserver_file_preferences = {
          includeInlayParameterNameHints = "all",
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
        },
      },
    })
  end,
}
