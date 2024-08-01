-- Configure none-ls to use the formatters I want, and set it up to auto-format
-- on save.
return function()
    local null_ls = require("null-ls")
    local formatting = null_ls.builtins.formatting

    local sources = {}
    local dotfiles_env = os.getenv("DOTFILES_ENV")

    if dotfiles_env == "home" then
        sources = {
            formatting.prettierd,
            formatting.stylua,
        }
    end

    if dotfiles_env == "work" then
        sources = {
            formatting.prettierd.with({
                disabled_filetypes = { "yaml" },
            }),
            formatting.stylua,
        }
    end

    null_ls.setup({ sources = sources })
end
