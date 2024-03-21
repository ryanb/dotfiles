-- Language server configuration
--
-- https://github.com/neovim/nvim-lspconfig

-- Select the language servers we want to use for home and work.
local function choose_servers()
    local lspconfig = require("lspconfig")

    local servers = {
        home = {
            lspconfig.bashls,
            lspconfig.eslint,
            lspconfig.solargraph,
            lspconfig.standardrb,
            lspconfig.tsserver,
        },
        work = {
            lspconfig.bashls,
            lspconfig.eslint,
            lspconfig.rubocop,
            lspconfig.sorbet,
            lspconfig.tsserver,
        },
    }

    -- For other language servers see:
    -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

    return servers[os.getenv("DOTFILES_ENV")]
end

local function config()
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    local servers = choose_servers()
    for _, server in ipairs(servers) do
        server.setup({ capabilities = capabilities })
    end

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
