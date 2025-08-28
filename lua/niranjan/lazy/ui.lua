return {
    "folke/which-key.nvim",
    event = "VeryLazy", -- More performant than VimEnter
    opts = {
        -- Performance optimizations
        delay = 200, -- Slight delay prevents accidental triggers
        timeout = 3000, -- Auto-close after 3 seconds
        -- UI improvements
        preset = "modern", -- Use modern preset for better visuals
        sort = { "local", "order", "group", "alphanum", "mod" },
        expand = 1, -- Expand groups automatically
        -- Layout optimization
        layout = {
            width = { min = 20, max = 50 },
            spacing = 3,
            align = "left",
        },
        -- Window styling
        win = {
            border = "rounded",
            padding = { 1, 2 },
            wo = {
                winblend = 10, -- Subtle transparency
            },
        },
        -- Filter out common mappings to reduce noise
        filter = function(mapping)
            return mapping.desc and mapping.desc ~= ""
        end,
        -- Disable for specific modes to improve performance
        disable = {
            bt = { "nofile" },
            ft = { "TelescopePrompt", "neo-tree" },
        },
    },
    -- More comprehensive key specifications
    spec = {
        -- Core leader mappings with better descriptions
        { "<leader>c", group = "Code", mode = { "n", "x" } },
        { "<leader>d", group = "Document/Debug" },
        { "<leader>f", group = "Find/Files" },
        -- { "<leader>g", group = "Git" },
        -- { "<leader>h", group = "Git Hunks", mode = { "n", "v" } },
        { "<leader>l", group = "LSP" },
        { "<leader>r", group = "Rename/Replace" },
        { "<leader>s", group = "Search" },
        { "<leader>t", group = "Toggle/Terminal" },
        { "<leader>w", group = "Workspace/Windows" },
        { "<leader>x", group = "Trouble/Diagnostics" },
        -- { "<leader>q", group = "Quit/Session" },
        { "<leader>b", group = "Buffers" },
        { "<leader>n", group = "Notes/Notifications" },
        -- { "<leader>u", group = "UI/Utils" },
        -- Brackets and common operations
        { "]", group = "Next" },
        { "[", group = "Previous" },
        { "g", group = "Go to" },
        { "z", group = "Fold/Spell" },
        -- Window management
        { "<C-w>", group = "Windows" },
        -- Insert mode mappings
        { "<C-x>", group = "Completion", mode = "i" },
        -- Visual mode specific
        { "<leader>v", group = "Visual", mode = "v" },
        -- Terminal mode
        { "<C-\\>", group = "Terminal", mode = "t" },
        -- Hidden mappings (don't show in which-key)
        { "<leader>w", hidden = true, mode = "v" },
        { "<leader>r", hidden = true, mode = "v" },
    },
    -- Key mappings with better functionality
    keys = {
        {
            "<leader>?",
            function()
                require("which-key").show({ global = false })
            end,
            desc = "Buffer Keymaps",
        },
        {
            "<leader>K",
            function()
                require("which-key").show({ keys = "<leader>", loop = true })
            end,
            desc = "Leader Keys (sticky)",
        },
        {
            "<C-y>",
            function()
                require("which-key").show({ keys = "<C-", loop = true })
            end,
            desc = "Ctrl Keys (sticky)",
            mode = { "n", "v" },
        },
    },
    -- Configuration function for advanced setup
    config = function(_, opts)
        local wk = require("which-key")
        wk.setup(opts)
        -- Auto-register common plugin mappings
        wk.add({
            { "<leader>pf", desc = "Find Files" },
            { "<leader>fg", desc = "Find Git Files" },
            -- { "<leader>fr", desc = "Recent Files" },
            { "<leader>fb", desc = "Find Buffers" },
            -- { "<leader>fh", desc = "Find Help" },
            { "<leader>fw", desc = "Live Grep" },
            -- { "<leader>fc", desc = "Find Commands" },
            -- { "<leader>fk", desc = "Find Keymaps" },
            -- { "<leader>ft", desc = "Find TODOs" },
            { "<leader>ca", desc = "Code Actions" },
            { "<leader>cr", desc = "Rename Symbol" },
            { "<leader>cf", desc = "Format Code" },
            { "<leader>cd", desc = "Show Diagnostics" },
            { "<leader>ci", desc = "Show Info" },
            -- { "<leader>gs", desc = "Git Status" },
            -- { "<leader>gc", desc = "Git Commits" },
            -- { "<leader>gb", desc = "Git Branches" },
            -- { "<leader>gd", desc = "Git Diff" },
            -- { "<leader>gl", desc = "Git Log" },
            -- { "<leader>gp", desc = "Git Push" },
            -- { "<leader>gP", desc = "Git Pull" },
            -- { "<leader>tt", desc = "Toggle Terminal" },
            { "<leader>tn", desc = "Toggle Numbers" },
            { "<leader>tr", desc = "Toggle Relative Numbers" },
            { "<leader>tw", desc = "Toggle Wrap" },
            { "<leader>ts", desc = "Toggle Spell Check" },
            -- { "<leader>th", desc = "Toggle Highlight" },
            { "<leader>bd", desc = "Delete Buffer" },
            { "<leader>bn", desc = "Next Buffer" },
            { "<leader>bp", desc = "Previous Buffer" },
            { "<leader>ba", desc = "Close All Buffers" },
            { "<leader>bo", desc = "Close Others" },
            { "<C-w>s", desc = "Split Window" },
            { "<C-w>v", desc = "Vertical Split" },
            { "<C-w>q", desc = "Close Window" },
            { "<C-w>s", desc = "Close Others" },
            { "<C-w>h", desc = "Move Left" },
            { "<C-w>j", desc = "Move Down" },
            { "<C-w>k", desc = "Move Up" },
            { "<C-w>l", desc = "Move Right" },
            -- { "<leader>qq", desc = "Quit" },
            -- { "<leader>qQ", desc = "Quit All" },
            -- { "<leader>qs", desc = "Save & Quit" },
            -- { "<leader>qS", desc = "Save All & Quit" },
        })
        -- Performance: Only load on first use
        vim.api.nvim_create_autocmd("User", {
            pattern = "LazyLoad",
            callback = function(event)
                if event.data == "which-key.nvim" then
                    -- Additional setup after lazy loading
                    wk.setup({ notify = false })
                end
            end,
        })
    end,
}
