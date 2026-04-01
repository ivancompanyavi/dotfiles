-- Native LSP configuration for lua-language-server (Neovim 0.11+)
return {
    cmd = { 'lua-language-server' },
    filetypes = { 'lua' },
    root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
            },
            workspace = {
                checkThirdParty = false,
                library = vim.api.nvim_get_runtime_file("", true),
            },
            diagnostics = {
                globals = { 'vim' },
            },
            completion = {
                callSnippet = 'Replace',
            },
            hint = {
                enable = true,
                setType = true,
                paramType = true,
                paramName = 'Literal',
                semicolon = 'Disable',
                arrayIndex = 'Disable',
            },
            telemetry = {
                enable = false,
            },
        },
    },
}
