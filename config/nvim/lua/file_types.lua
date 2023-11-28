local function lua()
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 4
    vim.bo.softtabstop = 4
end

local function configure()
    local group = vim.api.nvim_create_augroup("fileTypeOptions", { clear = true })

    vim.api.nvim_create_autocmd("FileType", {
        pattern = "lua",
        callback = lua,
        group = group,
    })
end

return { configure = configure }
