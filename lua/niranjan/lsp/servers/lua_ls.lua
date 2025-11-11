return {
  settings = {
    Lua = {
      completion = { callSnippet = "Replace" },
      diagnostics = { globals = { "vim" } },
      workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
      telemetry = { enable = false },
      format = {
        enable = true,
        defaultConfig = { indent_style = "space", indent_size = "2", }
      },
    },
  },
}
