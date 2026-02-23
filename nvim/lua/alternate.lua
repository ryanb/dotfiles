-- alternate.lua
-- A simple alternate file switcher that reads .projections.json from cwd
-- Works correctly with git worktrees (uses cwd, not git root)

local M = {}

local function read_projections()
	local cwd = vim.fn.getcwd()
	local path = cwd .. "/.projections.json"
	local file = io.open(path, "r")
	if not file then
		return nil
	end
	local content = file:read("*a")
	file:close()
	local ok, projections = pcall(vim.json.decode, content)
	if not ok then
		return nil
	end
	return projections
end

-- Convert projectionist glob pattern to lua pattern
-- e.g., "app/assets/javascripts/**/*.test.js" -> "^app/assets/javascripts/(.-)%.test%.js$"
local function glob_to_pattern(glob)
	local pattern = glob
	-- Escape lua pattern special chars (except * which we handle specially)
	pattern = pattern:gsub("([%.%+%-%?%^%$%(%)%[%]{}|\\])", "%%%1")
	-- Convert **/* to non-greedy capture group for any path
	pattern = pattern:gsub("%*%*/%*", "(.-)")
	-- Convert remaining ** to match any path
	pattern = pattern:gsub("%*%*", "(.-)")
	-- Convert remaining * to match any filename (non-greedy)
	pattern = pattern:gsub("%*", "([^/]-)")
	return "^" .. pattern .. "$"
end

-- Convert projectionist target to actual path
-- e.g., "app/assets/javascripts/{}.js" with capture "pos/data/indexedDB" -> "app/assets/javascripts/pos/data/indexedDB.js"
local function expand_target(target, captures)
	local result = target
	for _, capture in ipairs(captures) do
		result = result:gsub("{}", capture, 1)
	end
	return result
end

function M.find_alternate(filepath)
	local projections = read_projections()
	if not projections then
		return nil
	end

	-- Get relative path from cwd
	local cwd = vim.fn.getcwd()
	local relative = filepath
	if filepath:sub(1, #cwd) == cwd then
		relative = filepath:sub(#cwd + 2) -- +2 to skip the trailing /
	end

	-- Sort patterns by length (longer/more specific patterns first)
	local sorted_globs = {}
	for glob, _ in pairs(projections) do
		table.insert(sorted_globs, glob)
	end
	table.sort(sorted_globs, function(a, b)
		return #a > #b
	end)

	-- Try each projection pattern (most specific first)
	for _, glob in ipairs(sorted_globs) do
		local config = projections[glob]
		local pattern = glob_to_pattern(glob)
		local captures = { relative:match(pattern) }
		if #captures > 0 and captures[1] then
			local alternate = config.alternate
			if alternate then
				return expand_target(alternate, captures)
			end
		end
	end

	return nil
end

function M.alternate(create_if_missing)
	local current = vim.fn.expand("%:p")
	local alternate = M.find_alternate(current)

	if not alternate then
		vim.notify("No alternate file found", vim.log.levels.WARN)
		return
	end

	local cwd = vim.fn.getcwd()
	local full_path = cwd .. "/" .. alternate

	if vim.fn.filereadable(full_path) == 1 then
		vim.cmd("edit " .. vim.fn.fnameescape(full_path))
	elseif create_if_missing then
		-- Create parent directories if needed
		local dir = vim.fn.fnamemodify(full_path, ":h")
		vim.fn.mkdir(dir, "p")
		vim.cmd("edit " .. vim.fn.fnameescape(full_path))
	else
		vim.notify("Alternate file does not exist: " .. alternate, vim.log.levels.WARN)
	end
end

function M.setup()
	vim.api.nvim_create_user_command("A", function(opts)
		M.alternate(opts.bang)
	end, { bang = true, desc = "Switch to alternate file" })

	vim.keymap.set("n", "ga", "<cmd>A<cr>", { desc = "Toggle alternate file" })
	vim.keymap.set("n", "gA", "<cmd>A!<cr>", { desc = "Toggle alternate (create if missing)" })
end

return M
