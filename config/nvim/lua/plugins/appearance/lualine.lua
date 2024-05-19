-- A fancy status line
--
-- https://github.com/nvim-lualine/lualine.nvim

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

local opts = {
    extensions = { "lazy", "neo-tree", "man", "mason", "quickfix" },
    options = { globalstatus = true },
    sections = {
        lualine_a = { "mode" },
        lualine_b = { "diagnostics" },
        lualine_c = { { "filename", path = 1, on_click = copy_relative_path } },
        lualine_x = { "branch" },
        lualine_y = { "searchcount" },
        lualine_z = { position },
    },
}

return { "nvim-lualine/lualine.nvim", opts = opts }
