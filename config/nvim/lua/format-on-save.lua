local function configure()
    -- Use these clients to format code on save.
    local formatters = { "null-ls", "syntax_tree" }
    local filter_formatters = function(client)
        if vim.list_contains(formatters, client.name) then
            vim.notify("Formatting with " .. client.name .. ".")
            return true
        else
            return false
        end
    end

    -- Install the hook that formats on save.
    local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })
    vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        callback = function()
            vim.lsp.buf.format({ filter = filter_formatters })
        end,
    })

    -- This disables showing inline diagnostics for standardrb. They're too
    -- noisy, and I'm formatting on save so they'll go away anyway.
    vim.api.nvim_create_autocmd("LspAttach", {
        group = augroup,
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client.name == "standardrb" then
                local diagnostic_namespace = vim.lsp.diagnostic.get_namespace(client.id)
                vim.diagnostic.enable(false, { ns_id = diagnostic_namespace })
            end
        end,
    })
end

return { configure = configure }
