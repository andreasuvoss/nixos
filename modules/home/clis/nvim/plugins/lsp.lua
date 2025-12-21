local on_attach = function(_, bufnr)
    local map = function(m, lhs, rhs)
        -- local opts = { buffer = event.buf }
        -- vim.keymap.set(m, lhs, rhs, opts)
        vim.keymap.set(m, lhs, rhs, { buffer = bufnr })
    end

    vim.diagnostic.config({
        virtual_text = false,
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = {
            border = "single",
            focusable = false,
            style = "minimal",
            source = "always",
            header = "",
            prefix = "",
        },
    })

    -- vim.o.winborder = 'single'

    map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
    map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
    map('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help({border = "single"})<cr>')
    map('n', 'K', '<cmd>lua vim.lsp.buf.hover({border = "single"})<cr>')
    map('n', '<leader>ra', '<cmd>lua vim.lsp.buf.rename()<cr>')
    map('n', 'gI', '<cmd>lua vim.lsp.buf.implementation()<cr>')
    map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')
    map('n', '<a-cr>', '<cmd>lua vim.lsp.buf.code_action()<cr>')
    map('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
    map({ 'n', 'x' }, '<leader>lf', '<cmd>lua vim.lsp.buf.format({async = true})<cr>')
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

vim.lsp.config['lua_ls'] = {
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
vim.lsp.enable('lua_ls')

vim.lsp.config['nil_ls'] = {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        ['nil'] = {
            formatting = { command = { "nixfmt" } },
        },
    },
}
vim.lsp.enable('nil_ls')

vim.lsp.config['csharp_ls'] = {
    on_attach = on_attach,
    capabilities = capabilities,
}
vim.lsp.enable('csharp_ls')

vim.lsp.config['pyright'] = {
    on_attach = on_attach,
    capabilities = capabilities,
}
vim.lsp.enable('pyright')

vim.lsp.config['gopls'] = {
    on_attach = on_attach,
    capabilities = capabilities,
}
vim.lsp.enable('gopls')

vim.lsp.config['elixirls'] = {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { 'elixir-ls' }
}
vim.lsp.enable('elixirls')

vim.lsp.config['rust_analyzer'] = {
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
vim.lsp.enable('rust_analyzer')



local vue_lsp = os.getenv('VUE_LANGSERVER')

vim.lsp.config['ts_ls'] = {
    on_attach = on_attach,
    capabilities = capabilities,
    init_options = {
        plugins = {
            {
                name = '@vue/typescript-plugin',
                location = vue_lsp,
                languages = { 'vue' },
            },
        },
    },
    filetypes = {
        'javascript',
        'typescript',
        'javascriptreact',
        'typescriptreact',
        'vue',
    },
}
vim.lsp.enable('ts_ls')

-- deprecated now vue_ls
-- vim.lsp.config['volar'] = {}
-- vim.lsp.enable('volar')

vim.lsp.config['docker_compose_language_service'] = {
    on_attach = on_attach,
    capabilities = capabilities,
}
vim.lsp.enable('docker_compose_language_service')

-- TODO: Install the LSP and configure it here
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#bicep
-- https://github.com/Azure/bicep/releases
local bicep_lsp_bin = os.getenv('BICEP_LANGSERVER')
vim.lsp.config['bicep'] = {
    on_attach = on_attach,
    capabilities = capabilities,
    cmd = { "dotnet", bicep_lsp_bin },
    filetypes = { 'bicep', 'bicep-params' }
}
vim.lsp.enable('bicep')

-- TODO: Enable more language servers
