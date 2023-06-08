local let = vim.g
local set = vim.o
local map = vim.keymap.set
local hi = vim.api.nvim_set_hl

map('', 'k', 'n')
map('', 'K', 'N')
map('', 'l', 'e')
map('', 'L', 'E')
map('', 'h', 'i')
map('', 'H', 'I')
map('', 'm', 'o')
map('', 'M', 'O')

map('', 'n', 'h')
map('', 'N', 'H')
map('', 'e', 'j')
-- map('', 'E', 'J')
map('', 'E', '4j')
map('', 'i', 'k')
-- map('', 'I', 'K')
map('', 'I', '4k')
map('', 'o', 'l')
map('', 'O', 'L')


-- vim.cmd('packadd packer.nvim')
require('packer').startup(function(use)
	use{'wbthomason/packer.nvim'} -- Plugin manager

	use{'olimorris/onedarkpro.nvim'} -- Onedark Colorscheme
	use{'sheerun/vim-polyglot'} -- Extended syntax highlighting support
	-- use{'nvim-treesitter/nvim-treesitter', run=':TSUpdate'} -- Better syntax highlighting
	-- use{'vim-airline/vim-airline'} -- Better Status Line
	-- use{'vim-airline/vim-airline-themes'} -- Status Line themes
	-- use{
	-- 	'nvim-tree/nvim-tree.lua',
	-- 	requires={'nvim-tree/nvim-web-devicons'}
	-- }
    --
	use{'alvan/vim-closetag'} -- Autoclose HTML tags
	use{'raimondi/delimitmate'} -- Autoclose and manage brackets/quotes
	use{'tpope/vim-surround'} -- Allow quickly change brackets,quotes,tags
	use{'tomtom/tcomment_vim'} -- Comment shortcut

	-- use{'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']} -- Markdown Viewer
	-- use{'dccsillag/magma-nvim', run=':UpdateRemotePlugins'} -- Jupyter Notebook Support
	use{'RaafatTurki/hex.nvim'} -- Hex/Binary Support

	---Lsp
		use{'neovim/nvim-lspconfig'}
		-- Auto completion
		use{'hrsh7th/nvim-cmp'}
		use{'hrsh7th/cmp-nvim-lsp'}
		use{'hrsh7th/cmp-path'}
		use{'L3MON4D3/LuaSnip'}
		use{'saadparwaiz1/cmp_luasnip'}
end)


set.termguicolors = true
local color = require("onedarkpro.helpers")
require('onedarkpro').setup({
		colors = {
			bg = color.darken('#282c34', 16),
			float_bg = color.darken('#282c34', 10),
			cursorline = color.darken('#282c34', 12)
		},
		options = {
			cursorline = true
		}
	})
vim.cmd.colorscheme('onedark_dark')
-- let.airline_theme='minimalist'

-- Show line numbers and highlight current line
set.number = true
set.relativenumber = true
-- set.cursorline = true


-- 0 = global
-- hi(0, "CursorLine", { bg='#050911' })
hi(0, "CursorLineNr", { bg=color.darken('#282c34', 12), fg='#efefef' })
hi(0, "TabLine", { fg='#a0a0a0' })
hi(0, "TabLineSel", { fg='#e7e7e7', bg='#171717' })
--
-- nvim-tree
let.loaded_netrw = 1
let.loaded_netrwPlugin = 1

-- require('nvim-tree').setup()

-- Hex/Binary Editor
require 'hex'.setup()

-- Set tab length
set.tabstop = 4
set.shiftwidth = 4
set.softtabstop = 4
-- Prevent tab to expand to spaces
set.noexpandtab = true
-- Change cursor
set.breakindent = true

-- Change cursor
set.guicursor = false

-- Auto close
let.delimitMate_expand_cr = 2
let.delimitMate_expand_space = 1
let.delimitMate_expand_inside_quotes = 1

 -- Enable system clipboard with Ctrl+p/y
 map('', '<C-y>', '"+y')
 map('', '<C-p>', '"+p')

-- Treesitter
-- require('nvim-treesitter.configs').setup{
-- 	highlight = { enable = true }
-- }

-- LSP
local lsp = require("lspconfig")
local cmp = require("cmp")

lsp.ccls.setup{}
lsp.pyright.setup{}
lsp.rust_analyzer.setup{}

cmp.setup({
	snippet = {
		expand = function(args)
		require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = {
		["<C-A-e>"] = cmp.mapping.scroll_docs(4),
		["<C-A-i>"] = cmp.mapping.scroll_docs(-4),
		["<C-e>"] = cmp.mapping.select_next_item(),
		["<C-i>"] = cmp.mapping.select_prev_item(),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-n>"] = cmp.mapping.abort(),
		["<C-o>"] = cmp.mapping.confirm({ select = true }),
	},
	sources = {
		-- { name = "luasnip" },
		{ name = "nvim_lsp", max_item_count = 8 },
		{ name = "path" }
	},
	view = {
		entries = {
			name = "custom",
			selection_order = "near_cursor",
		}
	},
	experimental = {
		ghost_text = true,
	},
})
vim.diagnostic.disable()
