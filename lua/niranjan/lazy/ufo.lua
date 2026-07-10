return {
    "kevinhwang91/nvim-ufo",
    dependencies = {
        "kevinhwang91/promise-async",
    },
    config = function()
        -- UFO folding setup
        -- Using ufo provider needs a large value, feel free to decrease the value
        vim.o.foldlevel = 99 
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true

        -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
        vim.keymap.set('n', 'zR', require('ufo').openAllFolds, { desc = "Open all folds" })
        vim.keymap.set('n', 'zM', require('ufo').closeAllFolds, { desc = "Close all folds" })

        require('ufo').setup({
            provider_selector = function(bufnr, filetype, buftype)
                return {'treesitter', 'indent'}
            end
        })
    end
}
