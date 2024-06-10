return function()
    local null_ls = require("null-ls")
    local formatting = null_ls.builtins.formatting

    local sources = {}
    local dotfiles_env = os.getenv("DOTFILES_ENV")

    if dotfiles_env == "home" then
        sources = {
            formatting.prettierd.with({
                disabled_filetypes = { "ruby" },
            }),
            formatting.stylua,
        }
    end

    if dotfiles_env == "work" then
        sources = {
            formatting.prettierd.with({
                disabled_filetypes = { "yaml" },
                extra_filetypes = { "ruby" },
            }),
            formatting.stylua,
        }
    end

    local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })

    null_ls.setup({
        sources = sources,
        on_attach = function(client, bufnr)
            if client.supports_method("textDocument/formatting") then
                vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                vim.api.nvim_create_autocmd("BufWritePre", {
                    group = augroup,
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format({ name = "null-ls" })
                    end,
                })
            end
        end,
    })
end
