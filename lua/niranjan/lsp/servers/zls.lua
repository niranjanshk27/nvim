return {
  -- root_dir = lspconfig.util.root_pattern(".git", "build.zig", "zls.json"),
  settings = {
    zls = {
      enable_inlay_hints = true,
      enable_snippets = true,
      warn_style = true,
    },
  },
}
