-- LSP utilities for Native Neovim 0.11+
local M = {}

function M.on_attach(client, bufnr)
    vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
    pcall(M.set_keys, client, bufnr)
end

function M.toggle_hints()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
end

function M.format()
    vim.lsp.buf.format({ timeout_ms = 1000 })
end

function M.set_keys(client, buffer)
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
    end

    -- Smart "go to implementation" - falls back to definition if not supported
    vim.keymap.set("n", "gri", function()
        if client:supports_method("textDocument/implementation") then
            vim.lsp.buf.implementation()
        else
            vim.lsp.buf.definition()
        end
    end, { buffer = buffer, desc = "Go to implementation (or definition)" })
end

return M
