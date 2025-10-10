local schemastore = require("schemastore")

return {
  filetypes = { "json", "jsonc" },
  settings = {
    json = {
      schemas = schemastore.json.schemas(),
      validate = { enable = true },
    },
  },
}
