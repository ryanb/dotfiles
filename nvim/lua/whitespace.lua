return {
    remove_trailing_whitespace_on_save = function()
        vim.api.nvim_create_augroup("removeTrailingWhitespace", { clear = true })
        vim.api.nvim_create_autocmd(
            "BufWritePre",
            {
                pattern = "*",
                group = "removeTrailingWhitespace",
                command = "%s/\\s\\+$//e"
            }
        )
    end
}
