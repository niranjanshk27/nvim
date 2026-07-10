return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        cmd = { "TSUpdate", "TSInstall" },
        build = ":TSUpdate",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            -- The main branch uses Neovim's native treesitter integration.
            -- setup() is optional and only takes `install_dir`.

            -- 1. Install parsers declaratively
            require("nvim-treesitter").install({
                "c", "cpp", "rust", "go", "zig",
                "javascript", "typescript", "tsx", "html", "css", "scss", "json", "jsonc",
                "lua", "python", "bash", "fish",
                "markdown", "markdown_inline", "bibtex", "rst",
                "yaml", "toml", "dockerfile", "terraform", "hcl", "groovy", "hocon", "jq", "ini",
                "vimdoc", "comment", "jsdoc",
                "xml", "csv",
                "regex", "sql", "graphql", "make", "cmake", "ninja",
                "git_config", "git_rebase", "gitattributes", "gitcommit", "gitignore",
                "query", "templ", "blade"
            })

            -- 2. Enable native Treesitter highlighting for all buffers
            vim.api.nvim_create_autocmd('FileType', {
                pattern = '*',
                callback = function(args)
                    local lang = vim.bo[args.buf].filetype
                    -- Avoid huge files for performance
                    local max_filesize = 100 * 1024 -- 100 KB
                    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))
                    if ok and stats and stats.size > max_filesize then
                        return
                    end
                    -- Safely attempt to start treesitter highlighting
                    pcall(vim.treesitter.start, args.buf)
                    
                    -- Folds and indentation (provided natively)
                    -- We won't set folds here because ufo handles them, but here's how you would:
                    -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
                    -- vim.wo.foldmethod = 'expr'
                    
                    pcall(function()
                        vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end)
                end,
            })

            -- Custom parser configurations
            local parser_config = require("nvim-treesitter.parsers")
            
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
        end
    },

    -- TREESITTER CONTEXT
    {
        "nvim-treesitter/nvim-treesitter-context",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
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
        dependencies = { "nvim-treesitter/nvim-treesitter" },
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
        branch = "main",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("nvim-treesitter-textobjects").setup({
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
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
                        ['@parameter.outer'] = 'v',
                        ['@function.outer'] = 'V',
                        ['@class.outer'] = '<c-v>',
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
                    set_jumps = true,
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
            })
        end
    },

    -- TREESITTER REFACTOR
    -- {
    --     "nvim-treesitter/nvim-treesitter-refactor",
    --     after = "nvim-treesitter",
    -- },
}


