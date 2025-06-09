local ui = require("ivan.my-plugins.ui")
local api = require("ivan.my-plugins.asana.api")
local M = {}

local function show_tasks()
    local function callback(response)
        local tasks = {}
        for _, task in ipairs(response.data) do
            table.insert(tasks, { task.name, task.notes })
        end
        vim.notify(vim.inspect(tasks))
        -- ui.render_table_window(tasks)
        ui.render_table_window {
            title = "Tasks",
            columns = {
                { name = "Name", width = 20 },
                { name = "Notes", width = 20 },
            },
            rows = tasks,
            keymaps = {
                { key = "q", callback = function()
                    vim.cmd("q")
                end },
            },
        }
    end
    api.fetch("/user_task_lists/1209344188878388/tasks?completed_since=now&opt_fields=name,notes", callback)
end

function M.setup()
    ui.render_table_window {
        title = "Asana Menu",
        columns = {
            { name = "Key", width = 3, align = "center" },
            { name = "Action", width = 20 },
        },
        rows = {
            { "t", "My tasks" },
            { "p", "Projects" },
            { "g", "Goals" },
        },
        keymaps = {
            { key = "t", callback = function()
                show_tasks()
            end },
            { key = "q", callback = function()
                vim.cmd("q")
            end },
        },
    }
end

return M