-- File type configurations
vim.filetype.add({
  filename = {
    ["Fastfile"] = "ruby",
    ["Appfile"] = "ruby",
    ["Matchfile"] = "ruby",
  },
  pattern = {
    [".*%.fastfile$"] = "ruby",
    [".*%.appfile$"] = "ruby",
    [".*%.matchfile$"] = "ruby",
  },
})

-- Ansible filetype detection
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = {
    "*/playbooks/*.yml",
    "*/playbooks/*.yaml",
    "*playbook*.yml",
    "*/roles/*/tasks/*.yml",
  },
  callback = function()
    vim.bo.filetype = "yaml.ansible"
  end,
})

-- Jinja filetype detection
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = {
    "*.jinja",
    "*.jinja2",
    "*.j2",
    "*/templates/*.html",
  },
  callback = function()
    vim.bo.filetype = "jinja"
  end,
})
