local custom_lsp_attach = function(client)
    vim.api.nvim_buf_set_keymap(0, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', {noremap = true })
    vim.api.nvim_buf_set_keymap(0, 'n', '<C-]>', '<cmd>lua vim.lsp.buf.definition()<CR>', {noremap = true})
    vim.api.nvim_buf_set_keymap(0, 'n', '<leader>l', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', {noremap = true})
    vim.api.nvim_buf_set_keymap(0, 'n', '<leader><S-l>', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', {noremap = true})
    vim.api.nvim_buf_set_option(0, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end

require'lspconfig'.clangd.setup{
    on_attach = custom_lsp_attach
}
