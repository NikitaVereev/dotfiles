-- ============
-- TITLE: Utility Functions
-- ABOUT: Custom helper functions for Go tests, line number, and GitHub URL generation
-- ============

local M = {}

-- Toggle between Go Source file and its corresponding test file
M.toggle_go_test = function()
	local current_file = vim.fn.expand("%:p") -- Get absolute path of current file
	if string.match(current_file, "_test.go$") then
		-- Currently in test file, switch to source file
		local non_test_file = string.gsub(current_file, "_test.go$", ".go")
		if vim.fn.filereadable(non_test_file) == 1 then
			vim.cmd.edit(non_test_file)
		else
			print("No corresponding non-test file found")
		end
	else
		-- Currently in source file, switch to test file
		local test_file = string.gsub(current_file, ".go$", "_test.go")
		if vim.fn.filereadable(test_file) == 1 then
			vim.cmd.edit(test_file)
		else
			print("No corresponding test file found")
		end
	end
end

-- Get line numbers for visual selection (outputs GitHub-style L80 or L80-85)
M.get_highlighted_line_numbers = function()
	local start_line = vim.fn.line("'<") -- Start of visual selection
	local end_line = vim.fn.line("'>") -- End of visual selection

	if start_line == 0 or end_line == 0 then
		print("No visual selection found")
		return
	end

	-- Normalize order (handle reverse selection)
	if start_line > end_line then
		start_line, end_line = end_line, start_line
	end

	local line_numbers = {}
	for i = start_line, end_line do
		table.insert(line_numbers, i)
	end

	local result
	if start_line == end_line then
		-- Single line: L80
		result = string.format("L%d", start_line)
	else
		-- Multiple lines: L80-85
		result = string.format("L%d-%d", start_line, end_line)
	end

	print("Line numbers: " .. result)

	-- Copy to clipboard
	vim.fn.setreg("+", result)

	return line_numbers
end

-- Copy current file path with line number as GitHub URL (or local path if not in repo)
M.copyFilePathAndLineNumber = function()
	local current_file = vim.fn.expand("%:p") -- Absolute file path
	local current_line = vim.fn.line(".") -- Current line number
	local is_git_repo = vim.fn.system("git rev-parse --is-inside-work-tree"):match("true")

	if is_git_repo then
		-- Inside Git repositoty: generate GitHub URL
		local current_repo = vim.fn.systemlist("git remote get-url origin")[1]
		local current_branch = vim.fn.systemlist("git rev-parse --abbrev-ref HEAD")[1]

		-- Convert SSH URL to HTTPS format
		current_repo = current_repo:gsub("git@github.com:", "https://github.com/")
		current_repo = current_repo:gsub("%.git$", "")

		-- Git relative path from repository root
		local repo_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
		if repo_root then
			current_file = current_file:sub(#repo_root + 2) -- Remove leading path + separator
		end

		-- Bould GitHub URL: https://github.com/user/repo/blob/branch/path/file.ts#L42
		local url = string.format("%s/blob/%s/%s#L%s", current_repo, current_branch, current_file, current_line)
		vim.fn.setreg("+", url)
		print("Copied to clipboard: " .. url)
	else
		-- Not in Git repo: copy absolute path with line number
		vim.fn.setreg("+", current_file .. "#L" .. current_line)
		print("Copied full path to clipboard: " .. current_file .. "#L" .. current_line)
	end
end

return M
