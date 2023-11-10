local function configure()
    vim.cmd.packadd({"nvim-cmp", bang = true}) -- https://github.com/hrsh7th/nvim-cmp
    vim.cmd.packadd({"vim-vsnip", bang = true}) -- https://github.com/hrsh7th/vim-vsnip

    local cmp = require("cmp")
    cmp.setup(
        {
            sources = {
                {name = "nvim_lsp"}
            },
            mapping = cmp.mapping.preset.insert(
                {
                    ["<Tab>"] = cmp.mapping.select_next_item(),
                    ["<S-Tab"] = cmp.mapping.select_prev_item(),
                    ["<CR>"] = cmp.mapping.confirm({select = true})
                }
            ),
            -- I don't use snippets, but cmp doesn't work without a snippet plugin, so:
            snippet = {
                expand = function(args)
                    vim.fn["vsnip#anonymous"](args.body)
                end
            }
        }
    )
end

return {configure = configure}
