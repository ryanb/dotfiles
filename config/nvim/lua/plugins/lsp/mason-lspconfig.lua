-- Install language servers
--
-- https://github.com/williamboman/mason-lspconfig.nvim

local opts = {
    automatic_installation = true,
}

return {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
        "williamboman/mason.nvim",
    },
    opts = opts,
}
