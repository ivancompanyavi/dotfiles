-- Neovim 0.12+ Native Configuration
-- Using vim.pack for plugin management and native LSP

-- Set leaders before anything else
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Native plugin management with vim.pack (Neovim 0.12+)
vim.pack.add({
    -- Core dependencies (load first)
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/MunifTanjim/nui.nvim',
    'https://github.com/nvim-tree/nvim-web-devicons',

    -- Colorschemes
    'https://github.com/folke/tokyonight.nvim',

    -- LSP installer (still needed to install LSP binaries)
    'https://github.com/mason-org/mason.nvim',

    -- Completion
    { src = 'https://github.com/saghen/blink.cmp', version = 'v1.8.0' },

    -- Fuzzy finder
    'https://github.com/nvim-telescope/telescope.nvim',
    'https://github.com/nvim-telescope/telescope-fzf-native.nvim',

    -- File explorer
    'https://github.com/nvim-neo-tree/neo-tree.nvim',
    'https://github.com/stevearc/oil.nvim',

    -- Navigation
    'https://github.com/ggandor/leap.nvim',
    'https://github.com/otavioschwanck/arrow.nvim',

    -- Syntax highlighting
    'https://github.com/nvim-treesitter/nvim-treesitter',

    -- UI enhancements
    'https://github.com/akinsho/bufferline.nvim',
    'https://github.com/folke/which-key.nvim',
    'https://github.com/f-person/auto-dark-mode.nvim',
    'https://github.com/nvim-lualine/lualine.nvim',
    'https://github.com/lukas-reineke/indent-blankline.nvim',

    -- Code actions
    'https://github.com/Chaitanyabsprip/fastaction.nvim',

    -- Markdown preview
    'https://github.com/iamcco/markdown-preview.nvim',

    -- Ruby on Rails
    'https://github.com/tpope/vim-rails',
}, {
    load = true,
    confirm = false,
})

-- Load personal configuration
require("ivan")
