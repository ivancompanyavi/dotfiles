local dotenv = require("ivan.my-plugins.dotenv")
local curl = require('plenary.curl')

local json      = vim.fn.json_decode
dotenv.load_dotenv()

local base_url = dotenv.get("ASANA_API_BASE_URL")

local M = {}

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
    local token = dotenv.get("ASANA_API_TOKEN")
    return { ['Accept'] = 'application/json', ['Authorization'] = string.format('Bearer %s', token) }
end

function M.fetch(url, callback)
    local headers = get_auth_headers()
    fetch(base_url .. url, headers, callback)
end


return M