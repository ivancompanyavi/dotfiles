local dotenv = require("ivan.my-plugins.dotenv")
local curl = require('plenary.curl')

dotenv.load_dotenv()

local jira_base = dotenv.get("JIRA_API_BASE_URL")
local json      = vim.fn.json_decode

local M         = {}

function M.url_encode(str)
    -- first, normalize newlines (optional)
    str = str:gsub("\n", "\r\n")
    -- then percent-encode everything outside [A-Za-z0-9-._~]
    str = str:gsub("([^%w%-._~])", function(c)
        return string.format("%%%02X", string.byte(c))
    end)
    return str
end

local function fetch(url, headers, callback)
    curl.get({
        url      = url,
        headers  = headers,
        opts     = {},
        callback = function(response)
            vim.schedule(function()
                callback(json(response.body))
            end)
        end,
    })
end

local function get_auth_headers()
    local username = dotenv.get("JIRA_API_USERNAME")
    local api_token = dotenv.get("JIRA_API_TOKEN")
    if not username or not api_token then
        error('jira: Missing username or api_token in .config/.env file')
    end
    local auth = username .. ':' .. api_token
    local cmd = "printf %s " .. vim.fn.shellescape(auth) .. " | base64 -w0"
    local b64 = vim.fn.trim(vim.fn.system(cmd))
    return { ['Accept'] = 'application/json', ['Authorization'] = string.format('Basic %s', b64) }
end


function M.fetch(url, callback)
    local headers = get_auth_headers()
    fetch(jira_base .. url, headers, callback)
end

return M
