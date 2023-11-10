local packadd = require("helpers").packadd

local function configure()
    packadd("neoformat") -- https://github.com/sbdchd/neoformat

    -- Look for formatters in node_modules/.bin
    vim.g.neoformat_try_node_exe = true

    -- Remove trailing whitespace on save.
    vim.g.neoformat_basic_format_trim = true

    vim.api.nvim_create_augroup("neoformatOnSave", {clear = true})
    vim.api.nvim_create_autocmd(
        "BufWritePre",
        {
            group = "neoformatOnSave",
            command = "Neoformat"
        }
    )
end

return {configure = configure}
