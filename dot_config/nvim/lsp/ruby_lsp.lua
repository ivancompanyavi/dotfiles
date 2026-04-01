-- Native LSP configuration for ruby-lsp (Neovim 0.11+)
-- Install via: gem install ruby-lsp
return {
    cmd = { 'ruby-lsp' },
    filetypes = { 'ruby', 'eruby' },
    root_markers = {
        'Gemfile',
        '.ruby-version',
        '.ruby-gemset',
        'Rakefile',
        '.git',
    },
    init_options = {
        formatter = 'auto',
        linters = { 'rubocop' },
        featuresConfiguration = {
            inlayHint = {
                implicitHashValue = true,
                implicitRescue = true,
            },
        },
    },
    settings = {},
}
