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
    "stevearc/conform.nvim",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "j-hui/fidget.nvim",
    "rafamadriz/friendly-snippets",
    "onsails/lspkind.nvim",
    "b0o/schemastore.nvim",
    -- Additional performance and feature plugins
    "folke/neodev.nvim", -- better lua development
    "nvim-telescope/telescope.nvim", -- for better LSP references/symbols
    "nvim-tree/nvim-web-devicons", -- icons
    "hrsh7th/cmp-nvim-lsp-signature-help", -- signature help
    "hrsh7th/cmp-nvim-lsp-document-symbol", -- document symbols
  },
  config = function()
    -- Performance: reduce LSP log level
    vim.lsp.set_log_level("error")
    
    -- Performance: set updatetime for faster diagnostics
    vim.opt.updatetime = 250
    
    -- Performance: configure LSP handlers for better performance
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
      vim.lsp.handlers.hover, {
        border = "rounded",
        max_width = 80,
        max_height = 20,
      }
    )
    
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
      vim.lsp.handlers.signature_help, {
        border = "rounded",
        max_width = 80,
        max_height = 15,
      }
    )
    
    -- Enhanced LSP keymaps with more features
    local on_attach = function(client, bufnr)
      local opts = { noremap = true, silent = true, buffer = bufnr }
      
      -- Navigation
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Goto Definition" }))
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Goto Declaration" }))
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Goto Implementation" }))
      vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "Goto Type Definition" }))
      vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "References" }))
      
      -- Information
      vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover Documentation" }))
      vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature Help" }))
      vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature Help" }))
      
      -- Actions
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename Symbol" }))
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code Action" }))
      vim.keymap.set("v", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code Action" }))
      
      -- Diagnostics
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "Previous Diagnostic" }))
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Next Diagnostic" }))
      vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Show Diagnostics" }))
      vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, vim.tbl_extend("force", opts, { desc = "Diagnostic List" }))
      
      -- Workspace
      vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, vim.tbl_extend("force", opts, { desc = "Add Workspace Folder" }))
      vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, vim.tbl_extend("force", opts, { desc = "Remove Workspace Folder" }))
      vim.keymap.set("n", "<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, vim.tbl_extend("force", opts, { desc = "List Workspace Folders" }))
      
      -- Formatting
      vim.keymap.set("n", "<leader>f", function()
        vim.lsp.buf.format({ async = true })
      end, vim.tbl_extend("force", opts, { desc = "Format Document" }))
      
      -- Performance: disable semantic tokens for large files
      if client.server_capabilities.semanticTokensProvider then
        local file_size = vim.fn.getfsize(vim.api.nvim_buf_get_name(bufnr))
        if file_size > 100000 then -- 100KB
          client.server_capabilities.semanticTokensProvider = nil
        end
      end
      
      -- Auto-format on save (optional - uncomment if desired)
      -- if client.server_capabilities.documentFormattingProvider then
      --   vim.api.nvim_create_autocmd("BufWritePre", {
      --     group = vim.api.nvim_create_augroup("LspFormat", {}),
      --     buffer = bufnr,
      --     callback = function()
      --       vim.lsp.buf.format({ async = false })
      --     end,
      --   })
      -- end
    end

    -- Enhanced conform setup with more formatters
    require("conform").setup({
      formatters_by_ft = {
        lua = { "stylua" },
        python = { "black", "isort" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        go = { "gofmt" },
        rust = { "rustfmt" },
        ruby = { "rubocop" },
        terraform = { "terraform_fmt" },
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    })

    -- Setup neodev for better Lua development
    require("neodev").setup({
      library = {
        enabled = true,
        runtime = true,
        types = true,
        plugins = true,
      },
    })

    local cmp = require('cmp')
    local cmp_lsp = require("cmp_nvim_lsp")
    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      cmp_lsp.default_capabilities()
    )

    -- Performance: configure capabilities
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
      properties = { "documentation", "detail", "additionalTextEdits" }
    }

    require("fidget").setup({
      notification = {
        window = {
          winblend = 0,
        },
      },
    })

    require("mason").setup({
      ui = {
        border = "rounded",
      },
    })

    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "rust_analyzer",
        "gopls",
        "ts_ls",
        "pylsp",
        "ruby_lsp",
        "tflint",
        "jsonls",
        "terraformls",
        "yamlls",
        "bashls",
        "cssls",
        "html",
        "marksman", -- markdown
      },
      automatic_installation = true,
      handlers = {
        function(server_name)
          require("lspconfig")[server_name].setup({
            capabilities = capabilities,
            on_attach = on_attach,
          })
        end,
        
        ["lua_ls"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.lua_ls.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
              Lua = {
                completion = {
                  callSnippet = "Replace"
                },
                diagnostics = {
                  globals = { "vim" },
                },
                workspace = {
                  library = vim.api.nvim_get_runtime_file("", true),
                  checkThirdParty = false,
                },
                telemetry = {
                  enable = false,
                },
                format = {
                  enable = true,
                  defaultConfig = {
                    indent_style = "space",
                    indent_size = "2",
                  }
                },
              }
            }
          })
        end,
        
        ["rust_analyzer"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.rust_analyzer.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
              ["rust-analyzer"] = {
                checkOnSave = {
                  command = "clippy"
                },
                imports = {
                  granularity = {
                    group = "module",
                  },
                  prefix = "self",
                },
                cargo = {
                  buildScripts = {
                    enable = true,
                  },
                },
                procMacro = {
                  enable = true
                },
              }
            }
          })
        end,
        
        ["gopls"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.gopls.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
              gopls = {
                analyses = {
                  unusedparams = true,
                },
                staticcheck = true,
                gofumpt = true,
              },
            },
          })
        end,
        
        ["ts_ls"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.ts_ls.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
              typescript = {
                inlayHints = {
                  includeInlayParameterNameHints = 'all',
                  includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                  includeInlayFunctionParameterTypeHints = true,
                  includeInlayVariableTypeHints = true,
                  includeInlayPropertyDeclarationTypeHints = true,
                  includeInlayFunctionLikeReturnTypeHints = true,
                  includeInlayEnumMemberValueHints = true,
                }
              }
            }
          })
        end,
        
        ["pylsp"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.pylsp.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
              pylsp = {
                plugins = {
                  pycodestyle = {
                    ignore = {'W391'},
                    maxLineLength = 100
                  }
                }
              }
            }
          })
        end,
        
        ["ruby_lsp"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.ruby_lsp.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            filetypes = { "ruby", "Fastfile" },
            root_dir = lspconfig.util.root_pattern("Gemfile", ".git", "Fastfile"),
          })
        end,
        
        ["jsonls"] = function()
          local lspconfig = require("lspconfig")
          local schemastore = require("schemastore")
          lspconfig.jsonls.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
              json = {
                schemas = schemastore.json.schemas(),
                validate = { enable = true },
              },
            },
            filetypes = { "json", "jsonc" }
          })
        end,
        
        ["yamlls"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.yamlls.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
              yaml = {
                schemas = {
                  ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] = "/*.k8s.yaml",
                  ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "/*docker-compose*.yml",
                },
              },
            },
          })
        end,
        
        ["zls"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.zls.setup({
            root_dir = lspconfig.util.root_pattern(".git", "build.zig", "zls.json"),
            settings = {
              zls = {
                enable_inlay_hints = true,
                enable_snippets = true,
                warn_style = true,
              },
            },
            capabilities = capabilities,
            on_attach = on_attach
          })
          vim.g.zig_fmt_parse_errors = 0
          vim.g.zig_fmt_autosave = 0
        end,
      }
    })

    local cmp_select = { behavior = cmp.SelectBehavior.Select }
    local luasnip = require("luasnip")
    local lspkind = require("lspkind")

    -- Load snippets
    require("luasnip.loaders.from_vscode").lazy_load()

    -- Enhanced completion setup
    cmp.setup({
      completion = {
        completeopt = "menu,menuone,preview,noselect",
      },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp", priority = 1000 },
        { name = "luasnip", priority = 750 },
        { name = "buffer", priority = 500 },
        { name = "path", priority = 250 },
        { name = "nvim_lsp_signature_help", priority = 200 },
      }),
      formatting = {
        format = lspkind.cmp_format({
          mode = 'symbol_text',
          maxwidth = 50,
          ellipsis_char = '...',
          show_labelDetails = true,
          before = function(entry, vim_item)
            return vim_item
          end
        })
      },
      experimental = {
        ghost_text = {
          hl_group = "LspCodeLens",
        },
      },
    })

    -- Enhanced diagnostic configuration
    vim.diagnostic.config({
      virtual_text = {
        spacing = 4,
        source = "if_many",
        prefix = "●",
      },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "✘",
          [vim.diagnostic.severity.WARN] = "▲",
          [vim.diagnostic.severity.HINT] = "⚑",
          [vim.diagnostic.severity.INFO] = "»",
        },
      },
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
    })

    -- Additional keymaps outside of LSP attach
    vim.keymap.set("n", "<leader>xx", function()
      require("telescope.builtin").diagnostics()
    end, { desc = "Telescope Diagnostics" })

    vim.keymap.set("n", "<leader>fs", function()
      require("telescope.builtin").lsp_document_symbols()
    end, { desc = "Document Symbols" })

    vim.keymap.set("n", "<leader>fS", function()
      require("telescope.builtin").lsp_dynamic_workspace_symbols()
    end, { desc = "Workspace Symbols" })

    -- Performance: auto-command to reduce diagnostics frequency
    vim.api.nvim_create_autocmd("CursorHold", {
      callback = function()
        local opts = {
          focusable = false,
          close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
          border = 'rounded',
          source = 'always',
          prefix = ' ',
          scope = 'cursor',
        }
        vim.diagnostic.open_float(nil, opts)
      end
    })
  end,
}