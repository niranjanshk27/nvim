return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  dependencies = {
    "nvim-lua/plenary.nvim",
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

    telescope.setup({})

    --------------------------------------------------
    -- Persistent flags for find_files
    --------------------------------------------------
    local flag_file_path = vim.fn.stdpath("data") .. "/telescope_flags.json"
    local find_files_opts = {
      hidden = false,
      no_ignore = false,
      follow = false,
      file_ignore_patterns = { "%.git/" },  -- Ignore `.git/` folder
    }

    local function load_flags()
      local flag_file = Path:new(flag_file_path)
      if flag_file:exists() then
        local content = flag_file:read()
        local ok, data = pcall(vim.fn.json_decode, content)
        if ok and type(data) == "table" then
          find_files_opts = vim.tbl_deep_extend("force", find_files_opts, data)
        end
      end
    end

    local function save_flags()
      Path:new(flag_file_path):write(vim.fn.json_encode(find_files_opts), "w")
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
      for k in pairs(find_files_opts) do
        find_files_opts[k] = not find_files_opts[k]
      end
      save_flags()
      find_files_with_flags()
      notify_flags()
    end

    function find_files_with_flags()
      builtin.find_files(vim.tbl_extend("force", find_files_opts, {
        prompt_title = string.format("Find Files (hidden: %s | ignore: %s | follow: %s)",
          tostring(find_files_opts.hidden),
          tostring(find_files_opts.no_ignore),
          tostring(find_files_opts.follow)
        )
      }))
    end

    --------------------------------------------------
    -- Incremental fd-powered custom picker
    --------------------------------------------------
    local toggle_state = {
      hidden = false,
      no_ignore = false,
      depth = 1,
    }

    local function build_fd_command(query, dir)
      local cmd = { 'fd', '--type', 'f', '--type', 'd', '--base-directory', dir, '--search-path', '.' }

      if toggle_state.hidden then table.insert(cmd, '--hidden') end
      if toggle_state.no_ignore then table.insert(cmd, '--no-ignore') end
      if toggle_state.depth > 0 then table.insert(cmd, '--max-depth=' .. toggle_state.depth) end

      if query ~= '' then table.insert(cmd, query) end
      return cmd
    end

    local function get_toggle_status(num)
      local function status(flag, char) return flag and '[' .. char:upper() .. ']' or '[' .. char:lower() .. ']' end
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
      local results = vim.fn.systemlist(cmd)

      pickers.new({}, {
        prompt_title = get_toggle_status(#results) .. 'Find in ' .. label,
        finder = finders.new_table {
          results = results,
          entry_maker = function(entry)
            return {
              value = entry,
              display = entry,
              ordinal = entry,
              path = Path:new(dir, entry):absolute():gsub('//', '/'),
            }
          end,
        },
        sorter = conf.generic_sorter(),
        default_text = query,
        attach_mappings = function(prompt_bufnr, map)
          local current_input = function()
            return action_state.get_current_line()
          end

          local refresh_picker = function(modify)
            local input = current_input()
            modify()
            actions.close(prompt_bufnr)
            incremental_fd_search(input, dir, label)
          end

          map('i', '<C-h>', function() refresh_picker(function() toggle_state.hidden = not toggle_state.hidden end) end)
          map('i', '<C-i>', function() refresh_picker(function() toggle_state.no_ignore = not toggle_state.no_ignore end) end)
          map('i', '<C-d>', function() refresh_picker(function() toggle_state.depth = toggle_state.depth == 0 and 1 or 0 end) end)
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
    end, {})

    vim.api.nvim_create_user_command('TelescopeFindBufferDir', function()
      local path = vim.api.nvim_buf_get_name(0)
      local dir = path ~= '' and Path:new(path):parent().filename or vim.fn.getcwd()
      incremental_fd_search('', dir, '🗂️ Buffer')
    end, {})

    --------------------------------------------------
    -- Keymaps
    --------------------------------------------------
    load_flags()

    vim.keymap.set('n', '<leader>pf', find_files_with_flags, { desc = "Find files (persistent flags)" })
    vim.keymap.set('n', '<leader>tt', toggle_all_flags, { desc = "Toggle all flags" })
    vim.keymap.set('n', '<leader>th', function() toggle_flag("hidden") end, { desc = "Toggle hidden" })
    vim.keymap.set('n', '<leader>ti', function() toggle_flag("no_ignore") end, { desc = "Toggle no_ignore" })
    vim.keymap.set('n', '<leader>tf', function() toggle_flag("follow") end, { desc = "Toggle follow symlinks" })
    vim.keymap.set('n', '<leader>fr', '<cmd>TelescopeFindRoot<CR>', { desc = "FD find in root" })
    vim.keymap.set('n', '<leader>fb', '<cmd>TelescopeFindBufferDir<CR>', { desc = "FD find in buffer dir" })
    
    vim.keymap.set('n', '<leader>bb', function ()
      builtin.buffers({
        sort_mru = true,
        ignore_current_buffer = true,
        -- previewer = false,
        -- mappings = {
        --   i = {
        --     ["<C-k>"] = function ()
        --       local current_picker = action_state.get_selected_entry()
        --       actions.close(prompt_bufnr)
        --       vim.api.nvim_buf_delete(current_picker.bufnr, { force = true})
        --     end,
        --   },
        --   n = {
        --     ["<C-k>"] = function ()
        --       local current_picker = action_state.get_selected_entry()
        --       actions.close(prompt_bufnr)
        --       vim.api.nvim_buf_delete(current_picker.bufnr, { force = true })
        --     end   
        --   },
        -- }
      })
    end, { desc = "Buffer list" })

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
