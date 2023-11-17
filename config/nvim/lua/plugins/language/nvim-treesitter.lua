local opts = {
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
}

return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
    },
    opts = opts,
    version = false,
}
