local function copy_relative_path()
    local path = vim.fn.expand("%:.")
    vim.fn.setreg("+", path)
    vim.notify("Path copied: " .. path)
end

local function position()
    local current = vim.fn.line(".")
    local total = vim.fn.line("$")
    return string.format("%d/%d", current, total)
end

return {
    extensions = { "lazy", "man", "mason", "quickfix" },
    options = { disabled_filetypes = { "neo-tree" } },
    sections = {
        lualine_a = { "mode" },
        lualine_b = { "diagnostics" },
        lualine_c = { { "filename", on_click = copy_relative_path, path = 1, shorting_target = 20 } },
        lualine_x = { "branch" },
        lualine_y = { "searchcount" },
        lualine_z = { position },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { "filename", path = 1, shorting_target = 0 } },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
    },
}
