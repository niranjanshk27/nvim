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
    -- Add typescript-tools.nvim
    {
      "pmizio/typescript-tools.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
    },
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
    
    -- MODERN APPROACH: Use LspAttach autocmd instead of on_attach function
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        -- print("LSP attached: " .. client.name .. " to buffer: " .. ev.buf)
        
        local opts = { buffer = ev.buf }
        
        -- Navigation
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Goto Definition" }))
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Goto Declaration" }))
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "Goto Implementation" }))
        vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "Goto Type Definition" }))
        vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "References" }))
        
        -- Information
        vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover Documentation" }))
        vim.keymap.set("n", "<leader>k", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature Help" }))
        
        -- Actions
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename Symbol" }))
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code Action" }))
        vim.keymap.set("v", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code Action" }))
        
        -- Diagnostics
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "Previous Diagnostic" }))
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Next Diagnostic" }))
        vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Show Diagnostics" }))
        vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, vim.tbl_extend("force", opts, { desc = "Diagnostic List" }))

        -- Copy diagnostic message to clipboard
        vim.keymap.set("n", "<leader>yy", function()
          local diagnostics = vim.diagnostic.get(0, { lnum = vim.fn.line('.') - 1 })
          if #diagnostics > 0 then
            local message = diagnostics[1].message
            vim.fn.setreg('+', message)
            print("Copied diagnostic: " .. message)
          else
            print("No diagnostic on current line")
          end
        end, vim.tbl_extend("force", opts, { desc = "Copy Diagnostic Message" }))
        
        -- Workspace
        vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, vim.tbl_extend("force", opts, { desc = "Add Workspace Folder" }))
        vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, vim.tbl_extend("force", opts, { desc = "Remove Workspace Folder" }))
        vim.keymap.set("n", "<leader>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, vim.tbl_extend("force", opts, { desc = "List Workspace Folders" }))
        
        -- Formatting
        vim.keymap.set("n", "<leader>fd", function()
          vim.lsp.buf.format({ async = true })
        end, vim.tbl_extend("force", opts, { desc = "Format Document" }))
        
        -- TypeScript-specific keymaps (only for typescript-tools)
        if client.name == "typescript-tools" then
          vim.keymap.set("n", "<leader>to", "<cmd>TSToolsOrganizeImports<cr>", vim.tbl_extend("force", opts, { desc = "Organize Imports" }))
          vim.keymap.set("n", "<leader>ts", "<cmd>TSToolsSortImports<cr>", vim.tbl_extend("force", opts, { desc = "Sort Imports" }))
          vim.keymap.set("n", "<leader>tu", "<cmd>TSToolsRemoveUnusedImports<cr>", vim.tbl_extend("force", opts, { desc = "Remove Unused Imports" }))
          vim.keymap.set("n", "<leader>ti", "<cmd>TSToolsAddMissingImports<cr>", vim.tbl_extend("force", opts, { desc = "Add Missing Imports" }))
          vim.keymap.set("n", "<leader>tf", "<cmd>TSToolsFixAll<cr>", vim.tbl_extend("force", opts, { desc = "Fix All" }))
          vim.keymap.set("n", "<leader>tg", "<cmd>TSToolsGoToSourceDefinition<cr>", vim.tbl_extend("force", opts, { desc = "Go To Source Definition" }))
          vim.keymap.set("n", "<leader>tr", "<cmd>TSToolsRenameFile<cr>", vim.tbl_extend("force", opts, { desc = "Rename File" }))
          vim.keymap.set("n", "<leader>ta", "<cmd>TSToolsFileReferences<cr>", vim.tbl_extend("force", opts, { desc = "File References" }))
        end
        
        -- Performance: disable semantic tokens for large files
        if client.server_capabilities.semanticTokensProvider then
          local file_size = vim.fn.getfsize(vim.api.nvim_buf_get_name(ev.buf))
          if file_size > 100000 then -- 100KB
            client.server_capabilities.semanticTokensProvider = nil
          end
        end
        
        -- Auto-format on save (optional - uncomment if desired)
        -- if client.server_capabilities.documentFormattingProvider then
        --   vim.api.nvim_create_autocmd("BufWritePre", {
        --     group = vim.api.nvim_create_augroup("LspFormat", {}),
        --     buffer = ev.buf,
        --     callback = function()
        --       vim.lsp.buf.format({ async = false })
        --     end,
        --   })
        -- end
      end,
    })

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
        ansible = { "ansible-lint" },
        jinja = { "djlint" },
        html = { "djlint", "prettier" },
        htmldjango = { "djlint" },
      },
      -- format_on_save = {
      --   timeout_ms = 500,
      --   lsp_fallback = true,
      -- },
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
        -- REMOVED: "ts_ls", -- Using typescript-tools.nvim instead
        "pyright",
        "solargraph",
        "tflint",
        "jsonls",
        "terraformls",
        "yamlls",
        "bashls",
        "cssls",
        "html",
        "marksman",
        "ansiblels",
        "jinja_lsp",
        "dockerls"
      },
      automatic_installation = true,
      handlers = {
        -- Default handler (will be called for servers without specific handlers)
        function(server_name)
          require("lspconfig")[server_name].setup({
            capabilities = capabilities,
          })
        end,
        
        ["lua_ls"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.lua_ls.setup({
            capabilities = capabilities,
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
        
        -- REMOVED: ts_ls handler - Using typescript-tools.nvim instead
        
        ["pyright"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.pyright.setup({
            capabilities = capabilities,
            settings = {
              python = {
                analysis = {
                  autoSearchPaths = true,
                  useLibraryCodeForTypes = true,
                  diagnosticMode = "workspace"
                }
              }
            }
          })
        end,
        
        ["solargraph"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.solargraph.setup({
            capabilities = capabilities,
            cmd = { "solargraph", "stdio" },
            filetypes = { "ruby", "eruby" },
            root_dir = lspconfig.util.root_pattern("Gemfile", ".git"),
            settings = {
              solargraph = {
                diagnostics = true,
                completion = true,
                hover = true,
                signatureHelp = true,
                definitions = true,
                references = true,
                symbols = true,
                folding = true,
                autoformat = false,
                logLevel = "warn",
                useBundler = true,
                bundlerPath = "bundle",
                checkGemVersion = false,
                commandPath = "solargraph",
                pathMethods = true,
                completion = {
                  workspaceSymbols = true,
                  workspaceSymbolsLimit = 100,
                },
                hover = {
                  border = "rounded",
                },
              }
            },
            init_options = {
              formatting = false,
            },
          })
        end,

        ["ansiblels"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.ansiblels.setup({
            capabilities = capabilities,
            cmd = { "ansible-language-server", "--stdio" },
            filetypes = { "yaml.ansible", "ansible" },
            root_dir = lspconfig.util.root_pattern("ansible.cfg", ".ansible-lint", "playbook*.yml", "site.yml", "main.yml", "inventory", "group_vars", "host_vars"),
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
          })
        end,

        ["jinja_lsp"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.jinja_lsp.setup({
            capabilities = capabilities,
            cmd = { "jinja-lsp" },
            filetypes = { "jinja", "jinja2", "j2", "html.jinja", "htmldjango", "html.j2" },
            root_dir = lspconfig.util.root_pattern(".git", "templates", "template"),
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
          })
        end,
        
        ["jsonls"] = function()
          local lspconfig = require("lspconfig")
          local schemastore = require("schemastore")
          lspconfig.jsonls.setup({
            capabilities = capabilities,
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
            settings = {
              yaml = {
                schemas = {
                  kubernetes = "/*.k8s.yaml",
                  ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "/*docker-compose*.yml",
                  ["https://raw.githubusercontent.com/ansible/schemas/main/f/ansible-playbook.json"] = "/*playbook*.yml",
                  ["https://raw.githubusercontent.com/ansible/schemas/main/f/ansible-tasks.json"] = "/tasks/*.yml",
                  ["https://raw.githubusercontent.com/ansible/schemas/main/f/ansible-vars.json"] = "/vars/*.yml",
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
          })
          vim.g.zig_fmt_parse_errors = 0
          vim.g.zig_fmt_autosave = 0
        end,
      }
    })

    -- Setup typescript-tools.nvim (replaces ts_ls)
    require("typescript-tools").setup({
      capabilities = capabilities,
      settings = {
        separate_diagnostic_server = true,
        publish_diagnostic_on = "insert_leave",
        expose_as_code_action = "all",
        tsserver_path = nil,
        tsserver_plugins = {},
        tsserver_max_memory = "auto",
        tsserver_format_options = {
          insertSpaceAfterCommaDelimiter = true,
          insertSpaceAfterSemicolonInForStatements = true,
          insertSpaceBeforeAndAfterBinaryOperators = true,
          insertSpaceAfterKeywordsInControlFlowStatements = true,
          insertSpaceAfterFunctionKeywordForAnonymousFunctions = true,
          insertSpaceAfterOpeningAndBeforeClosingNonemptyParenthesis = false,
          insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets = false,
          insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = true,
          insertSpaceAfterOpeningAndBeforeClosingTemplateStringBraces = false,
          insertSpaceAfterOpeningAndBeforeClosingJsxExpressionBraces = false,
          insertSpaceBeforeFunctionParenthesis = false,
          placeOpenBraceOnNewLineForFunctions = false,
          placeOpenBraceOnNewLineForControlBlocks = false,
        },
        tsserver_file_preferences = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayVariableTypeHintsWhenTypeMatchesName = false,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
          importModuleSpecifierPreference = "non-relative",
          quotePreference = "auto",
        },
        tsserver_locale = "en",
        complete_function_calls = false,
        include_completions_with_insert_text = true,
        code_lens = "off",
        disable_member_code_lens = true,
        jsx_close_tag = {
          enable = false,
          filetypes = { "javascriptreact", "typescriptreact" },
        },
      },
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
        ['<M-Space>'] = cmp.mapping.complete(),
        ['<Esc>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        -- Use <Tab> to select or confirm completion
        -- ["<Tab>"] = cmp.mapping(function(fallback)
        --   if cmp.visible() then
        --     if cmp.get_selected_entry() == nil then
        --       cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
        --     else
        --       cmp.confirm({ select = false })
        --     end
        --   else
        --     fallback()
        --   end
        -- end, { "i", "s" }),

        -- Use <CR> to confirm selection
        -- ["<CR>"] = cmp.mapping(function(fallback)
        --   if cmp.visible() and cmp.get_selected_entry() ~= nil then
        --     cmp.confirm({ select = false })
        --   else
        --     fallback()
        --   end
        -- end, { "i", "s" }),
        --- -----------------------------------------------
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

    -- Ansible-specific file type detection and configuration
    vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
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

    -- Set up ansible-specific settings
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "yaml.ansible",
      callback = function()
        vim.bo.shiftwidth = 2
        vim.bo.tabstop = 2
        vim.bo.softtabstop = 2
        vim.bo.expandtab = true
      end,
    })

    -- Jinja-specific file type detection and configuration
    vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
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

    -- Set up jinja-specific settings
    vim.api.nvim_create_autocmd("FileType", {
      pattern = {"jinja", "jinja2", "htmldjango"},
      callback = function()
        vim.bo.shiftwidth = 2
        vim.bo.tabstop = 2
        vim.bo.softtabstop = 2
        vim.bo.expandtab = true
        vim.cmd("setlocal commentstring={#\\ %s\\ #}")
      end,
    })
  end,
}