-- Neovim options and autocommands (Native 0.11+)
local lsp_utils = require("ivan.lsp_utils")

-- Terminal colors
vim.opt.termguicolors = true

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- System clipboard
vim.opt.clipboard = "unnamedplus"

-- Indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Scrolling
vim.opt.scrolloff = 999

-- Window borders
vim.opt.winborder = 'rounded'

-- Autocommand groups
vim.api.nvim_create_augroup("LspFormatting", { clear = true })
local group = vim.api.nvim_create_augroup("Custom auto-commands", { clear = true })

-- Format on save
vim.api.nvim_create_autocmd("BufWritePre", {
    group = "LspFormatting",
    callback = function()
        vim.lsp.buf.format({ async = false })
    end,
})

-- Set working directory to opened folder
vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    group = group,
    callback = function()
        local argv = vim.fn.argv()
        if #argv == 1 then
            local path = argv[1]
            local ok, stat = pcall(vim.uv.fs_stat, path)
            if ok and stat and stat.type == "directory" then
                vim.cmd("cd " .. vim.fn.fnameescape(path))
            end
        end
    end,
})

-- Auto-activate virtual environment
vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    group = group,
    callback = function()
        local venv_path = vim.fn.getcwd() .. "/.venv"
        if vim.fn.isdirectory(venv_path) == 1 then
            vim.env.VIRTUAL_ENV = venv_path
            vim.env.PATH = venv_path .. "/bin:" .. vim.env.PATH
            vim.notify("Activated virtual environment: " .. venv_path, vim.log.levels.INFO)
        end
    end,
})

-- LSP attach handler
vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    callback = function(ev)
        local bufnr = ev.buf
        local client = vim.lsp.get_client_by_id(ev.data.client_id)

        if client then
            lsp_utils.on_attach(client, bufnr)
        end

        -- Enable inlay hints if supported
        if client and client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
    end,
})

-- Enable native LSP servers (Neovim 0.11+)
-- These servers are configured in lsp/*.lua files
vim.lsp.enable({ 'lua_ls', 'basedpyright', 'ts_ls', 'ruby_lsp' })
