-- Install language servers
--
-- https://github.com/williamboman/mason-lspconfig.nvim

local opts = {
    ensure_installed = {
        "eslint",
        "lua_ls",
        "rubocop",
        "solargraph",
        "sorbet",
        "tsserver",
    },
}

return {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
        "williamboman/mason.nvim",
    },
    opts = opts,
}
