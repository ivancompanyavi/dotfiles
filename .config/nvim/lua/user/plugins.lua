vim.fn.setenv("MACOSX_DEPLOYMENT_TARGET", "10.15")
local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

return packer.startup(function(use)
	use("wbthomason/packer.nvim") -- Have packer manage itself
	use("nvim-lua/plenary.nvim") -- Useful lua functions used ny lots of plugins
	use({ "akinsho/bufferline.nvim", tag = "v2.*", requires = "kyazdani42/nvim-web-devicons" })
	use {
		'nvim-tree/nvim-tree.lua',
		requires = {
		  'nvim-tree/nvim-web-devicons', -- optional
		},
	  }
	use({
		"nvim-lualine/lualine.nvim",
		requires = { "kyazdani42/nvim-web-devicons", opt = true },
	})
	use({
		"windwp/nvim-autopairs",
	})
	-- cmp plugins
	use({ "hrsh7th/nvim-cmp" })
	use("hrsh7th/cmp-buffer") -- buffer completions
	use("hrsh7th/cmp-path") -- path completions
	use("hrsh7th/cmp-cmdline") -- cmdline completions
	use("saadparwaiz1/cmp_luasnip") -- snippet completions
	use("hrsh7th/cmp-nvim-lsp")
	use("L3MON4D3/LuaSnip") -- Code snippets
	use("folke/which-key.nvim")
	use("tpope/vim-fugitive") -- Git
	use("numToStr/Comment.nvim") -- comments
	use("lewis6991/gitsigns.nvim")
	use("MunifTanjim/prettier.nvim")

	use({
		"iamcco/markdown-preview.nvim",
		run = "cd app && npm install",
		setup = function()
			vim.g.mkdp_filetypes = { "markdown", "notes" }
		end,
		ft = { "markdown" },
	})

	-- LSP
	use("neovim/nvim-lspconfig") -- enable LSP
	use("williamboman/nvim-lsp-installer") -- simple to use language server installer
	use("tamago324/nlsp-settings.nvim") -- language server settings defined in json for
	use("jose-elias-alvarez/null-ls.nvim") -- for formatters and linters
	use("jose-elias-alvarez/nvim-lsp-ts-utils")

	-- Telescope
	use({
		"nvim-telescope/telescope-fzf-native.nvim",
		run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
	})

	use({
		"nvim-telescope/telescope.nvim",
		requires = {
			{ "nvim-telescope/telescope-live-grep-args.nvim" },
		},
		config = function()
			require("telescope").load_extension("live_grep_args")
		end,
	})

	use({
		"nvim-treesitter/nvim-treesitter", -- Better syntax highlighting
		run = ":TSUpdate",
	})
	use("JoosepAlviste/nvim-ts-context-commentstring") -- Better comments
	use("vimwiki/vimwiki")
	use({
		"kylechui/nvim-surround", -- surround texts
		tag = "*", -- Use for stability; omit to use `main` branch for the latest features
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	})
	use("ggandor/leap.nvim")
	use("NvChad/nvim-colorizer.lua")
	-- Themes
	use("folke/tokyonight.nvim")
	use("github/copilot.vim")
	use("folke/neodev.nvim")
	-- use({ "~/projects/personal/nvim-plugin", rocks = "http" })

	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
