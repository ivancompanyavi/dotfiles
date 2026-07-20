-- Plugin configurations for Native Neovim 0.12+
-- This file contains keymaps and additional setup
-- Using pcall for plugins that may not be loaded yet

--------------------------------------------------------------------------------
-- Colorscheme — driven by the shared theme system (~/.config/theme).
-- Applies the active theme now and wires live macOS polarity following +
-- :ThemeReload (see lua/ivan/theme.lua). Replaces the old hardcoded tokyonight
-- block and the separate auto-dark-mode.setup() call below.
--------------------------------------------------------------------------------
require("ivan.theme").setup()

--------------------------------------------------------------------------------
-- Mason (LSP installer)
--------------------------------------------------------------------------------
local ok, mason = pcall(require, "mason")
if ok then
    mason.setup()
end

--------------------------------------------------------------------------------
-- Blink.cmp (Completion)
--------------------------------------------------------------------------------
local ok, blink = pcall(require, "blink.cmp")
if ok then
    blink.setup({
        keymap = {
            ["<CR>"] = { "accept", "fallback" },
        },
        completion = {
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 250,
                treesitter_highlighting = true,
            },
            list = {
                selection = { preselect = false, auto_insert = true },
            },
        },
        signature = { enabled = true },
        sources = {
            default = { "lsp", "path", "snippets", "buffer" },
        },
    })
end

--------------------------------------------------------------------------------
-- Telescope keymaps
--------------------------------------------------------------------------------
local ok, telescope = pcall(require, "telescope.builtin")
if ok then
    vim.keymap.set("n", "<leader>ff", telescope.find_files, { desc = "Find files" })
    vim.keymap.set("n", "<leader>fgf", telescope.git_files, { desc = "Git files" })
    vim.keymap.set("n", "<leader>fgc", telescope.git_status, { desc = "Git status" })
    vim.keymap.set("n", "<leader>fgs", telescope.git_status, { desc = "Git status" })
    vim.keymap.set("n", "<leader>fs", telescope.live_grep, { desc = "Grep search" })
    vim.keymap.set("n", "<leader>fk", telescope.keymaps, { desc = "Search for keymaps" })
    vim.keymap.set("n", "<leader>vh", telescope.help_tags, { desc = "Neovim tags" })

    -- Load fzf extension if available
    pcall(function()
        require("telescope").load_extension("fzf")
    end)
end

--------------------------------------------------------------------------------
-- Oil
--------------------------------------------------------------------------------
local ok, oil = pcall(require, "oil")
if ok then
    oil.setup({
        view_options = {
            show_hidden = true,
        },
        float = {
            preview_split = "right",
            win_options = {
                winblend = 0,
            },
        },
    })
    vim.keymap.set("n", "<leader>e", "<CMD>Oil --float<CR>", { desc = "Oil file manager" })
end

--------------------------------------------------------------------------------
-- Leap
--------------------------------------------------------------------------------
pcall(function()
    -- New recommended way to set up leap mappings (replaces deprecated set_default_mappings)
    vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap-forward)')
    vim.keymap.set({ 'n', 'x', 'o' }, 'S', '<Plug>(leap-backward)')
    vim.keymap.set({ 'n', 'x', 'o' }, 'gs', '<Plug>(leap-from-window)')
end)

--------------------------------------------------------------------------------
-- Arrow
--------------------------------------------------------------------------------
local ok, arrow = pcall(require, "arrow")
if ok then
    arrow.setup({
        show_icons = true,
        leader_key = ";",
        buffer_leader_key = "m",
    })
end

--------------------------------------------------------------------------------
-- Treesitter
--------------------------------------------------------------------------------
local ok, treesitter = pcall(require, "nvim-treesitter.configs")
if ok then
    treesitter.setup({
        ensure_installed = {
            "python",
            "javascript",
            "typescript",
            "tsx",
            "lua",
            "ruby",
            "embedded_template",
            "go",
            "gomod",
            "gosum",
            "hcl",
            "terraform",
            "graphql",
            "json",
            "yaml",
            "toml",
            "markdown",
            "markdown_inline",
        },
        highlight = { enable = true },
    })
end

--------------------------------------------------------------------------------
-- Bufferline
--------------------------------------------------------------------------------
local ok, bufferline = pcall(require, "bufferline")
if ok then
    bufferline.setup()
end

--------------------------------------------------------------------------------
-- Lualine (status line)
--------------------------------------------------------------------------------
local ok, lualine = pcall(require, "lualine")
if ok then
    lualine.setup({
        options = {
            theme = "auto",
            component_separators = { left = "", right = "" },
            section_separators = { left = "", right = "" },
        },
        sections = {
            lualine_a = { "mode" },
            lualine_b = { "branch", "diff", "diagnostics" },
            lualine_c = { { "filename", path = 1 } }, -- path = 1 shows relative path
            lualine_x = { "encoding", "filetype" },
            lualine_y = { "progress" },
            lualine_z = { "location" },
        },
    })
end

--------------------------------------------------------------------------------
-- Indent Blankline (visual indent guides)
--------------------------------------------------------------------------------
local ok, ibl = pcall(require, "ibl")
if ok then
    ibl.setup({
        indent = {
            char = "│",
        },
        scope = {
            enabled = true,
            show_start = false,
            show_end = false,
        },
    })
