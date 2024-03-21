-- Language server configuration
--
-- https://github.com/neovim/nvim-lspconfig

local function config()
    local lspconfig = require("lspconfig")
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- These can be configured on a per-project basis using exrc.
    -- See the .nvim.lua file in .dotfiles for an example.

    -- Bash
    lspconfig.bashls.setup({ capabilities = capabilities })

    -- Ruby
    local dotfiles_env = os.getenv("DOTFILES_ENV")
    if dotfiles_env == "home" then
        lspconfig.solargraph.setup({ capabilities = capabilities })
        lspconfig.standardrb.setup({ capabilities = capabilities })
    elseif dotfiles_env == "work" then
        lspconfig.rubocop.setup({ capabilities = capabilities })
        lspconfig.sorbet.setup({ capabilities = capabilities })
    end

    -- Typescript
    lspconfig.eslint.setup({ capabilities = capabilities })
    lspconfig.tsserver.setup({ capabilities = capabilities })

    -- For other language servers see:
    -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
end

return {
    "neovim/nvim-lspconfig",
    config = config,
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "williamboman/mason-lspconfig.nvim",
    },
}
