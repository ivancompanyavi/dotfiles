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
    'https://github.com/stevearc/oil.nvim',

    -- Navigation
    'https://codeberg.org/andyg/leap.nvim',
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

    -- Git integration
    'https://github.com/lewis6991/gitsigns.nvim',

    -- Project/workspace management
    'https://github.com/ahmedkhalf/project.nvim',

    -- Formatting
    'https://github.com/stevearc/conform.nvim',
}, {
    load = true,
    confirm = false,
})

-- User commands for vim.pack
vim.api.nvim_create_user_command("PackUpdate", function() vim.pack.update() end, { desc = "Update all plugins" })
vim.api.nvim_create_user_command("PackList", function() print(vim.inspect(vim.pack.get())) end, { desc = "List plugins" })

-- LSP info commands
vim.api.nvim_create_user_command("LspClients", function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients == 0 then
        print("No LSP clients attached to this buffer")
        return
    end
    for _, client in ipairs(clients) do
        print(string.format("• %s (id=%d)", client.name, client.id))
    end
end, { desc = "Show LSP clients for current buffer" })

vim.api.nvim_create_user_command("LspCapabilities", function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients == 0 then
        print("No LSP clients attached")
        return
    end
    for _, client in ipairs(clients) do
        print("=== " .. client.name .. " ===")
        print(vim.inspect(client.server_capabilities))
    end
end, { desc = "Show LSP capabilities for current buffer" })

-- Load personal configuration
require("ivan")
