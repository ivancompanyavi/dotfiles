-- Native LSP configuration for rust-analyzer (Neovim 0.11+)
return {
    cmd = { 'rust-analyzer' },
    filetypes = { 'rust' },
    root_markers = {
        'Cargo.lock',
        'Cargo.toml',
        '.git',
    },
    settings = {
        ['rust-analyzer'] = {
            cargo = {
                allFeatures = true,
            },
            -- Run clippy instead of plain `cargo check` on save, for extra lint warnings
            check = {
                command = 'clippy',
            },
        },
    },
}
