-- Tool for installing language servers, linters, etc.
--
-- https://github.com/williamboman/mason.nvim

local function config()
    local mason = require("mason")
    mason.setup({})

    -- This installs things needed for none-ls.
    -- See also mason-lspconfig.lua, which installs language servers.
    local ensure_installed = require("helpers.mason_ensure_installed")
    ensure_installed({
        "prettier",
        "prettierd",
        "stylua",
    })
end

return {
    "williamboman/mason.nvim",
    config = config,
    dependencies = { "rcarriga/nvim-notify" },
}
