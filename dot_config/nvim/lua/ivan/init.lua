require("ivan.lazy")
require("ivan.remap")
require("ivan.options")


local reddit = require('ivan.my-plugins.reddit')

vim.api.nvim_create_user_command('Reddit', function(opts)
	local args      = vim.fn.split(opts.args, '%s\\+')
	local subreddit = args[1] or 'neovim'
	local limit     = tonumber(args[2]) or 10
	reddit.fetch_and_show(subreddit, limit)
end, {
	nargs    = '*',
	complete = function(lead)
		local examples = { 'neovim', 'lua', 'vim', 'programming' }
		return vim.tbl_filter(function(item)
			return vim.startswith(item, lead)
		end, examples)
	end,
})
