local opts = function()
    local cmp = require("cmp")
    return {
        sources = {
            { name = "nvim_lsp" },
        },
        mapping = cmp.mapping.preset.insert({
            ["<Tab>"] = cmp.mapping.select_next_item(),
            ["<S-Tab"] = cmp.mapping.select_prev_item(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
        }),
        -- I don't use snippets, but cmp doesn't work without a snippet plugin, so:
        snippet = {
            expand = function(args)
                vim.fn["vsnip#anonymous"](args.body)
            end,
        },
    }
end

return {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/vim-vsnip" },
    opts = opts,
}
