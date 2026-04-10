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
        local root = client.root_dir or vim.fn.getcwd()
        local venv_path = nil

        -- Check for .venv in project root (uv default)
        local project_venv = root .. '/.venv'
        if vim.fn.isdirectory(project_venv) == 1 then
            venv_path = project_venv
        -- Fallback to VIRTUAL_ENV environment variable
        elseif vim.env.VIRTUAL_ENV then
            venv_path = vim.env.VIRTUAL_ENV
        end

        if venv_path then
            client.config.settings.python = {
                pythonPath = venv_path .. '/bin/python',
            }
            client.config.settings.basedpyright = client.config.settings.basedpyright or {}
            client.config.settings.basedpyright.analysis = client.config.settings.basedpyright.analysis or {}
            client.config.settings.basedpyright.analysis.extraPaths = { root }
        end
    end,
}
