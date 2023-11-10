local function configure_plugin(name)
    require("plugins/" .. name).configure()
end

local function packadd(package)
    vim.cmd("packadd! " .. package)
end

return {
    configure_plugin = configure_plugin,
    bind = vim.keymap.set,
    packadd = packadd
}
