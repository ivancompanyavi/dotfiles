-- lua/ivan/my-plugins/reddit.lua
local Job = require('plenary.job')
local M = {}
M.urls = {}

-- pick the right “open” command for your OS
local function get_opener()
    if vim.fn.has('macunix') == 1 then
        return 'open'
    elseif vim.fn.has('win32') == 1 then
        return 'start'
    else
        return 'xdg-open'
    end
end

--- Fetch top posts asynchronously and then show them
-- @param subreddit string e.g. "neovim"
-- @param limit     number
function M.fetch_and_show(subreddit, limit)
    local url = string.format(
        'https://www.reddit.com/r/%s/top.json?limit=%d&t=day',
        subreddit, limit
    )

    Job:new({
        command = 'curl',
        args    = { '-s', '-H', 'User-Agent: NeovimPlugin/0.1', '-L', url },
        -- schedule_wrap ensures we’re back on the main loop before touching the UI
        on_exit = vim.schedule_wrap(function(job, return_val)
            if return_val ~= 0 then
                vim.notify('Failed to fetch Reddit', vim.log.levels.ERROR)
                return
            end

            local resp = job:result()
            local ok, data = pcall(vim.fn.json_decode, table.concat(resp, '\n'))
            if not ok or not data or not data.data then
                vim.notify('Invalid JSON from Reddit', vim.log.levels.ERROR)
                return
            end

            local posts = {}
            for _, child in ipairs(data.data.children) do
                table.insert(posts, {
                    title = '• ' .. child.data.title,
                    url   = 'https://reddit.com' .. child.data.permalink,
                })
            end

            if vim.tbl_isempty(posts) then
                vim.notify('No posts in /r/' .. subreddit, vim.log.levels.INFO)
                return
            end

            M.show_reddit(posts)
        end),
    }):start()
end

--- Render posts in a centered floating window and map <CR> to open the URL
-- @param posts array of { title=string, url=string }
function M.show_reddit(posts)
    M.urls = {}
    local lines = {}

    for i, p in ipairs(posts) do
        lines[i]  = p.title
        M.urls[i] = p.url
    end

    -- compute window size & position
    local width = 0
    for _, line in ipairs(lines) do
        width = math.max(width, #line)
    end
    local height = #lines
    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    -- create buffer & window
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_open_win(buf, true, {
        relative = 'editor',
        style    = 'minimal',
        width    = width,
        height   = height,
        row      = row,
        col      = col,
        border   = 'single',
    })

    -- map <CR> in this buffer to open the URL
    vim.api.nvim_buf_set_keymap(buf, 'n', '<CR>',
        "<Cmd>lua require('ivan.my-plugins.reddit').open_url()<CR>",
        { nowait = true, noremap = true, silent = true })
end

--- Open the URL for the current line in your default browser
function M.open_url()
    local row = vim.api.nvim_win_get_cursor(0)[1]
    local url = M.urls[row]
    if not url then
        vim.notify('No URL for this line', vim.log.levels.WARN)
        return
    end
    vim.fn.jobstart({ get_opener(), url }, { detach = true })
end

return M
