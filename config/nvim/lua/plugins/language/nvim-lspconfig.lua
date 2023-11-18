local function config()
    local lspconfig = require("lspconfig")

    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- I need to figure out how to make these behave on a per-project basis.
    -- This might help: https://github.com/tamago324/nlsp-settings.nvim

    lspconfig.lua_ls.setup({ capabilities = capabilities })

    -- lsp.ruby_ls.setup({
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
