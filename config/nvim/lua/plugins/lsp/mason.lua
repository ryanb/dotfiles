-- Tool for installing language servers, linters, etc.
--
-- https://github.com/williamboman/mason.nvim

local function config()
    local mason = require("mason")
    mason.setup({})

    local ensure_installed = require("helpers.mason_ensure_installed")
    ensure_installed({
        "prettier",
        "prettierd",
        "stylua",
    })

    -- See also mason-lspconfig.lua, which installs things related to LSP.
end

return {
    "williamboman/mason.nvim",
    config = config,
    dependencies = { "rcarriga/nvim-notify" },
}
