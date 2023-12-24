-- Formatting on save
--
-- https://github.com/stevearc/conform.nvim

local ruby_formatters = {
    home = { "standardrb" },
    work = { "prettierd" },
}

local opts = {
    formatters_by_ft = {
        css = { "prettierd" },
        html = { "prettierd" },
        javascript = { "prettierd" },
        json = { "prettierd" },
        lua = { "stylua" },
        ruby = ruby_formatters[os.getenv("DOTFILES_ENV")],
        typescript = { "prettierd" },
        typescriptreact = { "prettierd" },

        -- This will run if no other formatters are configured.
        ["_"] = { "trim_whitespace" },
    },
    format_on_save = {
        timeout_ms = 3000,
    },
    notify_on_error = true,
}

return {
    "stevearc/conform.nvim",
    opts = opts,
}
