local function config()
    local lsp = require("lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")

    -- I need to figure out how to make these behave on a per-project basis.
    -- This might help: https://github.com/tamago324/nlsp-settings.nvim

    lsp.lua_ls.setup({ capabilities = cmp_nvim_lsp.default_capabilities() })

    -- lsp.ruby_ls.setup({
    --     cmd = { "bundle", "exec", "ruby-lsp" },
    -- })

    lsp.sorbet.setup({
        cmd = { "bundle", "exec", "srb", "tc", "--lsp" },
    })

    lsp.tsserver.setup({
        cmd = { "npx", "typescript-language-server", "--stdio" },
        capabilities = cmp_nvim_lsp.default_capabilities(),
    })

    -- For other language servers see:
    -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
end

return {
    "neovim/nvim-lspconfig",
    config = config,
    dependencies = { "sar/cmp-lsp.nvim" },
}
