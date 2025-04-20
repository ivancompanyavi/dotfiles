-- lua/hello_world.lua
local M = {}

--- Show “Hello world” in a centered floating window
function M.show()
	-- 1) create a scratch buffer
	local buf = vim.api.nvim_create_buf(false, true)

	-- 2) determine window size & position
	local text = "Hello world"
	local width = #text
	local height = 1
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	-- 3) open a minimal floating window
	vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		style    = "minimal",
		width    = width,
		height   = height,
		row      = row,
		col      = col,
	})

	-- 4) set the buffer’s text
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, { text })
end

return M
