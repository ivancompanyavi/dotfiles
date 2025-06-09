-- Reserve a space in the gutter
-- This will avoid an annoying layout shift in the screen
vim.opt.signcolumn = 'yes'

-- Add cmp_nvim_lsp capabilities settings to lspconfig
-- This should be executed before you configure any language server
local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
    'force',
    lspconfig_defaults.capabilities,
    require('cmp_nvim_lsp').default_capabilities()
)


local util = require('lspconfig.util')
require('lspconfig').lua_ls.setup {}
require 'lspconfig'.ts_ls.setup {}
require 'lspconfig'.ruby_lsp.setup {}
require 'lspconfig'.pylsp.setup {
    -- how we detect your project root
    root_dir = util.root_pattern('.git', 'pyproject.toml', 'setup.py'),

    -- when the server is initialized, swap out the cmd if we find .venv
    on_init = function(client)
        local root = client.config.root_dir
        local venv_python = util.path.join(root, '.venv', 'bin', 'python')

        -- if that python exists and is executable…
        if vim.fn.executable(venv_python) == 1 then
            -- point the LSP command at the venv’s pylsp
            client.config.cmd = { venv_python, '-m', 'pylsp' }
        end
    end,

    -- (optional) settings for pylsp’s jedi plugin; it’ll autodetect .venv but you
    -- can also explicitly tell it where to look:
    settings = {
        pylsp = {
            plugins = {
                jedi_environment = {
                    -- this path is relative to root_dir
                    environment = '.venv',
                },
            },
        },
    },
}

-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(event)
        local opts = { buffer = event.buf }

        vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
        vim.keymap.set('n', '<C-j>', '<cmd>lua vim.diagnostic.goto_next()<cr>', opts)
        vim.keymap.set('n', '<C-k>', '<cmd>lua vim.diagnostic.goto_prev()<cr>', opts)
        vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
        vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
        vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
        vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
        vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
        vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
        vim.keymap.set('n', '<leader>ln', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
        vim.keymap.set({ 'n', 'x' }, '<leader>lf', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
        vim.keymap.set('n', '<leader>la', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
    end,
})
