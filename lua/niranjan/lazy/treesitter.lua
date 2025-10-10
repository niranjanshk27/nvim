return {
    {
        "nvim-treesitter/nvim-treesitter",
        event = "BufReadPost",
        cmd = { "TSUpdate" },
        build = ":TSUpdate",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter-textobjects",
            "nvim-treesitter/nvim-treesitter-context",
            "nvim-treesitter/nvim-treesitter-refactor",
            "nvim-treesitter/playground",
            "JoosepAlviste/nvim-ts-context-commentstring",
        },
        config = function()
            require("nvim-treesitter.configs").setup({
                -- Parser installation
                ensure_installed = {
                    -- Core languages
                    "c", "cpp", "rust", "go", "zig",
                    -- Web development
                    "javascript", "typescript", "tsx", "html", "css", "scss", "json", "jsonc",
                    -- Scripting
                    "lua", "python", "bash", "fish",
                    -- Markup and documentation
                    "markdown", "markdown_inline", "bibtex", "rst",
                    -- "latex"
                    -- Configuration
                    "yaml", "toml", "dockerfile", "terraform", "hcl", "groovy", "hocon", "jq", "ini",
                    -- Documentation
                    "vimdoc", "comment", "jsdoc",
                    -- Data formats
                    "xml", "csv",
                    -- Other useful parsers
                    "regex", "sql", "graphql", "make", "cmake", "ninja",
                    -- Version control
                    "git_config", "git_rebase", "gitattributes", "gitcommit", "gitignore",
                    -- Query language
                    "query", -- For treesitter query files
                },

                -- Install parsers synchronously (only applied to `ensure_installed`)
                sync_install = true,

                -- Automatically install missing parsers when entering buffer
                auto_install = true,

                -- Ignore install for these parsers
                ignore_install = {},

                -- HIGHLIGHTING
                highlight = {
                    enable = true,
                    disable = function(lang, buf)
                        -- Disable for specific languages if needed
                        local disabled_langs = {}
                        if vim.tbl_contains(disabled_langs, lang) then
                            return true
                        end

                        -- Disable for large files
                        local max_filesize = 100 * 1024 -- 100 KB
                        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                        if ok and stats and stats.size > max_filesize then
                            vim.notify(
                                "File larger than 100KB - treesitter disabled for performance",
                                vim.log.levels.WARN,
                                {title = "Treesitter"}
                            )
                            return true
                        end
                    end,

                    -- Use treesitter highlighting alongside vim regex highlighting
                    additional_vim_regex_highlighting = { "markdown" },
                },

                -- INCREMENTAL SELECTION
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<C-space>",
                        node_incremental = "<C-space>",
                        scope_incremental = "<C-s>",
                        node_decremental = "<C-backspace>",
                    },
                },

                -- INDENTATION
                indent = {
                    enable = true,
                    disable = { "python", "yaml" }, -- These languages have better indentation from other sources
                },

                -- FOLDING
                fold = {
                    enable = true,
                    disable = {},
                },

                -- TEXT OBJECTS
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                        keymaps = {
                            -- You can use the capture groups defined in textobjects.scm
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                            ["aa"] = "@parameter.outer",
                            ["ia"] = "@parameter.inner",
                            ["ab"] = "@block.outer",
                            ["ib"] = "@block.inner",
                            ["ai"] = "@conditional.outer",
                            ["ii"] = "@conditional.inner",
                            ["al"] = "@loop.outer",
                            ["il"] = "@loop.inner",
                            ["ak"] = "@comment.outer",
                            ["ik"] = "@comment.inner",
                        },
                        selection_modes = {
                            ['@parameter.outer'] = 'v', -- charwise
                            ['@function.outer'] = 'V', -- linewise
                            ['@class.outer'] = '<c-v>', -- blockwise
                        },
                        include_surrounding_whitespace = true,
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            ["<leader>ao"] = "@parameter.inner",
                            ["<leader>fo"] = "@function.outer",
                        },
                        swap_previous = {
                            ["<leader>AO"] = "@parameter.inner",
                            ["<leader>FO"] = "@function.outer",
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true, -- whether to set jumps in the jumplist
                        goto_next_start = {
                            ["]m"] = "@function.outer",
                            ["]]"] = "@class.outer",
                            ["]a"] = "@parameter.inner",
                        },
                        goto_next_end = {
                            ["]M"] = "@function.outer",
                            ["]["] = "@class.outer",
                            ["]A"] = "@parameter.inner",
                        },
                        goto_previous_start = {
                            ["[m"] = "@function.outer",
                            ["[["] = "@class.outer",
                            ["[a"] = "@parameter.inner",
                        },
                        goto_previous_end = {
                            ["[M"] = "@function.outer",
                            ["[]"] = "@class.outer",
                            ["[A"] = "@parameter.inner",
                        },
                    },
                    lsp_interop = {
                        enable = true,
                        border = 'none',
                        floating_preview_opts = {},
                        peek_definition_code = {
                            ["<leader>df"] = "@function.outer",
                            ["<leader>dF"] = "@class.outer",
                        },
                    },
                },

                -- REFACTOR MODULE
                refactor = {
                    highlight_definitions = {
                        enable = true,
                        -- Set to false if you have an `updatetime` of ~100.
                        clear_on_cursor_move = true,
                    },
                    highlight_current_scope = { enable = false }, -- Can be distracting
                    smart_rename = {
                        enable = true,
                        keymaps = {
                            smart_rename = "grr",
                        },
                    },
                    navigation = {
                        enable = true,
                        keymaps = {
                            goto_definition = "gnd",
                            list_definitions = "gnD",
                            list_definitions_toc = "gO",
                            goto_next_usage = "<a-*>",
                            goto_previous_usage = "<a-#>",
                        },
                    },
                },

                -- PLAYGROUND
                playground = {
                    enable = true,
                    disable = {},
                    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
                    persist_queries = false, -- Whether the query persists across vim sessions
                    keybindings = {
                        toggle_query_editor = 'o',
                        toggle_hl_groups = 'i',
                        toggle_injected_languages = 't',
                        toggle_anonymous_nodes = 'a',
                        toggle_language_display = 'I',
                        focus_language = 'f',
                        unfocus_language = 'F',
                        update = 'R',
                        goto_node = '<cr>',
                        show_help = '?',
                    },
                },

                -- QUERY LINTER
                query_linter = {
                    enable = true,
                    use_virtual_text = true,
                    lint_events = {"BufWrite", "CursorHold"},
                },


            })

            -- Custom parser configurations
            local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
            
            -- Templ parser (Go templating)
            parser_config.templ = {
                install_info = {
                    url = "https://github.com/vrischmann/tree-sitter-templ.git",
                    files = {"src/parser.c", "src/scanner.c"},
                    branch = "master",
                },
                filetype = "templ",
            }

            -- Blade parser (Laravel templating)
            parser_config.blade = {
                install_info = {
                    url = "https://github.com/EmranMR/tree-sitter-blade",
                    files = {"src/parser.c"},
                    branch = "main",
                },
                filetype = "blade",
            }

            -- Register custom languages
            vim.treesitter.language.register("templ", "templ")
            vim.treesitter.language.register("blade", "blade")

            -- Custom commands
            vim.api.nvim_create_user_command("TSPlaygroundToggle", function()
                require("nvim-treesitter-playground.internal").toggle()
            end, {})

            -- Set folding method to use treesitter
            vim.wo.foldmethod = "expr"
            vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
            vim.wo.foldlevel = 99 -- Start with most folds open
            vim.opt.foldlevelstart = 99 -- Start with most folds open (global option)

            -- Custom highlights for better visibility
            vim.cmd([[
                hi TSDefinition guifg=#61AFEF
                hi TSDefinitionUsage guifg=#E06C75
                hi TSCurrentScope guibg=#3E4451
            ]])
        end
    },

    -- TREESITTER CONTEXT
    {
        "nvim-treesitter/nvim-treesitter-context",
        event = "BufReadPost",
        config = function()
            require("treesitter-context").setup({
                enable = true,
                multiwindow = false,
                max_lines = 0, -- No limit
                min_window_height = 0, -- No minimum
                line_numbers = true,
                multiline_threshold = 20,
                trim_scope = 'outer',
                mode = 'cursor',
                separator = nil,
                zindex = 20,
                on_attach = function(buf)
                    -- Don't attach to certain filetypes
                    local excluded_ft = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy" }
                    return not vim.tbl_contains(excluded_ft, vim.bo[buf].filetype)
                end,
            })

            -- Custom keymaps for context
            vim.keymap.set("n", "<leader>cc", function()
                require("treesitter-context").go_to_context()
            end, { silent = true, desc = "Go to context" })
        end
    },

    -- CONTEXT COMMENTSTRING
    {
        "JoosepAlviste/nvim-ts-context-commentstring",
        event = "BufReadPost",
        config = function()
            vim.g.skip_ts_context_commentstring_module = true
            require("ts_context_commentstring").setup({
                enable_autocmd = false,
            })
        end
    },

    -- TREESITTER TEXTOBJECTS
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        after = "nvim-treesitter",
    },

    -- TREESITTER REFACTOR
    {
        "nvim-treesitter/nvim-treesitter-refactor",
        after = "nvim-treesitter",
    },

    -- PLAYGROUND
    {
        "nvim-treesitter/playground",
        cmd = "TSPlaygroundToggle",
        after = "nvim-treesitter",
    },
}
