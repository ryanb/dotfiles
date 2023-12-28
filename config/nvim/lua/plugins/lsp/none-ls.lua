local function config()
    local null_ls = require("null-ls")

    local diagnostics = null_ls.builtins.diagnostics
    local formatting = null_ls.builtins.formatting

    local sources = {
        home = {
            diagnostics.shellcheck,
            formatting.prettierd.with({
                disabled_filetypes = { "ruby" },
            }),
            formatting.standardrb,
            formatting.stylua,
            formatting.trim_whitespace,
        },
        work = {
            diagnostics.shellcheck,
            formatting.prettierd,
            formatting.stylua,
            formatting.trim_whitespace,
        },
    }

    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

    local function on_attach(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format()
                end,
            })
        end
    end

    null_ls.setup({
        sources = sources[os.getenv("DOTFILES_ENV")],
        on_attach = on_attach,
    })
end

return {
    "nvimtools/none-ls.nvim",
    config = config,
    dependencies = { "nvim-lua/plenary.nvim" },
}
