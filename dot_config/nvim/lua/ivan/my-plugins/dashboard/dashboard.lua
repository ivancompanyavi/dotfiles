-- Main dashboard for my plugins
-- This plugin will just simply act as the entry point for all my plugins, displaying a floating window with all my plugins
local ui = require("ivan.my-plugins.ui")
local jira = require("ivan.my-plugins.jira")
local asana = require("ivan.my-plugins.asana")

local M = {}

function M.setup()
    ui.render_table_window {
        title = "Dashboard",
        columns = {
            { name = "Key", width = 3, align = "center" },
            { name = "Action", width = 20 },
        },
        rows = {
            { "j", "Jira" },
            { "a", "Asana" },
        },
        keymaps = {
            { key = "j", callback = function()
                jira.setup()
            end },
            { key = "a", callback = function()
                asana.setup()
            end },
            { key = "q", callback = function()
                vim.cmd("q")
            end },
        },
        border = "rounded",
    }
end

return M