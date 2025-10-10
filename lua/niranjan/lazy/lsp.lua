local root_files = {
  '.luarc.json',
  '.luarc.jsonc',
  '.luacheckrc',
  '.stylua.toml',
  'stylua.toml',
  'selene.toml',
  'selene.yml',
  '.git',
}

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "j-hui/fidget.nvim",
    "folke/neodev.nvim",
    "b0o/schemastore.nvim",
  },
  config = function()
    require("niranjan.lsp").setup()
    require("fidget").setup({
      notification = {
        window = {
          winblend = 0
        }
      }
    })
    require("neodev").setup({
      library = {
        enabled = true,
        runtime = true,
        types = true,
        plugins = true,
      }
    })
    require("mason").setup({
      ui = {
        border = "rounded"
      }
    })

    local lspconfig = require("lspconfig")
    local mason_lspconfig = require("mason-lspconfig")

    local servers = {
      "lua_ls", "rust_analyzer", "gopls", "pyright", "solargraph", "tflint",
      "jsonls", "terraformls", "yamlls", "bashls", "cssls", "html", "marksman",
      "ansiblels", "jinja_lsp", "dockerls", "zls",
    }

    local lsp_core = require("niranjan.lsp")
    local capabilities = lsp_core.get_capabilities()

    -- Setup handlers should be passed to mason_lspconfig.setup, not called separately
    mason_lspconfig.setup({
      automatic_installation = true,
      ensure_installed = servers,
      handlers = {
        function(server_name)
          local server_opts = {
            capabilities = capabilities,
          }
          -- Get custom server settings from the servers directory
          local success, custom_opts = pcall(require, "niranjan.lsp.servers." .. server_name)
          if success then
            server_opts = vim.tbl_deep_extend("force", server_opts, custom_opts)
          end
          lspconfig[server_name].setup(server_opts)
        end,
      }
    })
  end,
}
