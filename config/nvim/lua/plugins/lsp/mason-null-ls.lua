-- Install formatters
--
-- https://github.com/jay-babu/mason-null-ls.nvim

local opts = {
    automatic_installation = true
}

return {
    "jay-babu/mason-null-ls.nvim",
    dependencies = {
        "williamboman/mason.nvim",
        "nvimtools/none-ls.nvim",
    },
    opts = opts,
}
