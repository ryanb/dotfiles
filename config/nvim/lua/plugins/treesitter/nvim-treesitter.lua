-- Fast parsing for syntax highlighting and text objects
--
-- https://github.com/nvim-treesitter/nvim-treesitter

-- Ensure all these parsers are loaded.
local parsers = {
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
}

-- Configuration for moving around by textobject.
local textobjects_move = {
    enable = true,
    set_jumps = true,
    goto_previous_start = {
        ["[a"] = {
            query = "@parameter.inner",
            desc = "previous argument",
        },
        ["[f"] = {
            query = "@function.outer",
            desc = "previous function",
        },
    },
    goto_next_start = {
        ["]a"] = {
            query = "@parameter.inner",
            desc = "next argument",
        },
        ["]f"] = {
            query = "@function.outer",
            desc = "next function",
        },
    },
}

-- Configuration for selecting textobjects.
local textobjects_select = {
    enable = true,
    lookahead = true,
    keymaps = {
        ["aa"] = { query = "@parameter.outer", desc = "an argument" },
        ["ia"] = { query = "@parameter.inner", desc = "inner argument" },
        ["af"] = { query = "@function.outer", desc = "a function" },
        ["if"] = { query = "@function.inner", desc = "inner function" },
    },
}

local function config()
    local configs = require("nvim-treesitter.configs")

    configs.setup({
        autotag = { enable = true },
        ensure_installed = parsers,
        highlight = { enable = true },
        incremental_selection = { enable = true },
        textobjects = {
            move = textobjects_move,
            select = textobjects_select,
        },
    })
end

return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = config,
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
        "windwp/nvim-ts-autotag",
    },
}
