return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  dependencies = { "hrsh7th/nvim-cmp" }, -- Optional: if you use nvim-cmp
  config = function()
    local autopairs = require("nvim-autopairs")
    local Rule = require("nvim-autopairs.rule")
    local ts_conds = require("nvim-autopairs.ts-conds")

    autopairs.setup({
      -- Basic options
      check_ts = true, -- Enable treesitter integration
      ts_config = {
        lua = { "string", "source" },
        javascript = { "string", "template_string" },
        java = false, -- Don't check treesitter on java
      },
      -- Disable autopairs in certain filetypes
      disable_filetype = { "spectre_panel" },
      -- Disable in macro recording (performance)
      disable_in_macro = false,
      -- Disable in visualblock mode
      disable_in_visualblock = false,
      -- Disable in replace mode
      disable_in_replace_mode = true,
      -- When to ignore autopairs
      ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
      -- Enable move right on closing pair
      enable_moveright = true,
      -- Enable abbreviations
      enable_abbr = false,
      -- Enable check bracket line
      enable_check_bracket_line = false,
      -- Enable afterquote
      enable_afterquote = true,
      -- Map <BS> to delete pairs
      map_bs = true,
      -- Map <C-w> to delete pairs
      map_c_w = false,
      -- Map <C-h> to delete pairs
      map_c_h = false,
      -- Map <CR> to handle pairs
      map_cr = true,
      -- Don't break undo sequence, keep it intact
      break_undo = true,
      -- Pair with any character
      check_comma = true,
      -- Fast wrap
      fast_wrap = {
        map = '<>aw', -- Changed to leader key for Mac compatibility
        chars = { '{', '[', '(', '"', "'" },
        pattern = [=[[%'%"%>%]%)%}%,]]=],
        end_key = '$',
        before_key = 'h',
        after_key = 'l',
        cursor_pos_before = true,
        keys = 'qwertyuiopzxcvbnmasdfghjkl',
        manual_position = true,
        highlight = 'Search',
        highlight_grey='Comment'
      },
    })

    -- Custom rules for specific languages
    -- Add spaces inside function calls: func( | ) -> func(  |  )
    autopairs.add_rules({
      Rule(' ', ' ')
        :with_pair(function(opts)
          local pair = opts.line:sub(opts.col - 1, opts.col)
          return vim.tbl_contains({ '()', '[]', '{}' }, pair)
        end),
    })

    -- Add rule for arrows in JavaScript/TypeScript
    autopairs.add_rules({
      Rule('%(.*%)%s*%=>$', ' {  }', { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' })
        :use_regex(true)
        :set_end_pair_length(2),
    })

    -- HTML/XML tag completion
    autopairs.add_rules({
      Rule('<', '>')
        :with_pair(ts_conds.is_not_ts_node({'string', 'comment'}))
        :with_move(function(opts)
          return opts.char == '>'
        end),
    })

    -- Markdown code blocks
    autopairs.add_rules({
      Rule('```', '```', 'markdown'),
    })

    -- Python f-string
    autopairs.add_rules({
      Rule("f'", "'", 'python'),
      Rule('f"', '"', 'python'),
    })

    -- Rust lifetime parameters
    autopairs.add_rules({
      Rule('<', '>', 'rust')
        :with_pair(ts_conds.is_ts_node('type_parameters')),
    })

    -- Integration with nvim-cmp (if you use it)
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    local cmp = require('cmp')
    cmp.event:on(
      'confirm_done',
      cmp_autopairs.on_confirm_done()
    )

    -- Optional: Custom keymaps
    local function set_keymaps()
      -- Leader + ap to toggle autopairs
      vim.keymap.set('n', '<leader>ap', function()
        local disabled = require('nvim-autopairs').state.disabled
        if disabled then
          require('nvim-autopairs').enable()
          print('Autopairs enabled')
        else
          require('nvim-autopairs').disable()
          print('Autopairs disabled')
        end
      end, { desc = 'Toggle autopairs' })
    end

    set_keymaps()
  end,
}
