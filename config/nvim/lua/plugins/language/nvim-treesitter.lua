-- https://github.com/nvim-treesitter/nvim-treesitter

local function config()
    local configs = require("nvim-treesitter.configs")

    configs.setup({
        ensure_installed = {
            "bash",
            "css",
            "graphql",
            "html",
            "javascript",
            "json",
            "jsonc",
            "lua",
            "ruby",
            "scss",
            "tsx",
            "typescript",
        },
        highlight = { enable = true },
        incremental_selection = { enable = true },
        textobjects = {
            select = {
                enable = true,
                lookahead = true,
                keymaps = {
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                },
            },
            move = {
                enable = true,
                set_jumps = true,
                goto_next_start = { ["]m"] = "@function.outer" },
                goto_next_end = { ["]M"] = "@function.outer" },
                goto_previous_start = { ["[m"] = "@function.outer" },
                goto_previous_end = { ["[M"] = "@function.outer" },
            },
        },
    })
end

return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = config,
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
    },
}
