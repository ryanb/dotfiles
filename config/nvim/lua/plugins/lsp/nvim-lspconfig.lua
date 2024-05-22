-- Language server configuration
--
-- https://github.com/neovim/nvim-lspconfig

local environments = {
    home = function(lspconfig)
        lspconfig.bashls.setup({})
        lspconfig.eslint.setup({})
        lspconfig.solargraph.setup({})
        lspconfig.standardrb.setup({})
        lspconfig.tsserver.setup({})
    end,

    work = function(lspconfig)
        lspconfig.bashls.setup({})
        lspconfig.eslint.setup({})
        lspconfig.relay_lsp.setup({})
        lspconfig.rubocop.setup({})
        lspconfig.sorbet.setup({})
        lspconfig.tsserver.setup({})
    end,
}

local function config()
    local lspconfig = require("lspconfig")

    -- Use the client capabilities for nvim-cmp with every server.
    -- See lspconfig-global-defaults in nvim-lspconfig help.
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    lspconfig.util.default_config =
        vim.tbl_extend("force", lspconfig.util.default_config, { capabilities = capabilities })

    -- Configure for the correct DOTFILES_ENV.
    environments[os.getenv("DOTFILES_ENV")](lspconfig)

    -- Language servers can be configured on a per-project basis using exrc.
    -- See the .nvim.lua file in .dotfiles for an example.
end

return {
    "neovim/nvim-lspconfig",
    config = config,
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "williamboman/mason-lspconfig.nvim",
    },
}
