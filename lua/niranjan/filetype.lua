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