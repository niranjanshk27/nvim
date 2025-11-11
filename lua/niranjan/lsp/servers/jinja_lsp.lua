return {
  cmd = { "jinja-lsp" },
  filetypes = { "jinja", "jinja2", "j2", "html.jinja", "htmldjango", "html.j2" },
  -- root_dir = lspconfig.util.root_pattern(".git", "templates", "template"),
  single_file_support = true,
  settings = {
    jinja = {
      highlight = {
        enabled = true,
      },
      completion = {
        enabled = true,
        customFunctions = {},
        customFilters = {},
      },
      hover = {
        enabled = true,
      },
      diagnostics = {
        enabled = true,
      },
      templates = {
        paths = { "templates/", "template/", "./", "src/templates/" },
      },
    },
  },
}
