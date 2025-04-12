return {
    "folke/which-key.nvim",
    event = "VimEnter",
    opts = {
        -- delay between pressing a key and opening which-key (milliseconds)
        -- this setting is independent of vim.opt.timeoutlen
        delay = 0,
    },
    spec = {
        { '<leader>c', desc = '[C]ode', mode = { 'n', 'x' } },
        { '<leader>d', desc = '[D]ocument' },
        { '<leader>r', desc = '[R]ename' },
        { '<leader>s', desc = '[S]earch' },
        { '<leader>w', desc = '[W]orkspace' },
        { '<leader>t', desc = '[T]oggle' },
        { '<leader>h', desc = 'Git [H]unk', mode = { 'n', 'v' } },
    },
    keys = {
        {
            "<leader>?", function()
                require("which-key").show({ global = false })
            end,
            desc = "Buffer Local Keymaps (which-key)",
        },
    },
}
