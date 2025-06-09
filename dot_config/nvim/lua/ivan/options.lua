vim.opt.termguicolors = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.clipboard = "unnamedplus"

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true


-- vim.cmd [[
--   highlight Normal guibg=none
--   highlight NonText guibg=none
--   highlight Normal ctermbg=none
--   highlight NonText ctermbg=none
-- ]]



vim.api.nvim_create_augroup("LspFormatting", { clear = true })
local group = vim.api.nvim_create_augroup("Custom auto-commands", { clear = true })

vim.api.nvim_create_autocmd("BufWritePre", {
    group = "LspFormatting",
    callback = function()
        vim.lsp.buf.format({ async = false }) -- use async = true if you prefer
    end,
})


-- Script that sets the local working directory at the same level as the folder you selected to open
vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    group = group,
    callback = function()
        local argv = vim.fn.argv()
        if #argv == 1 then
            local path = argv[1]
            local ok, stat = pcall(vim.uv.fs_stat, path) -- safer and cross-version
            if ok and stat and stat.type == "directory" then
                vim.cmd("cd " .. vim.fn.fnameescape(path))
            end
        end
    end,
})
-- Script that activates the virtual environment if detected
vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    group = group,
    callback = function()
        local venv_path = vim.fn.getcwd() .. "/.venv"
        if vim.fn.isdirectory(venv_path) == 1 then
            local command = "source " .. venv_path .. "/bin/activate"
            -- Set environment variables for the current Neovim instance
            vim.env.VIRTUAL_ENV = venv_path
            vim.env.PATH = venv_path .. "/bin:" .. vim.env.PATH
            -- Notify user
            vim.notify("Activated virtual environment: " .. venv_path, vim.log.levels.INFO)
        end
    end,
})
