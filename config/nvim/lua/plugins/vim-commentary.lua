local function configure()
    vim.cmd.packadd({ "vim-commentary", bang = true })
end

return { configure = configure }
