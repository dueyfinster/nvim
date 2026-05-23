-- set <space> as the leader key
-- must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- fff install
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'fff.nvim' and (kind == 'install' or kind == 'update') then
      if not ev.data.active then vim.cmd.packadd('fff.nvim') end
      require('fff.download').download_or_build_binary()
    end
  end,
})

vim.pack.add({
    -- colorscheme
    { src = "https://github.com/catppuccin/nvim" },
    -- file picker
    { src = "https://github.com/dmtrKovalenko/fff.nvim" },
    -- completion
    {
        src = "https://github.com/saghen/blink.cmp",
        version = vim.version.range("^1"),
    },
    -- file manager
    { src = "https://github.com/stevearc/oil.nvim" },
    -- Show key bindings
    { src = "https://github.com/folke/which-key.nvim" },
    -- Icons
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    -- statusline
    { src = "https://github.com/nvim-lualine/lualine.nvim" },
    -- auto pairs
    { src = "https://github.com/windwp/nvim-autopairs" },
    -- file marks
    {
        src = "https://github.com/vieitesss/miniharp.nvim",
        version = vim.version.range("v*"),
    },
    -- git status UI
    {
        src = "https://github.com/vieitesss/minifugit.nvim",
        version = vim.version.range("v*"),
    },
    -- LSP config definitions required by vim.lsp.enable()
    { src = "https://github.com/neovim/nvim-lspconfig" },

    -- Package manager for lsp, formatters etc.
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
    -- pickers for buffer, help etc
    { src = 'https://github.com/nvim-mini/mini.pick' },
    { src = 'https://github.com/nvim-mini/mini.extra' },
})

require('mini.pick').setup()
require('mini.extra').setup()

require('nvim-treesitter').setup()

require('nvim-treesitter').install({
  'elixir',
  'lua',
  'go',
  'rust',
  'javascript',
  'python',
  'vim',
  'vimdoc',
})

vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH

vim.g.fff = {
    lazy_sync = true,
    preview = { enabled = false },
    frecency = { enabled = true },
}

require("mason").setup({})
require("mason-lspconfig").setup({
    ensure_installed = {
        "bashls",
        "gopls",
        "lua_ls",
        "pyright",
        "rust_analyzer",
        "yamlls",
    },
    -- Keep explicit ownership of enabled servers in lua/lsp.lua.
    automatic_enable = false,
})
require("miniharp").setup({
    autoload = true,
    autosave = true,
    show_on_autoload = false,
    notifications = true,
    ui = {
        position = "center",
        show_hints = true,
        enter = true,
    },
})
require("minifugit").setup({
    preview = {
        wrap = false,
        show_line_numbers = true,
        show_metadata = true,
        diff_layout = "stacked",
        diff_auto_threshold = 120,
    },
    status = {
        width = 0.4,
        min_width = 20,
    },
})
require("blink.cmp").setup({
    fuzzy = { implementation = "prefer_rust_with_warning" },
    signature = { enabled = true },
    keymap = {
        preset = "default",
        ["<C-space>"] = {},
        ["<C-p>"] = {},
        ["<Tab>"] = {},
        ["<S-Tab>"] = {},
        ["<C-y>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-n>"] = { "select_and_accept" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-b>"] = { "scroll_documentation_down", "fallback" },
        ["<C-f>"] = { "scroll_documentation_up", "fallback" },
        ["<C-l>"] = { "snippet_forward", "fallback" },
        ["<C-h>"] = { "snippet_backward", "fallback" },
        -- ["<C-e>"] = { "hide" },
    },

    appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "normal",
    },

    completion = {
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
        },
    },

    cmdline = {
        keymap = {
            preset = "inherit",
            ["<CR>"] = { "accept_and_enter", "fallback" },
        },
    },

    sources = { default = { "lsp" } },
})

require("oil").setup({
    default_file_explorer = true,
    columns = {
        "permissions",
        "size",
    },
    constrain_cursor = "name",
    watch_for_changes = true,
    keymaps = {
        ["g?"] = { "actions.show_help", mode = "n" },
        ["<CR>"] = "actions.select",
        ["<C-v>"] = { "actions.select", opts = { vertical = true } },
        ["<C-s>"] = { "actions.select", opts = { horizontal = true } },
        ["<C-t>"] = { "actions.select", opts = { tab = true } },
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = { "actions.close", mode = "n" },
        ["<C-l>"] = "actions.refresh",
        ["-"] = { "actions.parent", mode = "n" },
        ["_"] = { "actions.open_cwd", mode = "n" },
        ["`"] = { "actions.cd", mode = "n" },
        ["~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
        ["gs"] = { "actions.change_sort", mode = "n" },
        ["gx"] = "actions.open_external",
        ["g."] = { "actions.toggle_hidden", mode = "n" },
        ["g\\"] = { "actions.toggle_trash", mode = "n" },
    },
    view_options = {
        show_hidden = true,
    },
})

require("which-key").setup({ delay = 0, preset = "helix" })


vim.keymap.set("n", "<leader>?",
  function()
    require("which-key").show({ global = false })
  end,
  { desc = "Buffer Local Keymaps (which-key)", }
)
require("lualine").setup({
  options = {
    section_separators = { left = "", right = "", },
    component_separators = { left = "", right = "", },
  },
})
require("nvim-autopairs").setup()
