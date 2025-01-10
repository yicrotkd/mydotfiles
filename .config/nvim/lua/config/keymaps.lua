-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set("n", "<C-h>", "<C-w><", { desc = "Resize the window to the left" })
vim.keymap.set("n", "<C-l>", "<C-w>>", { desc = "Resize the window to the right" })
vim.keymap.set("n", "<C-j>", "<C-e>", { desc = "Move to the lower window without cursor moving" })
vim.keymap.set("n", "<C-k>", "<C-y>", { desc = "Move to the upper window without cursor moving" })

vim.keymap.set("n", "<leader>ev", ":e $MYVIMRC<cr>", { desc = "Open my vimrc" })

-- fzf-lua keybind
vim.keymap.set("n", "<C-\\>", [[<Cmd>lua require"fzf-lua".buffers()<CR>]], {})
vim.keymap.set("n", "<C-u><C-r>", [[<Cmd>lua require"fzf-lua".resume()<CR>]], { desc = "Resume fzf-lua" })
vim.keymap.set("n", "<C-u><C-u>", [[<Cmd>lua require"fzf-lua".mru()<CR>]], { desc = "Resume fzf-lua" })
vim.keymap.set("n", "<C-u><C-b>", [[<Cmd>lua require"fzf-lua".builtin()<CR>]], { desc = "Builtins fzf-lua" })
vim.keymap.set("n", "<C-u><C-c>", [[<Cmd>lua require"fzf-lua".commands()<CR>]], { desc = "Commands fzf-lua" })
vim.keymap.set("n", "<C-p>", [[<Cmd>lua require"fzf-lua".files()<CR>]], { desc = "Find files with fzf-lua" })
vim.keymap.set("n", "<C-l>", [[<Cmd>lua require"fzf-lua".live_grep_glob()<CR>]], {})
vim.keymap.set("n", "<C-g>", [[<Cmd>lua require"fzf-lua".grep_project()<CR>]], {})
vim.keymap.set("n", "<F1>", [[<Cmd>lua require"fzf-lua".help_tags()<CR>]], {})
