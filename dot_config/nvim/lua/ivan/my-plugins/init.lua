local reddit = require("ivan.my-plugins.reddit")
local jira = require("ivan.my-plugins.jira")


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

vim.api.nvim_create_user_command('Jira', function(opts)
	jira.show_inprogress()
end, {})
