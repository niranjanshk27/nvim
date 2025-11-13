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
    "*playbook*.yaml",
    "*/roles/*/tasks/*.yml",
    "*/roles/*/tasks/*.yaml",
    "*/roles/*/handlers/*.yml",
    "*/roles/*/handlers/*.yaml",
    "*/group_vars/*",
    "*/host_vars/*",
    "site.yml",
    "site.yaml",
    "main.yml",
    "main.yaml"
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
    "*.html.jinja",
    "*.html.j2",
    "*/templates/*.html",
    "*/template/*.html",
  },
  callback = function()
    local filename = vim.fn.expand("%:t")
    if filename:match("%.html%.jinja$") or filename:match("%.html%.j2$") then
      vim.bo.filetype = "htmldjango"
    elseif filename:match("%.html$") and (vim.fn.expand("%:p"):match("/templates/") or vim.fn.expand("%:p"):match("/template/")) then
      vim.bo.filetype = "htmldjango"
    else
      vim.bo.filetype = "jinja"
    end
  end,
})

-- GitHub Actions workflow detection
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = {
    ".github/workflows/*.yml",
    ".github/workflows/*.yaml",
  },
  callback = function()
    vim.bo.filetype = "yaml.github"
  end,
})
