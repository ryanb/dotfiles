-- Language server support
--
-- https://github.com/neovim/nvim-lspconfig

local function config()
    local lspconfig = require("lspconfig")
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- These can be configured on a per-project basis using exrc.
    -- See the .nvim.lua file in .dotfiles for an example.

    -- lspconfig.ruby_ls.setup({
    --     cmd = { "bundle", "exec", "ruby-lsp" },
    --    capabilities = capabilities,
    -- })

    lspconfig.sorbet.setup({
        cmd = { "bundle", "exec", "srb", "tc", "--lsp" },
        capabilities = capabilities,
    })

    lspconfig.tsserver.setup({
        cmd = { "npx", "typescript-language-server", "--stdio" },
        capabilities = capabilities,
    })

    -- For other language servers see:
    -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
end

return {
    "neovim/nvim-lspconfig",
    config = config,
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
}
