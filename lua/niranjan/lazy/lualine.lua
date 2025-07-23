return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' }, -- if you want icons
    config = function()
        require('lualine').setup {
            options = {
                icons_enabled = true,
                -- theme = 'gruvbox',  -- You can use any theme here
                theme = 'solarized_dark',  -- You can use any theme here
                component_separators = { left = '|', right = '|' },
                section_separators = { left = '', right = '' },
                disabled_filetypes = {
                    statusline = {},
                    winbar = {}
                },
                always_divide_middle = true,
                globalstatus = true, -- Single statusline for all windows
                refresh = {
                    statusline = 1000,
                    tabline = 1000,
                    winbar = 1000,
                },
            },
            sections = {
                lualine_a = {'mode'},
                lualine_b = {'branch'},
                lualine_c = {
                    {
                        'filename',
                        path = 1,
                        symbols = {
                            modified = ' ●',
                            readonly = ' ',
                            unnamed = '[No Name]',
                        }
                    }
                },
                lualine_x = {'encoding', 'fileformat', 'filetype'},
                lualine_y = {'progress'},
                lualine_z = {'location'}
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = {'filename'},
                lualine_x = {'location'},
                lualine_y = {},
                lualine_z = {}
            },
            tabline = {},
            extensions = {
                'nvim-tree',
                'toggleterm',
                'quickfix',
                'man',
                'lazy',
                'mason',
                'trouble',
                'oil',
            }
        }
    end
}


