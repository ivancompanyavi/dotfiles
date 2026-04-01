-- Native LSP configuration for basedpyright (Neovim 0.11+)
return {
    cmd = { 'basedpyright-langserver', '--stdio' },
    filetypes = { 'python' },
    root_markers = {
        'pyproject.toml',
        'setup.py',
        'setup.cfg',
        'requirements.txt',
        'Pipfile',
        'pyrightconfig.json',
        '.git',
    },
    settings = {
        basedpyright = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = 'openFilesOnly',
                typeCheckingMode = 'standard',
            },
        },
    },
    -- Dynamically set python path based on virtual environment
    on_init = function(client)
        local venv = vim.env.VIRTUAL_ENV
        if venv then
            client.config.settings.python = {
                pythonPath = venv .. '/bin/python',
            }
        end
    end,
}
