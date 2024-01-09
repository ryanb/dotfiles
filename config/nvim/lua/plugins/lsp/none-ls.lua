-- Use the language server system to call formatters when we save.
--
-- https://github.com/nvimtools/none-ls.nvim

-- Select the formatters we want to use for home and work.
local function choose_sources()
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

    return sources[os.getenv("DOTFILES_ENV")]
end

-- Generate a callback to run the formatter on save.
local function generate_on_attach_callback()
    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

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

return {
    "nvimtools/none-ls.nvim",
    config = config,
    dependencies = { "nvim-lua/plenary.nvim" },
}