-- return {
--     'nvim-lualine/lualine.nvim',
--     dependencies = { 'nvim-tree/nvim-web-devicons' },
--     config = function()
--         -- Custom colors for a more vibrant look
--         local colors = {
--             blue = '#80a0ff',
--             cyan = '#79dac8',
--             black = '#080808',
--             white = '#c6c6c6',
--             red = '#ff5189',
--             violet = '#d183e8',
--             grey = '#303030',
--             green = '#4fd6be',
--             orange = '#ff8800',
--             yellow = '#ffde50',
--         }

--         -- Custom theme based on colors above
--         local custom_theme = {
--             normal = {
--                 a = { fg = colors.black, bg = colors.violet },
--                 b = { fg = colors.white, bg = colors.grey },
--                 c = { fg = colors.white, bg = colors.black },
--             },
--             insert = {
--                 a = { fg = colors.black, bg = colors.green },
--                 b = { fg = colors.white, bg = colors.grey },
--                 c = { fg = colors.white, bg = colors.black },
--             },
--             visual = {
--                 a = { fg = colors.black, bg = colors.yellow },
--                 b = { fg = colors.white, bg = colors.grey },
--                 c = { fg = colors.white, bg = colors.black },
--             },
--             replace = {
--                 a = { fg = colors.black, bg = colors.red },
--                 b = { fg = colors.white, bg = colors.grey },
--                 c = { fg = colors.white, bg = colors.black },
--             },
--             command = {
--                 a = { fg = colors.black, bg = colors.orange },
--                 b = { fg = colors.white, bg = colors.grey },
--                 c = { fg = colors.white, bg = colors.black },
--             },
--             inactive = {
--                 a = { fg = colors.white, bg = colors.black },
--                 b = { fg = colors.white, bg = colors.black },
--                 c = { fg = colors.white, bg = colors.black },
--             },
--         }

--         -- Custom components
--         local function lsp_client()
--             local clients = vim.lsp.get_active_clients()
--             if next(clients) == nil then
--                 return "No LSP"
--             end
--             local client_names = {}
--             for _, client in pairs(clients) do
--                 table.insert(client_names, client.name)
--             end
--             return " " .. table.concat(client_names, ", ")
--         end

--         local function show_macro_recording()
--             local recording_register = vim.fn.reg_recording()
--             if recording_register == "" then
--                 return ""
--             else
--                 return "Recording @" .. recording_register
--             end
--         end

--         local function get_current_signature()
--             local has_signature, signature = pcall(vim.lsp.buf.signature_help)
--             if has_signature and signature then
--                 return signature
--             end
--             return ""
--         end

--         require('lualine').setup {
--             options = {
--                 icons_enabled = true,
--                 theme = custom_theme,
--                 component_separators = { left = '|', right = '|' },
--                 section_separators = { left = '', right = '' },
--                 disabled_filetypes = {
--                     statusline = {},
--                     winbar = {},
--                 },
--                 always_divide_middle = true,
--                 globalstatus = true, -- Single statusline for all windows
--                 refresh = {
--                     statusline = 1000,
--                     tabline = 1000,
--                     winbar = 1000,
--                 },
--             },
--             sections = {
--                 lualine_a = {
--                     {
--                         'mode',
--                         fmt = function(str)
--                             return str:sub(1,1) -- Show only first character
--                         end
--                     }
--                 },
--                 lualine_b = {
--                     {
--                         'branch',
--                         icon = '',
--                         color = { fg = colors.violet, gui = 'bold' },
--                     },
--                     {
--                         'diff',
--                         symbols = {
--                             added = ' ',
--                             modified = ' ',
--                             removed = ' '
--                         },
--                         diff_color = {
--                             added = { fg = colors.green },
--                             modified = { fg = colors.yellow },
--                             removed = { fg = colors.red },
--                         },
--                     }
--                 },
--                 lualine_c = {
--                     {
--                         'filename',
--                         path = 1, -- Show relative path
--                         symbols = {
--                             modified = ' ●',
--                             readonly = ' ',
--                             unnamed = '[No Name]',
--                         },
--                         color = { fg = colors.blue, gui = 'bold' },
--                     },
--                     {
--                         'diagnostics',
--                         sources = { 'nvim_lsp', 'nvim_diagnostic' },
--                         symbols = {
--                             error = ' ',
--                             warn = ' ',
--                             info = ' ',
--                             hint = ' '
--                         },
--                         diagnostics_color = {
--                             error = { fg = colors.red },
--                             warn = { fg = colors.yellow },
--                             info = { fg = colors.cyan },
--                             hint = { fg = colors.blue },
--                         },
--                     },
--                     {
--                         show_macro_recording,
--                         color = { fg = colors.orange, gui = 'bold' },
--                     },
--                 },
--                 lualine_x = {
--                     {
--                         lsp_client,
--                         icon = '',
--                         color = { fg = colors.cyan },
--                     },
--                     {
--                         'searchcount',
--                         maxcount = 999,
--                         timeout = 500,
--                         color = { fg = colors.yellow },
--                     },
--                     {
--                         'selectioncount',
--                         color = { fg = colors.green },
--                     },
--                     {
--                         'encoding',
--                         fmt = string.upper,
--                         color = { fg = colors.white },
--                     },
--                     {
--                         'fileformat',
--                         symbols = {
--                             unix = '',
--                             dos = '',
--                             mac = '',
--                         },
--                         color = { fg = colors.white },
--                     },
--                     {
--                         'filetype',
--                         colored = true,
--                         icon_only = false,
--                         icon = { align = 'right' },
--                     },
--                 },
--                 lualine_y = {
--                     {
--                         'progress',
--                         color = { fg = colors.blue },
--                     },
--                 },
--                 lualine_z = {
--                     {
--                         'location',
--                         color = { fg = colors.black, bg = colors.white, gui = 'bold' },
--                     },
--                 }
--             },
--             inactive_sections = {
--                 lualine_a = {},
--                 lualine_b = {},
--                 lualine_c = {
--                     {
--                         'filename',
--                         path = 1,
--                         color = { fg = colors.grey },
--                     }
--                 },
--                 lualine_x = {
--                     {
--                         'location',
--                         color = { fg = colors.grey },
--                     }
--                 },
--                 lualine_y = {},
--                 lualine_z = {}
--             },
--             tabline = {},
--             extensions = {
--                 'nvim-tree',
--                 'toggleterm',
--                 'quickfix',
--                 'man',
--                 'lazy',
--                 'mason',
--                 'trouble',
--                 'oil',
--             }
--         }
--     end
-- }