end

--------------------------------------------------------------------------------
-- Which-key
--------------------------------------------------------------------------------
local ok, whichkey = pcall(require, "which-key")
if ok then
    whichkey.setup()
end

--------------------------------------------------------------------------------
-- Auto dark mode: configured by require("ivan.theme").setup() above (it wires
-- set_dark_mode/set_light_mode to the active theme's variants).
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Fastaction
--------------------------------------------------------------------------------
local ok, fastaction = pcall(require, "fastaction")
if ok then
    fastaction.setup({})
end

--------------------------------------------------------------------------------
-- Markdown Preview (lazy configuration via vim.g)
--------------------------------------------------------------------------------
vim.g.mkdp_filetypes = { "markdown" }

--------------------------------------------------------------------------------
-- Gitsigns (Git integration)
--------------------------------------------------------------------------------
local ok, gitsigns = pcall(require, "gitsigns")
if ok then
    gitsigns.setup({
        signs = {
            add = { text = "+" },
            change = { text = "~" },
            delete = { text = "_" },
            topdelete = { text = "‾" },
            changedelete = { text = "~" },
        },
        on_attach = function(bufnr)
            local gs = package.loaded.gitsigns
            local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
            end
            map("n", "]c", function()
                if vim.wo.diff then return "]c" end
                vim.schedule(function() gs.next_hunk() end)
                return "<Ignore>"
            end, { expr = true, desc = "Next hunk" })
            map("n", "[c", function()
                if vim.wo.diff then return "[c" end
                vim.schedule(function() gs.prev_hunk() end)
                return "<Ignore>"
            end, { expr = true, desc = "Prev hunk" })
            map("n", "<leader>gb", gs.blame_line, { desc = "Blame line" })
            map("n", "<leader>gB", function() gs.blame_line({ full = true }) end, { desc = "Blame line (full)" })
            map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview hunk" })
            map("n", "<leader>gr", gs.reset_hunk, { desc = "Reset hunk" })
            map("n", "<leader>gR", gs.reset_buffer, { desc = "Reset buffer" })
            map("n", "<leader>gs", gs.stage_hunk, { desc = "Stage hunk" })
            map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
        end,
    })
end

--------------------------------------------------------------------------------
-- Project.nvim (Workspace management)
--------------------------------------------------------------------------------
local ok, project = pcall(require, "project_nvim")
if ok then
    project.setup({
        patterns = { ".git" },
        detection_methods = { "pattern" },
        show_hidden = true,
        manual_mode = true,
        silent_chdir = true,
    })
    pcall(function()
        require("telescope").load_extension("projects")
    end)
    vim.keymap.set("n", "<leader>fp", "<cmd>Telescope projects<CR>", { desc = "Switch project" })

end

--------------------------------------------------------------------------------
-- Conform.nvim (Formatting)
--------------------------------------------------------------------------------
local ok, conform = pcall(require, "conform")
if ok then
    conform.setup({
        formatters_by_ft = {
            python = { "ruff_format" },
            lua = { "stylua" },
            javascript = { "prettier" },
            typescript = { "prettier" },
            typescriptreact = { "prettier" },
            javascriptreact = { "prettier" },
            json = { "prettier" },
            yaml = { "prettier" },
            markdown = { "prettier" },
            ruby = { "rubocop" },
            terraform = { "terraform_fmt" },
            hcl = { "terraform_fmt" },
            go = { "gofmt", "goimports" },
        },
        format_on_save = function(bufnr)
            local disable_filetypes = { c = true, cpp = true }
            return {
                timeout_ms = 500,
                lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
            }
        end,
    })
    vim.keymap.set({ "n", "v" }, "<leader>cf", function()
        conform.format({ async = true, lsp_fallback = true })
    end, { desc = "Format buffer" })
end

--------------------------------------------------------------------------------
-- vim-rails (Rails navigation)
--------------------------------------------------------------------------------
-- vim-rails provides these commands out of the box:
--   :Emodel <name>      - Edit model
--   :Econtroller <name> - Edit controller
--   :Eview <name>       - Edit view
--   :A                  - Alternate file (e.g., model <-> test)
--   :R                  - Related file (e.g., controller -> view)
--   gf                  - Enhanced go-to-file for Rails paths
-- Add convenient keymaps for common Rails navigation
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "ruby", "eruby" },
    callback = function()
        local opts = { buffer = true, silent = true }
        vim.keymap.set("n", "<leader>rm", ":Emodel<Space>", { buffer = true, desc = "Rails: Edit model" })
        vim.keymap.set("n", "<leader>rc", ":Econtroller<Space>", { buffer = true, desc = "Rails: Edit controller" })
        vim.keymap.set("n", "<leader>rv", ":Eview<Space>", { buffer = true, desc = "Rails: Edit view" })
        vim.keymap.set("n", "<leader>ra", "<cmd>A<CR>", { buffer = true, silent = true, desc = "Rails: Alternate file" })
        vim.keymap.set("n", "<leader>rr", "<cmd>R<CR>", { buffer = true, silent = true, desc = "Rails: Related file" })
    end,
})
