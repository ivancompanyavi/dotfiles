-- LSP utilities for Native Neovim 0.11+
local M = {}

-- Get LSP capabilities (for completion integration)
function M.get_capabilities()
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    -- Try to extend with blink.cmp capabilities if available
    local ok, blink = pcall(require, "blink.cmp")
    if ok then
        capabilities = blink.get_lsp_capabilities(capabilities)
    end

    return capabilities
end

M.capabilities = M.get_capabilities()

function M.on_attach(client, bufnr)
    local function buf_set_option(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end

    buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

    -- Set keybindings
    pcall(M.set_keys, client, bufnr)
end

function M.format()
    vim.lsp.buf.format()
end

M.diagnostics_active = true

function M.toggle_hints()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
end

function M.format_sync()
    vim.lsp.buf.format({ async = true })
end

function M.set_keys(client, buffer)
    -- Try to use which-key if available, otherwise use native keymaps
    local ok, wk = pcall(require, "which-key")
    if ok then
        wk.add({
            { "<leader>ca", '<cmd>lua require("fastaction").code_action()<CR>', desc = "code action",       mode = { "n", "v" } },
            { "<leader>cs", vim.lsp.buf.signature_help,                         desc = "signature help",    buffer = buffer,    mode = { "n", "i" } },
            { "<leader>cd", vim.diagnostic.open_float,                          desc = "line diagnostics" },
            { "<leader>cf", M.format,                                           desc = "format document" },
            { "<leader>ch", M.toggle_hints,                                     desc = "toggle inlay hints" },
            { "<C-j>",      vim.diagnostic.goto_next,                           desc = "next error" },
            { "<C-k>",      vim.diagnostic.goto_prev,                           desc = "prev error" },
        })
    else
    end
end

return M
