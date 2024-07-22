local on_attach = function(_, bufnr)
    local map = function(m, lhs, rhs)
        -- local opts = { buffer = event.buf }
        -- vim.keymap.set(m, lhs, rhs, opts)
        vim.keymap.set(m, lhs, rhs, { buffer = bufnr })
    end

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "single",
    })

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "single",
    })

    map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
    map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
    map('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
    map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')
    map('n', '<leader>ra', '<cmd>lua vim.lsp.buf.rename()<cr>')
    map('n', 'gI', '<cmd>lua vim.lsp.buf.implementation()<cr>')
    map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')
    map('n', '<a-cr>', '<cmd>lua vim.lsp.buf.code_action()<cr>')
    map('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
    map({ 'n', 'x' }, '<leader>lf', '<cmd>lua vim.lsp.buf.format({async = true})<cr>')
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

require('lspconfig').lua_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        Lua =
        {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            diagnostics = { globals = { 'vim' } },
        }
    },
}

require 'lspconfig'.nil_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}

require 'lspconfig'.csharp_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}

require 'lspconfig'.gopls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}

require 'lspconfig'.rust_analyzer.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        ['rust-analyzer'] = {
            diagnostics = {
                enable = false,
            }
        }
    }
}


require 'lspconfig'.tsserver.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    init_options = {
        plugins = {
            {
                name = "@vue/typescript-plugin",
                location = "/usr/local/lib/node_modules/@vue/typescript-plugin",
                languages = { "javascript", "typescript", "vue" },
            },
        },
    },
    filetypes = {
        "javascript",
        "typescript",
        "vue",
    },
}

require 'lspconfig'.volar.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue', 'json' }
}


-- TODO: Install the LSP and configure it here
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#bicep
-- https://github.com/Azure/bicep/releases
local bicep_lsp_bin = os.getenv('BICEP_LANGSERVER')
require 'lspconfig'.bicep.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { "dotnet", bicep_lsp_bin },
    filetypes = { 'bicep' }
}

-- TODO: Enable more language servers
