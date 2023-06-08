" Use of 'n e i o' as arrow keys for Colemak
noremap k n
noremap K N
noremap l e
noremap L E
noremap h i
noremap H I
noremap m o
noremap M O

noremap n h
noremap N H
noremap e j
" noremap E J
noremap E 4j
noremap i k
" noremap I K
noremap I 4k
noremap o l
noremap O L

" Install plugins
call plug#begin()
	Plug 'olimorris/onedarkpro.nvim' " Onedark Colorscheme
	Plug 'sheerun/vim-polyglot' " Extended syntax highlighting support
	Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " Better syntax highlighting
	" Plug 'vim-airline/vim-airline' " Better Tabline
	" Plug 'vim-airline/vim-airline-themes' " Tabline themes

	Plug 'alvan/vim-closetag' " Autoclose HTML tags
	Plug 'raimondi/delimitmate' " Autoclose and manage brackets/quotes
	Plug 'tpope/vim-surround' " Allow quickly change brackets,quotes,tags
	Plug 'tomtom/tcomment_vim' " Comment shortcut

	" Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']} " Markdown Viewer
	Plug 'dccsillag/magma-nvim', { 'do': ':UpdateRemotePlugins' } " Jupyter Notebook Support
	Plug 'RaafatTurki/hex.nvim'

	Plug 'neovim/nvim-lspconfig' " Lsp
	" Auto completion
	Plug 'hrsh7th/nvim-cmp'
	Plug 'hrsh7th/cmp-nvim-lsp'
	Plug 'hrsh7th/cmp-path'
	Plug 'saadparwaiz1/cmp_luasnip'
call plug#end()


" Set colorscheme 
set termguicolors
syntax on
colorscheme onedark_dark
" let g:airline_theme='minimalist'

" Show line numbers and highlight current line
set number
set relativenumber
set cursorline
hi CursorLine guibg=#101010
hi CursorLineNr guibg=#151515 guifg=#efefef

" Set tab length
set tabstop=4 shiftwidth=4 softtabstop=4
" Prevent tab to expand to spaces
set noexpandtab

" Indent wrapped line as much as original
set breakindent

" Change cursor
set guicursor=
" In case of error: 'set guicursor=a:hor1-blinkon250-blinkoff250'

" Auto close
let delimitMate_expand_cr=2
let delimitMate_expand_space=1
let delimitMate_expand_inside_quotes=1

" Enable system clipboard with Ctrl+p/y
noremap <C-y> "+y
noremap <C-p> "+p

" Markdown Preview

" Magma-nvim | Jupyter Notebook Support


" Lsp
set completeopt=menu,menuone,noselect
lua << EOF
	local lsp = require("lspconfig")
	local cmp = require("cmp")

	require 'hex'.setup()

	-- lsp.ccls.setup{}
	-- lsp.dartls.setup{}
	lsp.pyright.setup{}
	-- lsp.rust_analyzer.setup{}

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
			{ name = "nvim_lsp", max_item_count = 20 },
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
EOF
