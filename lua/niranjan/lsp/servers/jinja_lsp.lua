return {
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
