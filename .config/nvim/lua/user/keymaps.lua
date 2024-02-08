local opts = { noremap = true, silent = true }
-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- themes
function _G.dark_theme()
	vim.cmd(
		"!osascript -e 'tell application \"System Events\" to tell appearance preferences to set dark mode to true'"
	)
	vim.cmd("!sed -i.bak 's/\\(colors:\\ \\*\\).*$/\\1nord/' ~/projects/dotfiles/.config/alacritty/alacritty.yml")
	vim.o.background = "dark"
end

function _G.light_theme()
	vim.cmd(
		"!osascript -e 'tell application \"System Events\" to tell appearance preferences to set dark mode to false'"
	)
	vim.cmd("!sed -i.bak 's/\\(colors:\\ \\*\\).*$/\\1latte/' ~/projects/dotfiles/.config/alacritty/alacritty.yml")
	vim.o.background = "light"
end

function _G.ReloadConfig()
	for name, _ in pairs(package.loaded) do
		if name:match("^user") and not name:match("nvim-tree") then
			package.loaded[name] = nil
		end
	end

	dofile(vim.env.MYVIMRC)
	vim.notify("Nvim configuration reloaded!", vim.log.levels.INFO)
end

keymap("n", "<leader>c", "<cmd>source $MYVIMRC<cr>", opts)

keymap("n", "<leader>w", "<cmd>w<CR>", opts)
keymap("n", "<leader>W", "<cmd>wa<CR>", opts)
keymap("n", "<leader>q", "<cmd>qa<CR>", opts)
keymap("n", "<leader>Q", "<cmd>qa!<CR>", opts)
keymap("i", "jk", "<ESC>", opts)
keymap("n", "<C-d>", "<C-d>zz", opts)
keymap("n", "<C-u>", "<C-u>zz", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)
keymap("n", "<leader>c", ":bd<cr>", opts)
keymap("n", "<leader>C", ":%bd|e#|bd#<cr>", opts)
keymap("n", "<leader>o", ":only<cr>", opts)

-- Navigate windows
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-l>", "<C-w>l", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)

-- Move lines up/down
keymap("n", "∆", ":m +1<cr>", opts) -- Alt-j in Mac OS
keymap("n", "˚", ":m -2<cr>", opts) -- Alt-k in Mac OS

-- Nvim Tree
keymap("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", opts)

-- telescope
-- alt + p
-- keymap("n", "π", "<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false }))<cr>", opts)
keymap("n", "<leader>ff", "<cmd>lua require'telescope.builtin'.find_files({ hidden = true })<cr>", opts)
keymap("n", "<leader>fk", "<cmd>lua require'telescope.builtin'.keymaps()<cr>", opts)
-- keymap("n", "<leader>fg", "<cmd>lua require'telescope.builtin'.live_grep()<cr>", opts)
keymap("n", "<leader>fg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", opts)
keymap("n", "<leader>fh", "<cmd>lua require'telescope.builtin'.help_tags()<cr>", opts)
keymap("n", "<leader>fb", "<cmd>lua require'telescope.builtin'.buffers()<cr>", opts)
keymap("n", "<leader>fd", "<cmd>lua require'telescope.builtin'.diagnostics()<cr>", opts)
keymap("n", "<leader>fm", "<cmd>lua require'telescope.builtin'.marks()<cr>", opts)
keymap("n", "<leader>fs", "<cmd>lua require'telescope.builtin'.git_status()<cr>", opts)
keymap("n", "<leader>ft", "<cmd>lua require'telescope.builtin'.git_stash()<cr>", opts)
keymap("n", "<leader>gd", "<cmd>lua require'telescope.builtin'.lsp_definitions()<cr>", opts)
keymap("n", "<leader>gt", "<cmd>lua require'telescope.builtin'.lsp_type_definitions()<cr>", opts)
keymap("n", "<leader>gr", "<cmd>lua require'telescope.builtin'.lsp_references()<cr>", opts)
keymap("n", "<leader>gi", "<cmd>lua require'telescope.builtin'.lsp_implementations()<cr>", opts)
keymap("n", "<leader>gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)

-- Reload config
keymap("n", "<leader><leader>", "<cmd>lua ReloadConfig()<CR>", { noremap = true, silent = false })

-- LSP
keymap("n", "<leader>ln", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
keymap("n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
keymap("n", "<leader>lD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
keymap("n", "<leader>ld", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
keymap("n", "<leader>lh", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
keymap("n", "<leader>li", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
keymap("n", "<leader>lr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
keymap("n", "<leader>lc", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
keymap("n", "<leader>lk", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
-- keymap("n", "[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>', opts)
-- keymap(
--   "n",
--   "gl",
--   '<cmd>lua vim.diagnostic.open_float({ border = "rounded" })<CR>',
--   opts
-- )
-- keymap("n", "]d", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', opts)
-- keymap("n", "gL", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)

-- Terminal
keymap("n", "<leader>tt", "<cmd>ToggleTerm size=10 direction=horizontal<cr>", opts)

-- Harpoon

keymap("n", "<C-1>", "mA", opts)
keymap("n", "<C-2>", "mB", opts)
keymap("n", "<C-3>", "mC", opts)
keymap("n", "<C-4>", "mD", opts)
keymap("n", "<C-5>", "mE", opts)
keymap("n", "<C-6>", "mF", opts)
keymap("n", "<C-7>", "mG", opts)
keymap("n", "<C-8>", "mH", opts)
keymap("n", "<C-9>", "mI", opts)

keymap("n", "<leader>1", "`A", opts)
keymap("n", "<leader>2", "`B", opts)
keymap("n", "<leader>3", "`C", opts)
keymap("n", "<leader>4", "`D", opts)
keymap("n", "<leader>5", "`E", opts)
keymap("n", "<leader>6", "`F", opts)
keymap("n", "<leader>7", "`G", opts)
keymap("n", "<leader>8", "`H", opts)
keymap("n", "<leader>9", "`I", opts)
