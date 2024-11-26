local function my_on_attach(bufnr)
	local api = require "nvim-tree.api"
  
	local function opts(desc)
	  return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
	end
  
	-- default mappings
	api.config.mappings.default_on_attach(bufnr)
  
	-- custom mappings
	vim.keymap.set('n', 'u', api.tree.change_root_to_parent,        opts('Up'))
  end

require("nvim-tree").setup({
	on_attach = my_on_attach,
	sort_by = "case_sensitive",
	view = {
		adaptive_size = true,
		side = "left",
	},
	renderer = {
		group_empty = true,
	},
	filters = {
		dotfiles = false,
	},
	-- diagnostics = {
	--   enable = true,
	-- },
	update_focused_file = {
		enable = true,
	},
})
