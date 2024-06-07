-- Select the formatters we want to use for home and work.
local function choose_sources()
    local null_ls = require("null-ls")
    local formatting = null_ls.builtins.formatting

    local sources = {
        home = {
            formatting.prettierd.with({
                disabled_filetypes = { "ruby" },
            }),
            formatting.stylua,
        },
        work = {
            formatting.prettierd.with({
                disabled_filetypes = { "yaml" },
                extra_filetypes = { "ruby" },
            }),
            formatting.stylua,
        },
    }

    return sources[os.getenv("DOTFILES_ENV")]
end

-- Generate a callback to run the formatter on save.
local function generate_on_attach_callback()
    local augroup = vim.api.nvim_create_augroup("LspFormatting", { clear = true })

    local function on_attach(client, bufnr)
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
    end

    return on_attach
end

local function config()
    local null_ls = require("null-ls")
    null_ls.setup({
        sources = choose_sources(),
        on_attach = generate_on_attach_callback(),
    })
end

return config
