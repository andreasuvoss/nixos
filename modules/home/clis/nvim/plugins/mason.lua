return {
    'williamboman/mason.nvim',
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
        "hrsh7th/cmp-nvim-lsp"
    },
    config = function()
        -- local border = {
        --     { '┌', 'FloatBorder' },
        --     { '─', 'FloatBorder' },
        --     { '┐', 'FloatBorder' },
        --     { '│', 'FloatBorder' },
        --     { '┘', 'FloatBorder' },
        --     { '─', 'FloatBorder' },
        --     { '└', 'FloatBorder' },
        --     { '│', 'FloatBorder' },
        -- }
        vim.api.nvim_create_autocmd('LspAttach', {
            desc = 'LSP actions',
            callback = function(event)
                local map = function(m, lhs, rhs)
                    local opts = { buffer = event.buf }
                    vim.keymap.set(m, lhs, rhs, opts)
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
        })

        require('mason').setup()
        require('mason-lspconfig').setup({
            ensure_installed = {
                'lua_ls',
                'rust_analyzer',
                'tsserver',
                'csharp_ls'
            }
        })

        local lspconfig = require('lspconfig')
        local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

        require('mason-lspconfig').setup_handlers({
            function(server_name)
                lspconfig[server_name].setup({
                    handlers = {
                        ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
                            border = "single",
                        }),
                        ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
                            border = "single",
                        })
                    },
                    capabilities = lsp_capabilities
                })
            end
        })
    end
}
