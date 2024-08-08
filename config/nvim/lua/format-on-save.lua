local function configure()
    -- Use these clients to format code on save.
    local formatters = { "null-ls", "syntax_tree" }
    local filter_formatters = function(client)
        return vim.list_contains(formatters, client.name)
    end

    -- Install the hook that formats on save.
    local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        callback = function()
            vim.lsp.buf.format({ filter = filter_formatters })
        end,
    })
end

return { configure = configure }
