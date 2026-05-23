local keymap = vim.keymap.set

-- All important leader key
vim.g.mapleader = " "

keymap("n", "<space>", "<Nop>", { desc = "Leader noop" })

-- movement
keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Down by display line" })
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Up by display line" })
keymap("n", "<C-d>", "<C-d>zz", { desc = "Half-page down and center" })
keymap("n", "<C-u>", "<C-u>zz", { desc = "Half-page up and center" })

--- save and quit
keymap("n", "<Leader>s", "<cmd>w!<CR>", { silent = true, desc = "Save file" })
keymap("n", "<Leader>q", "<cmd>q<CR>", { silent = true, desc = "Quit window" })

-- tabs
keymap("n", "<Leader>te", "<cmd>tabnew<CR>", { silent = true, desc = "Tab new" })
keymap("n", "<Leader>tn", "<cmd>tabn<CR>", { silent = true, desc = "Tab next" })
keymap("n", "<Leader>tp", "<cmd>tabp<CR>", { silent = true, desc = "Tab previous" })
keymap("n", "<Leader>tc", "<cmd>tabclose<CR>", { silent = true, desc = "Tab close" })

--- split windows
keymap("n", "<Leader>wh", "<cmd>split<CR>", { silent = true, desc = "Split horizontal" })
keymap("n", "<Leader>wv", "<cmd>vsplit<CR>", { silent = true, desc = "Split vertical" })

-- copy and paste
keymap("v", "<Leader>p", '"_dP', { desc = "Paste without yanking replaced text" })
keymap("x", "y", [["+y]], { silent = true, desc = "Yank to system clipboard" })

-- cd current dir
keymap("n", "<leader>wd", '<cmd>lua vim.fn.chdir(vim.fn.expand("%:p:h"))<CR>', { desc = "Cwd to buffer directory" })

keymap("n", "<leader>dn", "<cmd>lua vim.diagnostic.jump({count = 1})<CR>", { noremap = true, silent = true, desc = "Next diagnostic" })
keymap("n", "<leader>dp", "<cmd>lua vim.diagnostic.jump({count = -1})<CR>", { noremap = true, silent = true, desc = "Previous diagnostic" })

keymap("n", "<leader>ha", function()
    require("miniharp").toggle_file()
end, { desc = "Toggle file mark" })
keymap("n", "<leader>hh", function()
    require("miniharp").show_list()
end, { desc = "Toggle marks list" })
keymap("n", "<leader>he", function()
    require("miniharp").enter_list()
end, { desc = "Enter marks list" })
keymap("n", "<leader>hn", function()
    require("miniharp").next()
end, { desc = "Next marked file" })
keymap("n", "<leader>hp", function()
    require("miniharp").prev()
end, { desc = "Previous marked file" })
keymap("n", "<leader>h1", function()
    require("miniharp").go_to(1)
end, { desc = "Go to mark 1" })
keymap("n", "<leader>h2", function()
    require("miniharp").go_to(2)
end, { desc = "Go to mark 2" })
keymap("n", "<leader>h3", function()
    require("miniharp").go_to(3)
end, { desc = "Go to mark 3" })
keymap("n", "<leader>h4", function()
    require("miniharp").go_to(4)
end, { desc = "Go to mark 4" })

keymap("n", "<leader>gg", "<cmd>MinifugitStatus<CR>", { desc = "Git status" })
keymap("n", "<leader>gh", "<cmd>checkhealth minifugit<CR>", { desc = "Minifugit health" })

keymap("n", "<leader>od", function()
    vim.cmd.edit(vim.fn.expand("%:p:h"))
end, { desc = "Open buffer directory" })
keymap("n", "<leader>oo", "<cmd>Oil<CR>", { desc = "Open Oil" })
keymap("n", "<leader>oc", function()
    require("oil").open(vim.fn.getcwd())
end, { desc = "Open Oil at cwd" })



local function visual_selection()
    local mode = vim.fn.mode()
    local start_pos, end_pos, region_type

    if mode:match("^[vV\22]") then
        start_pos, end_pos, region_type = vim.fn.getpos("v"), vim.fn.getpos("."), mode
    else
        start_pos, end_pos, region_type = vim.fn.getpos("'<"), vim.fn.getpos("'>"), vim.fn.visualmode()
    end

    local ok, lines = pcall(vim.fn.getregion, start_pos, end_pos, { type = region_type })
    if not ok or not lines then return "" end
    return vim.trim(table.concat(lines, " "))
end

keymap("x", "<leader>fg", function()
    local query = visual_selection()
    if query ~= "" then
        require("fff").live_grep({ query = query })
    end
end, { desc = "Grep visual selection" })


vim.keymap.set('n', '<leader>ff', function()
  require('fff').find_files()
end, { desc = 'Find files' })

vim.keymap.set('n', '<leader>fb', function()
  require('mini.pick').builtin.buffers()
end, { desc = 'Buffers' })

vim.keymap.set('n', '<leader>fh', function()
  require('mini.pick').builtin.help()
end, { desc = 'Help' })

vim.keymap.set('n', '<leader>fo', function()
  require('mini.extra').pickers.oldfiles()
end, { desc = 'Old files' })

vim.keymap.set('n', '<leader>fd', function()
  require('mini.extra').pickers.diagnostic()
end, { desc = 'Diagnostics' })

require("which-key").add({
  { "<leader>d", group = "diagnostics" },
  { "<leader>f", group = "find" },
  { "<leader>g", group = "git" },
  { "<leader>h", group = "harp" },
  { "<leader>o", group = "open" },
  { "<leader>q", group = "quit" },
  { "<leader>t", group = "tabs" },
  { "<leader>w", group = "window" },
})
