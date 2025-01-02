-- Settings leader to comma to stay closer to home row.
-- Additionally, set Capslock to ESC (Must be done in mac system settings)
vim.g.mapleader = ","

require("swells.lazy")

-- General Vim Settings
vim.cmd("colorscheme kanagawa-wave")
vim.cmd("set mouse+=a")    -- Allow mouse drag to resize windows
vim.o.tabstop       = 2    -- Number of spaces that a <Tab> character represents
vim.o.softtabstop   = 2    -- Number of spaces that <Tab> uses while editing
vim.o.shiftwidth    = 2    -- Number of spaces to use for each indentation
vim.o.expandtab     = true -- Use spaces instead of tab characters
vim.o.termguicolors = true
vim.opt.number      = true

-- Telescope-specific keybinds 
local telescopeBuiltin = require('telescope.builtin')

vim.keymap.set('n', '<leader>ff', telescopeBuiltin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', telescopeBuiltin.live_grep,  { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', telescopeBuiltin.buffers,    { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', telescopeBuiltin.help_tags,  { desc = 'Telescope help tags' })

-- Line movement keybinds
vim.keymap.set('n', '<A-j>',      ':m .+1<CR>==',              { desc = 'Move line down' })
vim.keymap.set('n', '<A-k>',      ':m .-2<CR>==',              { desc = 'Move line up' })
vim.keymap.set('v', '<A-j>',      ":m '>+1<CR>gv=gv",          { desc = 'Move selected lines down' })
vim.keymap.set('v', '<A-k>',      ":m '<-2<CR>gv=gv",          { desc = 'Move selected lines up' })

