if vim.g.vscode then
-- vscode extension
else
	-- require("user.lazy")
	require("user.autocommands")

	require("user.options")
	require("user.autopairs")
	require("user.bufferline")
	require("user.cmp")
	require("user.comment")
	require("user.gitsigns")
	require("user.keymaps")
	require("user.leap")
	require("user.lsp")
	require("user.lualine")
	require("user.notes")
	require("user.plugins")
	require("user.prettier")
	require("user.telescope")
	require("user.theme")
	require("user.tree")
	require("user.treesitter")
	require("user.vimwiki")
	require("user.whichkey")
	-- require("user.ivan")
end
