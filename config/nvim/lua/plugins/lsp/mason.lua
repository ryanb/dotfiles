-- Tool for installing language servers, linters, etc.
--
-- https://github.com/williamboman/mason.nvim

local function install(package)
    package:once("install:success", function()
        vim.notify(
            string.format('"%s" was successfully installed.', package.name),
            vim.log.levels.INFO,
            { title = "mason" }
        )
    end)

    package:once("install:failed", function()
        vim.notify(string.format('"%s" failed to install', package.name), vim.log.levels.WARN, { title = "mason" })
    end)

    vim.notify(string.format('installing "%s"', package.name), vim.log.levels.INFO, { title = "mason" })

    package:install()
end

local function ensure_installed(package_names)
    local registry = require("mason-registry")

    for _, package_name in ipairs(package_names) do
        if not registry.is_installed(package_name) then
            install(registry.get_package(package_name))
        end
    end
end

local function config()
    local mason = require("mason")
    mason.setup({})

    -- I wish mason had an ensure_installed config option, but we can roll
    -- our own without too much trouble. Note that mason-lspconfig installs
    -- anything LSP related.
    local registry = require("mason-registry")
    registry.refresh(function()
        ensure_installed({ "shellcheck", "prettier", "prettierd" })
    end)
end

return {
    "williamboman/mason.nvim",
    config = config,
    dependencies = { "rcarriga/nvim-notify" },
}
