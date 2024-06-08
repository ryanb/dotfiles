local treesitter_textobjects = {
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
            ["<leader>mp"] = { query = "@parameter.inner", desc = "move paramater forward" },
        },
        swap_previous = {
            ["<leader>mP"] = { query = "@parameter.inner", desc = "move parameter backward" },
        },
    },
}

local treesitter_spec = {
    -- https://github.com/nvim-treesitter/nvim-treesitter
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
        -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects
        "nvim-treesitter/nvim-treesitter-textobjects",
        -- https://github.com/windwp/nvim-ts-autotag
        "windwp/nvim-ts-autotag",
    },
    build = ":TSUpdate",
    config = function()
        local treesitter = require("nvim-treesitter.configs")
        treesitter.setup({
            auto_install = true,
            autotag = { enable = true },
            highlight = { enable = true },
            textobjects = treesitter_textobjects,
        })
    end,
}

local refactoring_spec = {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        treesitter_spec,
    },
    config = function()
        require("refactoring").setup()
    end,
}

local treesj_spec = {
    "Wansmer/treesj",
    dependencies = { treesitter_spec },
    opts = { use_default_keymaps = false },
}

return { refactoring_spec, treesj_spec }
