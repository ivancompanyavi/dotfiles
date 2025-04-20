vim.opt.termguicolors = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 8     -- Always 8 (see :h tabstop)
vim.opt.softtabstop = 2 -- What you expecting
vim.opt.shiftwidth = 2  -- What you expecting
vim.opt.clipboard = "unnamedplus"

vim.cmd [[colorscheme tokyonight-moon]]

vim.cmd [[
  highlight Normal guibg=none
  highlight NonText guibg=none
  highlight Normal ctermbg=none
  highlight NonText ctermbg=none
]]



vim.api.nvim_create_augroup("LspFormatting", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
	group = "LspFormatting",
	callback = function()
		vim.lsp.buf.format({ async = false }) -- use async = true if you prefer
	end,
})
