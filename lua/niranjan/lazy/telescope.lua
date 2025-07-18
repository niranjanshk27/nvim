return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },

  config = function()
    local telescope = require("telescope")
    local builtin = require("telescope.builtin")
    local Path = require("plenary.path")
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values

    -- Performance optimized telescope setup
    telescope.setup({
      defaults = {
        -- Performance improvements
        cache_picker = {
          num_pickers = 10,
          limit_entries = 1000,
        },
        dynamic_preview_title = true,
        results_title = false,
        
        -- Faster file ignore patterns
        file_ignore_patterns = { 
          "%.git/",
          "node_modules/",
          "%.npm/",
          "%.next/",
          "%.nuxt/",
          "dist/",
          "build/",
          "%.o$",
          "%.a$",
          "%.so$",
          "%.pyc$",
          "__pycache__/",
          "%.class$",
          "%.jar$",
          "target/",
          "%.lock$",
        },
        
        -- Optimized layout and UI
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
            results_width = 0.8,
          },
          vertical = {
            mirror = false,
          },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },
        
        -- Better sorting performance
        sorting_strategy = "ascending",
        prompt_prefix = "🔍 ",
        selection_caret = "▶ ",
        entry_prefix = "  ",
        initial_mode = "insert",
        selection_strategy = "reset",
        
        -- Faster previewer
        preview = {
          treesitter = true,
          timeout = 250,
          msg_bg_fillchar = "░",
        },
        
        -- Optimized mappings
        mappings = {
          i = {
            ["<C-n>"] = actions.cycle_history_next,
            ["<C-p>"] = actions.cycle_history_prev,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-c>"] = actions.close,
            ["<Down>"] = actions.move_selection_next,
            ["<Up>"] = actions.move_selection_previous,
            ["<CR>"] = actions.select_default,
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,
            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,
            ["<PageUp>"] = actions.results_scrolling_up,
            ["<PageDown>"] = actions.results_scrolling_down,
            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["<C-l>"] = actions.complete_tag,
            ["<C-_>"] = actions.which_key,
            ["<M-p>"] = require("telescope.actions.layout").toggle_preview,
          },
          n = {
            ["<esc>"] = actions.close,
            ["<CR>"] = actions.select_default,
            ["<C-x>"] = actions.select_horizontal,
            ["<C-v>"] = actions.select_vertical,
            ["<C-t>"] = actions.select_tab,
            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
            ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
            ["j"] = actions.move_selection_next,
            ["k"] = actions.move_selection_previous,
            ["H"] = actions.move_to_top,
            ["M"] = actions.move_to_middle,
            ["L"] = actions.move_to_bottom,
            ["<Down>"] = actions.move_selection_next,
            ["<Up>"] = actions.move_selection_previous,
            ["gg"] = actions.move_to_top,
            ["G"] = actions.move_to_bottom,
            ["<C-u>"] = actions.preview_scrolling_up,
            ["<C-d>"] = actions.preview_scrolling_down,
            ["<PageUp>"] = actions.results_scrolling_up,
            ["<PageDown>"] = actions.results_scrolling_down,
            ["?"] = actions.which_key,
            ["<M-p>"] = require("telescope.actions.layout").toggle_preview,
          },
        },
      },
      
      pickers = {
        -- Optimized picker configurations
        find_files = {
          -- Use default layout (horizontal) instead of dropdown for better preview
          previewer = true,
          find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
        },
        
        git_files = {
          -- Use default layout (horizontal) instead of dropdown for better preview
          previewer = true,
          show_untracked = true,
        },
        
        buffers = {
          -- Use default layout (horizontal) instead of dropdown for better preview
          previewer = true,
          sort_mru = true,
          ignore_current_buffer = true,
          mappings = {
            i = {
              ["<C-k>"] = function(prompt_bufnr)
                local current_picker = action_state.get_selected_entry()
                if current_picker and current_picker.bufnr then
                  actions.close(prompt_bufnr)
                  vim.api.nvim_buf_delete(current_picker.bufnr, { force = true })
                  -- Reopen buffers picker
                  vim.schedule(function()
                    builtin.buffers({
                      sort_mru = true,
                      ignore_current_buffer = true,
                    })
                  end)
                end
              end,
              ["<M-p>"] = require("telescope.actions.layout").toggle_preview,
            },
            n = {
              ["<C-k>"] = function(prompt_bufnr)
                local current_picker = action_state.get_selected_entry()
                if current_picker and current_picker.bufnr then
                  actions.close(prompt_bufnr)
                  vim.api.nvim_buf_delete(current_picker.bufnr, { force = true })
                  -- Reopen buffers picker
                  vim.schedule(function()
                    builtin.buffers({
                      sort_mru = true,
                      ignore_current_buffer = true,
                    })
                  end)
                end
              end,
              ["<M-p>"] = require("telescope.actions.layout").toggle_preview,
            },
          },
        },
        
        live_grep = {
          additional_args = function(opts)
            return { "--hidden", "--smart-case" }
          end,
          glob_pattern = "!{.git,node_modules,dist,build}/*",
        },
        
        grep_string = {
          additional_args = function(opts)
            return { "--hidden", "--smart-case" }
          end,
          glob_pattern = "!{.git,node_modules,dist,build}/*",
        },
        
        help_tags = {
          theme = "ivy",
        },
      },
      
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
      },
    })
    
    -- Load FZF extension for better performance
    pcall(telescope.load_extension, "fzf")

    --------------------------------------------------
    -- Persistent flags for find_files (cached)
    --------------------------------------------------
    local flag_file_path = vim.fn.stdpath("data") .. "/telescope_flags.json"
    local find_files_opts = {
      hidden = false,
      no_ignore = false,
      follow = false,
      file_ignore_patterns = { "%.git/" },
    }
    
    -- Cache the flags to avoid file I/O on every call
    local flags_loaded = false
    
    local function load_flags()
      if flags_loaded then return end
      
      local flag_file = Path:new(flag_file_path)
      if flag_file:exists() then
        local ok, content = pcall(flag_file.read, flag_file)
        if ok and content then
          local decode_ok, data = pcall(vim.fn.json_decode, content)
          if decode_ok and type(data) == "table" then
            find_files_opts = vim.tbl_deep_extend("force", find_files_opts, data)
          end
        end
      end
      flags_loaded = true
    end

    local function save_flags()
      vim.schedule(function()
        local ok, encoded = pcall(vim.fn.json_encode, find_files_opts)
        if ok then
          Path:new(flag_file_path):write(encoded, "w")
        end
      end)
    end

    local function notify_flags()
      vim.notify(string.format(
        "Find Files Flags:\n• hidden: %s\n• no_ignore: %s\n• follow: %s",
        tostring(find_files_opts.hidden),
        tostring(find_files_opts.no_ignore),
        tostring(find_files_opts.follow)
      ), vim.log.levels.INFO, { title = "Telescope Flags" })
    end

    local function toggle_flag(key)
      find_files_opts[key] = not find_files_opts[key]
      save_flags()
      find_files_with_flags()
      notify_flags()
    end

    local function toggle_all_flags()
      for k, _ in pairs(find_files_opts) do
        if k ~= "file_ignore_patterns" then
          find_files_opts[k] = not find_files_opts[k]
        end
      end
      save_flags()
      find_files_with_flags()
      notify_flags()
    end

    function find_files_with_flags()
      local opts = vim.tbl_extend("force", find_files_opts, {
        prompt_title = string.format("Find Files (hidden: %s | ignore: %s | follow: %s)",
          tostring(find_files_opts.hidden),
          tostring(find_files_opts.no_ignore),
          tostring(find_files_opts.follow)
        )
      })
      builtin.find_files(opts)
    end

    --------------------------------------------------
    -- Optimized incremental fd-powered custom picker
    --------------------------------------------------
    local toggle_state = {
      hidden = false,
      no_ignore = false,
      depth = 1,
    }

    -- Memoized command building
    local cmd_cache = {}
    local function build_fd_command(query, dir)
      local cache_key = string.format("%s:%s:%s:%s:%s", 
        query, dir, toggle_state.hidden, toggle_state.no_ignore, toggle_state.depth)
      
      if cmd_cache[cache_key] then
        return cmd_cache[cache_key]
      end
      
      local cmd = { 'fd', '--type', 'f', '--type', 'd', '--base-directory', dir, '--search-path', '.' }

      if toggle_state.hidden then table.insert(cmd, '--hidden') end
      if toggle_state.no_ignore then table.insert(cmd, '--no-ignore') end
      if toggle_state.depth > 0 then table.insert(cmd, '--max-depth=' .. toggle_state.depth) end

      if query ~= '' then table.insert(cmd, query) end
      
      cmd_cache[cache_key] = cmd
      return cmd
    end

    local function get_toggle_status(num)
      local function status(flag, char) 
        return flag and '[' .. char:upper() .. ']' or '[' .. char:lower() .. ']' 
      end
      local parts = {
        status(toggle_state.no_ignore, 'I'),
        status(toggle_state.hidden, 'H'),
        status(toggle_state.depth == 0, 'R'),
      }
      if num >= 5000 then table.insert(parts, '[❗]') end
      return table.concat(parts, '') .. ' '
    end

    local function incremental_fd_search(query, dir, label)
      local cmd = build_fd_command(query, dir)
      
      -- Use vim.system for better performance if available (nvim 0.10+)
      local results
      if vim.system then
        local result = vim.system(cmd, { text = true }):wait()
        results = result.code == 0 and vim.split(result.stdout, '\n', { trimempty = true }) or {}
      else
        results = vim.fn.systemlist(cmd)
      end

      pickers.new({}, {
        prompt_title = get_toggle_status(#results) .. 'Find in ' .. label,
        finder = finders.new_table {
          results = results,
          entry_maker = function(entry)
            local path = Path:new(dir, entry):absolute():gsub('//', '/')
            return {
              value = entry,
              display = entry,
              ordinal = entry,
              path = path,
            }
          end,
        },
        sorter = conf.generic_sorter(),
        default_text = query,
        previewer = conf.file_previewer({}),
        attach_mappings = function(prompt_bufnr, map)
          local current_input = function()
            return action_state.get_current_line()
          end

          local refresh_picker = function(modify)
            local input = current_input()
            modify()
            actions.close(prompt_bufnr)
            -- Clear cache when toggling
            cmd_cache = {}
            incremental_fd_search(input, dir, label)
          end

          map('i', '<C-h>', function() 
            refresh_picker(function() 
              toggle_state.hidden = not toggle_state.hidden 
            end) 
          end)
          map('i', '<C-i>', function() 
            refresh_picker(function() 
              toggle_state.no_ignore = not toggle_state.no_ignore 
            end) 
          end)
          map('i', '<C-d>', function() 
            refresh_picker(function() 
              toggle_state.depth = toggle_state.depth == 0 and 1 or 0 
            end) 
          end)
          map('i', '<M-p>', require("telescope.actions.layout").toggle_preview)
          map('i', '<BS>', function()
            if current_input() == '' then
              actions.close(prompt_bufnr)
              local parent = Path:new(dir):parent().filename
              incremental_fd_search('', parent, '⬆️ Up')
            else
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<BS>', true, false, true), 'n', true)
            end
          end)

          actions.select_default:replace(function()
            local entry = action_state.get_selected_entry()
            if not entry or not entry.path then return end
            actions.close(prompt_bufnr)
            local path = entry.path
            if Path:new(path):is_dir() then
              incremental_fd_search('', path, '📁 Descend')
            else
              vim.cmd("edit " .. vim.fn.fnameescape(path))
            end
          end)

          return true
        end
      }):find()
    end

    --------------------------------------------------
    -- Commands for launching fd-based search
    --------------------------------------------------
    vim.api.nvim_create_user_command('TelescopeFindRoot', function()
      local dir = vim.fn.getcwd()
      incremental_fd_search('', dir, '📦 Root')
    end, { desc = "Find files in project root with fd" })

    vim.api.nvim_create_user_command('TelescopeFindBufferDir', function()
      local path = vim.api.nvim_buf_get_name(0)
      local dir = path ~= '' and Path:new(path):parent().filename or vim.fn.getcwd()
      incremental_fd_search('', dir, '🗂️ Buffer')
    end, { desc = "Find files in buffer directory with fd" })

    --------------------------------------------------
    -- Optimized buffer picker with delete functionality
    --------------------------------------------------
    local function optimized_buffers()
      builtin.buffers({
        sort_mru = true,
        ignore_current_buffer = true,
        previewer = true,  -- Enable previewer by default
        -- Use default layout (horizontal) instead of dropdown for better preview
        mappings = {
          i = {
            ["<C-k>"] = function(prompt_bufnr)
              local current_picker = action_state.get_selected_entry()
              if current_picker and current_picker.bufnr then
                actions.close(prompt_bufnr)
                vim.api.nvim_buf_delete(current_picker.bufnr, { force = true })
                -- Reopen buffers picker
                vim.schedule(function()
                  optimized_buffers()
                end)
              end
            end,
            ["<M-p>"] = require("telescope.actions.layout").toggle_preview,
          },
          n = {
            ["<C-k>"] = function(prompt_bufnr)
              local current_picker = action_state.get_selected_entry()
              if current_picker and current_picker.bufnr then
                actions.close(prompt_bufnr)
                vim.api.nvim_buf_delete(current_picker.bufnr, { force = true })
                -- Reopen buffers picker
                vim.schedule(function()
                  optimized_buffers()
                end)
              end
            end,
            ["<M-p>"] = require("telescope.actions.layout").toggle_preview,
          },
        },
      })
    end

    --------------------------------------------------
    -- Keymaps (all preserved)
    --------------------------------------------------
    load_flags()

    vim.keymap.set('n', '<leader>pf', find_files_with_flags, { desc = "Find files (persistent flags)" })
    vim.keymap.set('n', '<leader>ta', toggle_all_flags, { desc = "Toggle all flags" })
    vim.keymap.set('n', '<leader>th', function() toggle_flag("hidden") end, { desc = "Toggle hidden" })
    vim.keymap.set('n', '<leader>ti', function() toggle_flag("no_ignore") end, { desc = "Toggle no_ignore" })
    vim.keymap.set('n', '<leader>tf', function() toggle_flag("follow") end, { desc = "Toggle follow symlinks" })
    vim.keymap.set('n', '<leader>fr', '<cmd>TelescopeFindRoot<CR>', { desc = "FD find in root" })
    vim.keymap.set('n', '<leader>fb', '<cmd>TelescopeFindBufferDir<CR>', { desc = "FD find in buffer dir" })
    vim.keymap.set('n', '<leader>bb', optimized_buffers, { desc = "Buffer list" })
    vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = "Git files" })
    vim.keymap.set('n', '<leader>fw', builtin.live_grep, { desc = "Live grep" })
    vim.keymap.set('n', '<leader>vh', builtin.help_tags, { desc = "Help tags" })
    vim.keymap.set('n', '<leader>pWs', function()
      builtin.grep_string({ search = vim.fn.expand("<cWORD>") })
    end, { desc = "Search current WORD" })
    vim.keymap.set('n', '<leader>ps', function()
      builtin.grep_string({ search = vim.fn.input("Grep > ") })
    end, { desc = "Search by input" })
  end
}