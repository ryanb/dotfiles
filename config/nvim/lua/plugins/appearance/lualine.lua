-- https://github.com/nvim-lualine/lualine.nvim

local function copy_relative_path()
    local path = vim.fn.expand("%:.")
    vim.fn.setreg("+", path)
    vim.notify("Path copied: " .. path)
end

local opts = {
    options = { theme = "auto" },
    sections = {
        lualine_c = { { "filename", path = 1, on_click = copy_relative_path } },
    },
}

local function init()
    vim.o.showmode = false -- Lualine shows the mode for us.
    vim.o.laststatus = 3 -- Use a full-width status line.
end

return { "nvim-lualine/lualine.nvim", init = init, opts = opts }
