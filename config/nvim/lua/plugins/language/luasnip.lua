local function config()
    local luasnip = require("luasnip")
    luasnip.filetype_extend("ruby", { "rails" })
end

return {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    config = config,
    dependencies = {
        "rafamadriz/friendly-snippets",
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
        end,
    },
}
