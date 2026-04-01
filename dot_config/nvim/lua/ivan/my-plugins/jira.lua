-- ~/.config/nvim/lua/ivan/my-plugins/jira.lua
local curl   = require('plenary.curl')
local json   = vim.fn.json_decode
local dotenv = require("ivan.my-plugins.dotenv")

dotenv.load_dotenv()
-- local inspect   = vim.inspect

local M = {
    ["tickets"] = {}
}

local function get_opener()
    if vim.fn.has('macunix') == 1 then
        return 'open'
    elseif vim.fn.has('win32') == 1 then
        return 'start'
    else
        return 'xdg-open'
    end
end

local jira_base = dotenv.get("JIRA_API_BASE_URL")

local function get_status_emoji(status)
    if status == 'Ready for Dev' then
        return '☑️'
    elseif status == 'Done' or status == 'Won\'t Do' then
        return '✅'
    elseif status == 'In Discovery / Spec' then
        return '💡'
    else
        return '❓'
    end
end

function M.open_url()
    local base_url = jira_base .. '/browse/'
    local current_line = vim.fn.getline('.')
    local url = nil
    for k, v in pairs(M.tickets) do
        if v.description == current_line then
            url = base_url .. v.id
        end
    end
    if not url then
        vim.notify('No URL for this line', vim.log.levels.WARN)
        return
    end
    vim.fn.jobstart({ get_opener(), url }, { detach = true })
end

local function open_floating()
    local lines = {}
    for k, v in pairs(M.tickets) do
        table.insert(lines, v.description)
    end
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    local width  = math.floor(vim.o.columns * 0.6)
    local height = math.min(#lines, math.floor(vim.o.lines * 0.5))
    local opts   = {
        style    = 'minimal',
        relative = 'editor',
        width    = width,
        height   = height,
        row      = math.floor((vim.o.lines - height) / 2),
        col      = math.floor((vim.o.columns - width) / 2),
        border   = 'rounded',
    }
    vim.api.nvim_open_win(buf, true, opts)
    vim.api.nvim_buf_set_keymap(buf, 'n', '<CR>', "<Cmd>lua require('ivan.my-plugins.jira').open_url()<CR>",
        { nowait = true, noremap = true, silent = true })
end

local function build_auth()
    local username = dotenv.get("JIRA_API_USERNAME")
    local api_token = dotenv.get("JIRA_API_TOKEN")
    if not username or not api_token then
        error('jira: Missing username or api_token in .config/.env file')
    end
    local auth = username .. ':' .. api_token
    local cmd = "printf %s " .. vim.fn.shellescape(auth) .. " | base64 -w0"
    local b64 = vim.fn.trim(vim.fn.system(cmd))
    -- Use curl's -u user:token flag (Jira -u user:token)
    return {}, { ['Accept'] = 'application/json', ['Authorization'] = string.format('Basic %s', b64) }
end


local function fetch(endpoint, params, callback)
    local url           = string.format('%s/rest/api/2/%s?%s', jira_base, endpoint, params)
    local opts, headers = build_auth()

    curl.get({
        url      = url,
        headers  = headers,
        opts     = opts,
        callback = function(response)
            vim.schedule(function()
                callback(json(response.body))
            end)
        end,
    })
end


function M.fetch_inprogress()
    M.tickets = {}
    local function callback(response)
        for i, k in ipairs(response.issues) do
            local issue = {
                ["status"] = k.fields.status.name,
                ["id"] = k.key,
                ["summary"] = k.fields.summary,
            }
            issue["description"] = get_status_emoji(issue.status) .. issue.id .. " - " .. issue.summary
            M.tickets[issue.id] = issue
        end

        open_floating()
    end
    local url = 'search/jql'
    local params =
    'jql=assignee%20%3D%20712020%3A2dcb78f0-d35c-4b0b-93d8-d84a28b54cb8%20ORDER%20BY%20created%20DESC&fields=summary,status'
    fetch(url, params, callback)
end

-- Public: fetch + display in-progress issues
function M.show_inprogress()
    M.fetch_inprogress()
end

return M
