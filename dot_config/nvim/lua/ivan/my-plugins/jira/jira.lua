local dotenv = require("ivan.my-plugins.dotenv")
local ui = require("ivan.my-plugins.jira.ui")
local api = require("ivan.my-plugins.jira.api")

require("ivan.my-plugins.dotenv").load_dotenv()
local ns = vim.api.nvim_create_namespace("jira")

local M = {
    ["tickets"] = {}
}

local field_mapping = {
    ["Total Story Points"] = "customfield_11114"
}

local team_mapping = {
    {
        ["name"] = "Devon Mack",
        ["id"] = "Devon Mack",
    },
    {
        ["name"] = "Cynthia Tsoi",
        ["id"] = "cynthia.tsoi@stackadapt.com",
    },
    {
        ["name"] = "Larry Liu",
        ["id"] = "larry.liu@stackadapt.com",
    }
}


dotenv.load_dotenv()

local function get_opener()
    if vim.fn.has('macunix') == 1 then
        return 'open'
    elseif vim.fn.has('win32') == 1 then
        return 'start'
    else
        return 'xdg-open'
    end
end


function M.open_url()
    local jira_base = dotenv.get("JIRA_API_BASE_URL")
    local base_url = jira_base .. '/browse/'
    local current_line = vim.fn.getline('.')
    local url = nil
    for _, v in pairs(M.tickets) do
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

local function show_issues(member_name)
    M.tickets = {}
    local function callback(response)
        local issues = {}
        local total_points = 0
        for _, k in ipairs(response.issues) do
            local points = k.fields[field_mapping["Total Story Points"]]
            if points == vim.NIL then
                points = "0"
            end
            local issue = {
                ["status"] = k.fields.status.name,
                ["id"] = k.key,
                ["summary"] = k.fields.summary,
                ["points"] = points,
            }
            total_points = total_points + points
            table.insert(issues, {
                k.fields.status.name,
                k.fields.summary,
                points,
            })
            M.tickets[issue.id] = issue
        end

        table.insert(issues, { "", "", total_points })

        ui.render_table_window {
            title = 'Issues',
            columns = {
                { name = 'Status',      width = 20 },
                { name = 'Description', width = 80 },
                { name = 'Points',      width = 6 },
            },
            rows = issues,
            keymaps = {
                { key = '<CR>', callback = function() M.open_url() end },
                { key = 'q',    callback = function(buf, win) vim.api.nvim_win_close(win, true) end },
            },
        }
    end
    local params = 'jql=' ..
        api.url_encode('assignee = "' .. member_name .. '" AND sprint in openSprints()') ..
        '&fields=summary,status,' .. field_mapping["Total Story Points"]
    vim.notify(params)
    local url = '/rest/api/2/search/jql?' .. params
    api.fetch(url, callback)
end

local function show_team()
    local lines = {}
    for idx, t in ipairs(team_mapping) do
        lines[idx] = idx .. '. ' .. t["name"]
    end
    table.insert(lines, "q. Quit")
    local buf, win = ui.create_menu(lines)
    vim.hl.range(buf, ns, "JiraAction", { 0, 0 }, { #lines, 3 }, { regtype = '\22' })

    for idx, t in ipairs(team_mapping) do
        vim.keymap.set('n', tostring(idx), function()
            show_issues(t["id"])
            vim.api.nvim_win_close(win, true)
        end, { buffer = buf })
    end
    vim.keymap.set('n', 'q', function()
        vim.api.nvim_win_close(win, true)
    end, { buffer = buf })
end

function M.show_menu()
    local lines    = {
        "i. Issues",
        "t. Team",
        "q. Quit"
    }
    local buf, win = ui.create_menu(lines)
    vim.hl.range(buf, ns, "JiraAction", { 0, 0 }, { #lines, 3 }, { regtype = '\22' })

    vim.keymap.set('n', 'i', function()
        show_issues('Ivan Company Avi')
    end, { buffer = buf })
    vim.keymap.set('n', 't', function()
        show_team()
    end, { buffer = buf })
    vim.keymap.set('n', 'q', function()
        vim.api.nvim_win_close(win, true)
    end, { buffer = buf })
end

function M.test()
    ui.render_table_window {
        title   = "Jira Menu",
        columns = {
            { name = "Key",    width = 3, align = "center" },
            { name = "Action", width = 20 },
        },
        rows    = {
            { "i", "My Issues" },
            { "t", "Team Issues" },
            { "q", "Quit" },
        },
        keymaps = {
            { key = "i", callback = function() show_issues('Ivan Company Avi') end },
            { key = "t", callback = function() show_team() end },
            { key = "q", callback = function(buf, win)
                vim.api.nvim_win_close(win, true)
            end
            },
        },
        border  = "single",
    }
end

return M
