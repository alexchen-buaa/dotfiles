-- Neovim keymaps
local opts = { noremap = true, silent = true }

-- Plugin-specific keymaps are defined in their respective plugin configs
-- Only general keymaps that don't depend on plugins should go here

-- System clipboard integration
vim.keymap.set('v', '<leader>y', '"+y', opts)
vim.keymap.set('n', '<leader>y', '"+y', opts)
vim.keymap.set('n', '<leader>p', '"+p', opts)
vim.keymap.set('n', '<leader>P', '"+P', opts)

-- Toggle built-in terminal
-- <leader>ag matches my tmux keybind prefix + g (Ctrl-a + g) for popups
local floating = require('utils.floating')
vim.keymap.set({ "n", "t" }, "<leader>ag", floating.toggle_terminal)

-- AI mention: copy @file or @file:L1-L2 to clipboard
local ai = require('utils.ai')
vim.keymap.set({ 'n', 'v' }, 'gm', ai.mention, { desc = 'Copy @file mention' })
