-- REQ: Configures nvim with lua. <>

-- SEE: https://neovim.io/doc/user/lua-guide.html <>

local l = vim.lsp
local g = vim.g
local o = vim.o

local add = vim.pack.add
local cmd = vim.cmd
local key = vim.keymap.set

local call = vim.call

g.mapleader = " "

o.tabstop = 2
o.shiftwidth = 2
o.softtabstop = 2
o.expandtab = true

o.number = true
o.relativenumber = true

o.wrap = false

o.swapfile = true

key('n', '<leader>o', ':update<CR> :source<CR>')
key('n', '<leader>w ', ':write<CR>')
key('n', '<leader>lf', l.buf.format)

key('n', '<space>e', vim.diagnostic.open_float)
key('n', '[d', vim.diagnostic.goto_prev)
key('n', ']d', vim.diagnostic.goto_next)
key('n', '<space>q', vim.diagnostic.setloclist)

-- HACK: Using special syntax to workaround reserved word attribute. <>
local treesitter_options = {} treesitter_options["do"] = ':TSUpdate'

add({
  {src = "https://github.com/fatih/vim-go"},
  {src = "https://github.com/hrsh7th/cmp-buffer"},
  {src = "https://github.com/hrsh7th/cmp-cmdline"},
  {src = "https://github.com/hrsh7th/cmp-nvim-lsp"},
  {src = "https://github.com/hrsh7th/cmp-path"},
  {src = "https://github.com/hrsh7th/cmp-vsnip"},
  {src = "https://github.com/hrsh7th/nvim-cmp"},
  {src = "https://github.com/hrsh7th/vim-vsnip"},
  {src = "https://github.com/neovim/nvim-lspconfig"},
  {src = "https://github.com/nvim-lua/plenary.nvim"},
  {src = "https://github.com/nvim-telescope/telescope.nvim", version = "0.1.x"},
  {src = "https://github.com/nvim-treesitter/nvim-treesitter"},
  {src = "https://github.com/vague2k/vague.nvim"}
})

l.enable({
  "lua_ls",
  "gopls"
})

cmd("colorscheme vague")
cmd(":highlight statusline guibg=NONE")

g.go_def_mapping_enabled = 0

for _, key in pairs({"<Up>", "<Down>", "<Left>", "<Right>"}) do
  for _, mode in pairs({"n", "v"}) do
    vim.api.nvim_set_keymap(mode, key, "<Nop>", {}) end
end

-- NOTE: Terminal-mode bindings <rbt>
vim.api.nvim_set_keymap('t', '<Esc>', [[<C-\><C-n>]], { noremap = true })

local cmp = require('cmp')

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
  }, {
    { name = 'buffer' },
  })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- SEE: https://github.com/golang/tools/blob/master/gopls/doc/vim.md#custom-configuration <>

-- SEE: https://github.com/nvim-treesitter/nvim-treesitter <>

require 'nvim-treesitter.config'.setup({
  -- A list of parser names, or "all" (the four listed parsers should always be installed)
  ensure_installed = { "bash", "vimdoc", "go", "lua", "vim" },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  highlight = {
    enable = true
  }
})

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

local telescope = require('telescope')

telescope.setup({
  defaults = {
    mappings = {
      i = {
        ["<C-h>"] = "which_key"
      }
    }
  },
})

local builtin = require('telescope.builtin')
key('n', '<leader>ff', builtin.find_files, {})
key('n', '<leader>fg', builtin.live_grep, {})
key('n', '<leader>fb', builtin.buffers, {})
key('n', '<leader>fh', builtin.help_tags, {})
