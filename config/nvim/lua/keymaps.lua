-- Neovim keymaps
local opts = { noremap = true, silent = true }

 -- Plugin-specific keymaps are defined in their respective plugin configs
 -- Only general keymaps that don't depend on plugins should go here

 -- System clipboard integration
 vim.keymap.set('v', '<leader>y', '"+y', opts)
 vim.keymap.set('n', '<leader>y', '"+y', opts)
 vim.keymap.set('n', '<leader>p', '"+p', opts)
 vim.keymap.set('n', '<leader>P', '"+P', opts)
