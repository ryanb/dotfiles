-- Install lazy.nvim from Github.
local function install_lazy()
    -- This code comes from from Lazy's installation instructions:
    -- https://github.com/folke/lazy.nvim?tab=readme-ov-file#-installation
    local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
    if not vim.uv.fs_stat(lazypath) then
        vim.notify("Installing lazy.nvim...")
        vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable", -- latest stable release
            lazypath,
        })
    end

    vim.opt.rtp:prepend(lazypath)
end

-- Use lazy.nvim to install, load, and configure all our plugins based on
-- plugin specs in the lua/plugin-specs directory.
local function install_and_load_plugins(colorscheme)
    require("lazy").setup({
        spec = {
            -- Load everything from the lua/plugin-specs directory.
            import = "plugin-specs",
        },
        change_detection = {
            -- Don't throw up notifications whenever a config file changes.
            enabled = true,
            notify = false,
        },
        install = {
            -- Lazy tries to use this colorscheme during installation.
            colorscheme = { colorscheme },
        },
    })
end

return {
    install_lazy = install_lazy,
    install_and_load_plugins = install_and_load_plugins,
}
