local M = {}

-- default highlight links for Jira UI elements
vim.cmd("highlight default link JiraItemIndex CursorLineNr")
vim.cmd("highlight default link JiraCurrentItem SpecialChar")
vim.cmd("highlight default link JiraAction Character")
vim.cmd("highlight default link JiraDeleteMode DiagnosticError")

-- pad a string to exactly `width` characters with alignment
local function pad(str, width, align)
    str = tostring(str or "")
    local len = #str
    if len >= width then return str:sub(1, width) end
    local pad_total = width - len
    if align == "right" then
        return string.rep(" ", pad_total) .. str
    elseif align == "center" then
        local left = math.floor(pad_total / 2)
        local right = pad_total - left
        return string.rep(" ", left) .. str .. string.rep(" ", right)
    else
        return str .. string.rep(" ", pad_total)
    end
end

-- calculate total width for given columns and separator
local function calc_width(cols, sep_width)
    sep_width = sep_width or 1
    local w = 0
    for _, c in ipairs(cols) do w = w + c.width end
    return w + sep_width * (#cols - 1)
end

--- Render a floating, column-aligned window
-- @param opts.columns    array of { name=string, width=number, align=string? }
-- @param opts.rows       array of row-tables matching columns
-- @param opts.title      optional string title
-- @param opts.keymaps    optional array of { key=string, callback=function(buf, win) }
-- @param opts.border     window border style (default "rounded")
-- @param opts.sep        inter-column separator (default single space)
-- @param opts.align      default cell alignment ("left"|"right"|"center")
-- @param opts.modifiable whether buffer is editable (default false)
function M.render_table_window(opts)
    local cols     = opts.columns
    local rows     = opts.rows or {}
    local title    = opts.title
    local mappings = opts.keymaps or {}
    local border   = opts.border or "rounded"
    local sep      = opts.sep or " "
    local align    = opts.align or "left"
    local is_mod   = opts.modifiable == true

    -- build buffer lines
    local lines    = {}
    if title then
        table.insert(lines, pad(title, calc_width(cols, #sep), "center"))
        table.insert(lines, "")
    end
    -- header
    local header = {}
    for _, c in ipairs(cols) do
        table.insert(header, pad(c.name, c.width, c.align or "center"))
    end
    table.insert(lines, table.concat(header, sep))
    -- separator
    local sep_line = {}
    for _, c in ipairs(cols) do
        table.insert(sep_line, string.rep("─", c.width))
    end
    table.insert(lines, table.concat(sep_line, sep))
    -- rows
    for _, row in ipairs(rows) do
        local cells = {}
        for i, c in ipairs(cols) do
            cells[i] = pad(row[i], c.width, c.align or align)
        end
        table.insert(lines, table.concat(cells, sep))
    end

    -- create buffer and set content
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
    vim.api.nvim_buf_set_option(buf, 'modifiable', true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    -- enforce read-only if not modifiable
    if not is_mod then
        vim.api.nvim_buf_set_option(buf, 'modifiable', false)
        vim.api.nvim_buf_set_option(buf, 'readonly', true)
    end

    -- open the window (always focusable)
    local total_w = calc_width(cols, #sep)
    local total_h = #lines
    local ui_w, ui_h = vim.o.columns, vim.o.lines
    local win_opts = {
        relative  = 'editor',
        width     = total_w,
        height    = total_h,
        row       = math.floor((ui_h - total_h) / 2),
        col       = math.floor((ui_w - total_w) / 2),
        style     = 'minimal',
        border    = border,
        focusable = true,
    }
    -- hide the cursor in this float
    local win = vim.api.nvim_open_win(buf, true, win_opts)

    -- set user-provided keymaps
    for _, m in ipairs(mappings) do
        vim.keymap.set('n', m.key, function() m.callback(buf, win) end, { buffer = buf, silent = true })
    end

    return { buf = buf, win = win }
end

return M
