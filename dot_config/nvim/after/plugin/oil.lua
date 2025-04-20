require("oil").setup({
	float = {
		max_width = 0.7,
		max_height = 0.7,
		win_options = {
			winblend = 0
		}
	}
})

vim.keymap.set("n", "<leader>e", "<CMD>Oil --float<CR>")
