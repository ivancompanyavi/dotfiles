-- Native LSP configuration for terraform-ls (Neovim 0.11+)
return {
    cmd = { 'terraform-ls', 'serve' },
    filetypes = { 'terraform', 'terraform-vars', 'hcl' },
    root_markers = {
        '.terraform',
        '.git',
    },
    settings = {
        terraform = {
            validation = {
                enableEnhancedValidation = true,
            },
        },
    },
}
