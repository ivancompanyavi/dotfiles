require('tokyonight').setup({
  transparent = true,
  styles = {
    sidebars = "transparent",
    floats = "transparent"
  }
})
vim.cmd [[
    autocmd vimenter * ++nested colorscheme tokyonight
]]
