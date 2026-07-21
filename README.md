# Dotfiles

This is my dotfiles configuration, where I keep all the things I usually need to do my work.

## Installation

```
brew install chezmoi

chezmoi init --apply git@github.com:ivancompanyavi/dotfiles.git
```

After the first `apply` on a new machine you may need a one-time
`brew trust felixkratz/formulae nikitabobko/tap jesseduffield/lazygit`, then
re-run `chezmoi apply` so the package install completes.

## How it works

See [ARCHITECTURE.md](ARCHITECTURE.md) for the full picture — the app registry,
package/theme systems, machine profiles, and how to add an app or a theme.

