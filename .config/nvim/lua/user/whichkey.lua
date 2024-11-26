local theme = require("user.theme")

local wk_status_ok, wk = pcall(require, "which-key")
if not wk_status_ok then
	return
end

local function set_dark_mode()
	vim.cmd(
		"!osascript -e 'tell application \"System Events\" to tell appearance preferences to set dark mode to true'"
	)
	vim.cmd("colorscheme " .. theme.colorscheme)
	vim.cmd("set background=dark")
	vim.cmd("hi Normal guibg=NONE ctermbg=NONE")
end

local function set_light_mode()
	vim.cmd(
		"!osascript -e 'tell application \"System Events\" to tell appearance preferences to set dark mode to false'"
	)
	vim.cmd("colorscheme " .. theme.colorscheme)
	vim.cmd("set background=light")
	vim.cmd("hi Normal guibg=NONE ctermbg=NONE")
end

wk.add({
	{ "<leader>xd", set_dark_mode, desc = "Dark mode" },
	{ "<leader>xl", set_light_mode, desc = "Light theme" },
})
