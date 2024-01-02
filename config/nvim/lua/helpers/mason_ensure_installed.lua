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

-- Mason doesn't come with a built-in way to ensure packages are installed, but this does the job.
local function ensure_installed(package_names)
    local registry = require("mason-registry")

    registry.refresh(function()
        for _, package_name in ipairs(package_names) do
            if not registry.is_installed(package_name) then
                install(registry.get_package(package_name))
            end
        end
    end)
end

return ensure_installed
