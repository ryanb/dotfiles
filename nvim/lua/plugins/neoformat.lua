local function configure()
    vim.cmd.packadd({"neoformat", bang = true}) -- https://github.com/sbdchd/neoformat

    -- Look for formatters in node_modules/.bin
    vim.g.neoformat_try_node_exe = true

    -- Remove trailing whitespace on save.
    vim.g.neoformat_basic_format_trim = true

    local group = vim.api.nvim_create_augroup("neoformatOnSave", {clear = true})
    vim.api.nvim_create_autocmd("BufWritePre", {group = group, command = "Neoformat"})
end

return {configure = configure}
