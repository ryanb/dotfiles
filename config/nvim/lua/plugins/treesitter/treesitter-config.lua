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
        auto_install = true,
        autotag = { enable = true },
        highlight = { enable = true },
        textobjects = textobjects,
    })
end

return config
