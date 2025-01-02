vim.g.mapleader = ","
require("swells.lazy")
-- Set tab width to 2 spaces
vim.o.tabstop = 2      -- Number of spaces that a <Tab> character represents
vim.o.softtabstop = 2  -- Number of spaces that <Tab> uses while editing
vim.o.shiftwidth = 2   -- Number of spaces to use for each indentation
vim.o.expandtab = true -- Use spaces instead of tab characters
vim.o.termguicolors = true
vim.opt.number = true
vim.cmd("colorscheme kanagawa-wave")
vim.cmd("set mouse+=a")
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
-- Move a line up
vim.keymap.set('n', '<A-j>', ':m .+1<CR>==', { desc = 'Move line down' })
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==', { desc = 'Move line up' })

-- Move selected lines up and down in visual mode
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move selected lines down' })
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move selected lines up' })

