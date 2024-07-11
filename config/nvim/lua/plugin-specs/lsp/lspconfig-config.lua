-- Configure nvim-lspconfig to use the language servers I want.
return function()
    local lspconfig = require("lspconfig")

    -- The language servers need to know what capabilities our completion
    -- system supports. This fetches the capabilities to pass along to them.
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    local opts = { capabilities = capabilities }

    local dotfiles_env = os.getenv("DOTFILES_ENV")

    if dotfiles_env == "home" then
        lspconfig.bashls.setup(opts)
        lspconfig.eslint.setup(opts)
        lspconfig.ruby_lsp.setup(opts)
        lspconfig.standardrb.setup(opts)
        lspconfig.tsserver.setup(opts)
    end

    if dotfiles_env == "work" then
        lspconfig.bashls.setup(opts)
        lspconfig.eslint.setup(opts)
        lspconfig.relay_lsp.setup(opts)
        lspconfig.sorbet.setup(opts)
        lspconfig.tsserver.setup(opts)
    end

    -- Set the diagnostic signs shown in the gutter to match lualine's.
    vim.fn.sign_define("DiagnosticSignError", { text = "󰅚 ", texthl = "DiagnosticSignError" })
    vim.fn.sign_define("DiagnosticSignWarn", { text = "󰀪 ", texthl = "DiagnosticSignWarn" })
    vim.fn.sign_define("DiagnosticSignInfo", { text = "󰋽 ", texthl = "DiagnosticSignInfo" })
    vim.fn.sign_define("DiagnosticSignHint", { text = "󰌶", texthl = "DiagnosticSignHint" })

    -- Language servers can also be configured on a per-project basis using
    -- exrc. See the .nvim.lua file in .dotfiles for an example.
end
