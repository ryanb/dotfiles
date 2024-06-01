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
        goto_previous_start = {
            ["[p"] = { query = "@parameter.inner", desc = "previous parameter" },
            ["[m"] = { query = "@function.outer", desc = "previous function" },
        },
        goto_next_start = {
            ["]p"] = { query = "@parameter.inner", desc = "next parameter" },
            ["]m"] = { query = "@function.outer", desc = "next function" },
        },
    },
    select = {
        enable = true,
        lookahead = true,
        keymaps = {
            ["ap"] = { query = "@parameter.outer", desc = "a parameter" },
            ["ip"] = { query = "@parameter.inner", desc = "inner parameter" },
            ["af"] = { query = "@function.outer", desc = "a function" },
            ["if"] = { query = "@function.inner", desc = "inner function" },
        },
    },
    swap = {
        enable = true,
        swap_next = {
            ["<leader>mp"] = { query = "@parameter.inner", desc = "move paramater forward" },
        },
        swap_previous = {
            ["<leader>mP"] = { query = "@parameter.inner", desc = "move parameter backwards" },
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

    -- Make , and ; repeat the last move.
    local repeatable_move = require("nvim-treesitter.textobjects.repeatable_move")
    vim.keymap.set({ "n", "x", "o" }, ";", repeatable_move.repeat_last_move_next)
    vim.keymap.set({ "n", "x", "o" }, ",", repeatable_move.repeat_last_move_previous)

    -- Make repeating the builtins work properly too.
    vim.keymap.set({ "n", "x", "o" }, "f", repeatable_move.builtin_f)
    vim.keymap.set({ "n", "x", "o" }, "F", repeatable_move.builtin_F)
    vim.keymap.set({ "n", "x", "o" }, "t", repeatable_move.builtin_t)
    vim.keymap.set({ "n", "x", "o" }, "T", repeatable_move.builtin_T)
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
