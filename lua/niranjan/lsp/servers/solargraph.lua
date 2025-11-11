return {
  settings = {
    solargraph = {
      diagnostics = true,
      completion = true,
      hover = true,
      signatureHelp = true,
      definitions = true,
      references = true,
      symbols = true,
      folding = true,
      autoformat = false,
      logLevel = "warn",
      useBundler = true,
      bundlerPath = "bundle",
      checkGemVersion = false,
      commandPath = "solargraph",
      pathMethods = true,
      completion = {
        workspaceSymbols = true,
        workspaceSymbolsLimit = 100,
      },
      hover = {
        border = "rounded",
      },
    }
  }
}
