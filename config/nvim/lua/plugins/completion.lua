local luasnip_spec = {
    -- https://github.com/L3MON4D3/LuaSnip
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
        local luasnip = require("luasnip")
        luasnip.filetype_extend("ruby", { "rails" })

        -- This loads the snippets from friendly-snippets.
        require("luasnip.loaders.from_vscode").lazy_load()
    end,
}

local function configure_global_completion()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    -- Handle completion and snippets when hitting tab.
    local function tab(fallback)
        if cmp.visible() then
            cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
        else
            fallback()
        end
    end

    -- Handle completion and snippets when hitting shift-tab.
    local function shift_tab(fallback)
        if cmp.visible() then
            cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
        else
            fallback()
        end
    end

    -- Handle confirming on CR.
    local function cr(fallback)
        if cmp.visible() and cmp.get_active_entry() then
            cmp.confirm()
        else
            fallback()
        end
    end

    local function format(entry, vim_item)
        vim_item.menu = "[" .. entry.source.name .. "]"
        return vim_item
    end

    local mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp.mapping(tab, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(shift_tab, { "i", "s" }),
        ["<CR>"] = cmp.mapping(cr, { "i", "s", "c" }),
    })

    cmp.setup({
        formatting = {
            format = format,
        },
        mapping = mapping,
        snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body)
            end,
        },
        sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "luasnip" },
        }),
    })
end

local function configure_command_line_completion()
    local cmp = require("cmp")

    cmp.setup.cmdline(":", {
        completion = { autocomplete = false },
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
        completion = { autocomplete = false },
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = "buffer" },
        },
    })
end

return {
    -- https://github.com/hrsh7th/nvim-cmp
    "hrsh7th/nvim-cmp",
    dependencies = {
        luasnip_spec,
        "saadparwaiz1/cmp_luasnip",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-path",
    },
    config = function()
        configure_global_completion()
        configure_command_line_completion()
        configure_search_completion()
    end,
}
