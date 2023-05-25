local function packadd(package)
    vim.cmd["packadd!"](package)
end

return packadd
