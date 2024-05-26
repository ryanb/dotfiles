-- Completion
--
-- https://github.com/hrsh7th/nvim-cmp

local function configure_global_completion()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    -- Handle both completion and snippets when hitting tab.
    local function tab(fallback)
        if cmp.visible() then
            cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
        else
            fallback()
        end
    end

    -- Handle both completion and snippets when hitting shift-tab.
    local function shift_tab(fallback)
        if cmp.visible() then
            cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
        else
            fallback()
        end
    end

    cmp.setup({
        formatting = {
            format = function(entry, vim_item)
                vim_item.menu = "[" .. entry.source.name .. "]"
                return vim_item
            end,
        },
        mapping = cmp.mapping.preset.insert({
            ["<Tab>"] = cmp.mapping(tab, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(shift_tab, { "i", "s" }),
            ["<CR>"] = cmp.mapping.confirm({}),
        }),
        snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body)
            end,
        },
        sources = {
            { name = "nvim_lsp" },
            { name = "luasnip" },
        },
    })
end

local function configure_command_line_completion()
    local cmp = require("cmp")

    cmp.setup.cmdline(":", {
        formatting = {
            fields = { "abbr", "menu" },
        },
        mapping = cmp.mapping.preset.cmdline(),
        matching = { disallow_symbol_nonprefix_matching = false },
        sources = cmp.config.sources({
            { name = "path" },
        }, {
            { name = "cmdline" },
        }),
    })
end

local function configure_search_completion()
    local cmp = require("cmp")

    cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = "buffer" },
        },
    })
end

local function config()
    configure_global_completion()
    configure_command_line_completion()
    configure_search_completion()
end

return {
    "hrsh7th/nvim-cmp",
    config = config,
    dependencies = {
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-path",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
    },
}
