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
    "markdown",
    "markdown_inline",
    "regex",
    "ruby",
    "scss",
    "tsx",
    "typescript",
    "vim",
}

local textobjects = {
    move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
            ["]f"] = { query = "@function.outer", desc = "next function" },
            ["]p"] = { query = "@parameter.inner", desc = "next parameter" },
        },
        goto_previous_start = {
            ["[f"] = { query = "@function.outer", desc = "previous function" },
            ["[p"] = { query = "@parameter.inner", desc = "previous parameter" },
        },
    },
    select = {
        enable = true,
        lookahead = true,
        keymaps = {
            ["af"] = { query = "@function.outer", desc = "a function" },
            ["if"] = { query = "@function.inner", desc = "inner function" },
            ["ap"] = { query = "@parameter.outer", desc = "a parameter" },
            ["ip"] = { query = "@parameter.inner", desc = "inner parameter" },
        },
    },
    swap = {
        enable = true,
        swap_next = {
            ["<leader>mf"] = { query = "@function.outer", desc = "move function forward" },
            ["<leader>mp"] = { query = "@parameter.inner", desc = "move paramater forward" },
        },
        swap_previous = {
            ["<leader>mF"] = { query = "@function.outer", desc = "move function backward" },
            ["<leader>mP"] = { query = "@parameter.inner", desc = "move parameter backward" },
        },
    },
}

local function config()
    local configs = require("nvim-treesitter.configs")

    configs.setup({
        autotag = { enable = true },
        ensure_installed = parsers,
        highlight = { enable = true },
        textobjects = textobjects,
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
