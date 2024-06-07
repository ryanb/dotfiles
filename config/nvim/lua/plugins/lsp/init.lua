local mason_spec = {
    "williamboman/mason.nvim",
    build = function()
        -- After install, synchronously refresh the registry of packages so
        -- mason-lspconfig and mason-null-ls can install things.
        require("mason-registry").refresh()
    end,
    opts = { PATH = "append" },
}

-- This must be set up _before_ nvim-lspconfig, so the nvim-lspconfig spec must
-- depend on this one.
local mason_lspconfig_spec = {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { mason_spec },
    opts = { automatic_installation = true },
}

local lspconfig_spec = {
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/cmp-nvim-lsp", mason_lspconfig_spec },
    config = require("plugins/lsp/lspconfig-config"),
}

local null_ls_spec = {
    "nvimtools/none-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = require("plugins/lsp/null-ls-config"),
}

-- This must be set up _after_ null-ls, so this spec must depend on the null-ls
-- spec.
local mason_null_ls_spec = {
    "jay-babu/mason-null-ls.nvim",
    dependencies = { mason_spec, null_ls_spec },
    opts = { automatic_installation = true },
}

return {
    lspconfig_spec,
    mason_null_ls_spec,
}
