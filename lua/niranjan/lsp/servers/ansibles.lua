return {
  cmd = { "ansible-language-server", "--stdio" },
  filetypes = { "yaml.ansible", "ansible" },
  -- root_dir = lspconfig.util.root_pattern("ansible.cfg", ".ansible-lint", "playbook*.yml", "site.yml", "main.yml", "inventory", "group_vars", "host_vars"),
  single_file_support = true,
  settings = {
    ansible = {
      ansible = {
        path = "ansible",
        useFullyQualifiedCollectionNames = true,
      },
      ansibleLint = {
        enabled = true,
        path = "ansible-lint",
      },
      executionEnvironment = {
        enabled = false,
      },
      python = {
        interpreterPath = "python3",
      },
      validation = {
        enabled = true,
        lint = {
          enabled = true,
        },
      },
      completion = {
        provideRedirectModules = true,
        provideModuleOptionAliases = true,
      },
    },
  },
}
