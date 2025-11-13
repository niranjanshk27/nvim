return {
  cmd = { "action-languageserver", "--stdio" },
  filetypes = { "yaml.githun" },
  root_dir = function(fname)
    local lspconfig = require("lspconfig")
    return lspconfig.util.root_pattern(".github/workflows", ".github")(fname)
  end,
  single_file_support = true,
  setting = {},
}
