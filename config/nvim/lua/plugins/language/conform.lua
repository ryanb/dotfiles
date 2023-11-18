-- https://github.com/stevearc/conform.nvim

local opts = {
    formatters_by_ft = {
        css = { { "prettierd", "prettier" } },
        html = { { "prettierd", "prettier" } },
        javascript = { { "prettierd", "prettier" } },
        json = { { "prettierd", "prettier" } },
        lua = { "stylua" },
        ruby = { { "standardrb", "prettierd", "prettier" } },
        typescript = { { "prettierd", "prettier" } },
        typescriptreact = { { "prettierd", "prettier" } },
    },
    format_on_save = {
        lsp_fallback = true,
        timeout_ms = 10000,
    },
    notify_on_error = true,
}

return {
    "stevearc/conform.nvim",
    opts = opts,
}
