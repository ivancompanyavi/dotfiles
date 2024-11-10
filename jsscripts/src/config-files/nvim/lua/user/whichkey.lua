local theme = require("user.theme")

local wk_status_ok, wk = pcall(require, "which-key")
if not wk_status_ok then
	return
end

wk.register({
	x = {
		d = {
			function()
				-- vim.o.background = 'dark'
				vim.cmd(
					"!osascript -e 'tell application \"System Events\" to tell appearance preferences to set dark mode to true'"
				)
				vim.cmd("colorscheme " .. theme.colorscheme)
				vim.cmd("set background=dark")
				vim.cmd("hi Normal guibg=NONE ctermbg=NONE")
			end,
			"Dark theme",
		},
		l = {
			function()
				-- vim.o.background = 'light'
				vim.cmd(
					"!osascript -e 'tell application \"System Events\" to tell appearance preferences to set dark mode to false'"
				)
				-- vim.cmd("colorscheme tokyonight-day")
				vim.cmd("colorscheme " .. theme.colorscheme)
				vim.cmd("set background=light")
				vim.cmd("hi Normal guibg=NONE ctermbg=NONE")
			end,
			"Light theme",
		},
	},
}, { prefix = "<leader>" })
