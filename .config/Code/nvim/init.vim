
syntax on

set number
set cursorcolumn
set cursorline
set list lcs=tab:>-
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
set ignorecase
set smartcase
set smartindent
set ruler
set showcmd
set cmdheight=2
set softtabstop=4
set shiftwidth=4
set tabstop=4
set showtabline=2
set laststatus=2

" keymapping
noremap <C-J> <C-E>
noremap <C-K> <C-Y>
noremap <C-H> <C-W><
noremap <C-L> <C-W>>

" Plugin Management
call plug#begin('~/.local/share/nvim/plugged')

Plug 'cocopon/vaffle.vim', { 'on': 'Vaffle'}
Plug 'crusoexia/vim-monokai'
Plug 'phanviet/vim-monokai-pro'
Plug 'pangloss/vim-javascript'
Plug 'Shougo/denite.nvim'
Plug 'Shougo/neomru.vim'

call plug#end()

" check the specified plugin is installed
function s:is_plugged(name)
	if exists('g:plugs') && has_key(g:plugs, a:name) && isdirectory(g:plugs[a:name].dir)
		return 1
	else
		return 0
	endif
endfunction

if s:is_plugged("denite.nvim")
	nnoremap [denite] <Nop>
	nmap <C-u> [denite]

	call denite#custom#var('file/rec', 'command', ['rg', '--files', '--glob', '!.git', '--glob', '!node_modules'])
	call denite#custom#var('grep', 'command', ['rg'])

	call denite#custom#source('file_mru', 'matchers', ['matcher/fuzzy', 'matcher/project_files'])
	call denite#custom#source('file/rec', 'matchers', ['matcher/cpsm'])

	" denite/insert モードのときは，C- で移動できるようにする
	call denite#custom#map('insert', "<C-j>", '<denite:move_to_next_line>')
	call denite#custom#map('insert', "<C-k>", '<denite:move_to_previous_line>')

	" tabopen や vsplit のキーバインドを割り当て
	call denite#custom#map('insert', "<C-t>", '<denite:do_action:tabopen>')
	call denite#custom#map('insert', "<C-v>", '<denite:do_action:vsplit>')
	call denite#custom#map('normal', "v", '<denite:do_action:vsplit>')

	" jj で denite/insert を抜けるようにする
	call denite#custom#map('insert', 'jj', '<denite:enter_mode:normal>')

	" key mapping
	" list flies ctrlp
	noremap <C-p> :Denite file_rec -mode=insert<CR>
	noremap [denite]<C-f> :Denite file_rec -mode=insert<CR>

	" list directories
	noremap [denite]<C-d> :<C-u>Denite directory_rec<CR>
	noremap [denite]<C-c> :<C-u>Denite directory_rec -default-action=cd<CR>

	" list file_mru
	noremap [denite]<C-u> :<C-u>Denite file_mru -mode=insert<CR>

	" moving
	call denite#custom#map('normal', '<C-n>', '<denite:move_to_next_line>', 'noremap')
	call denite#custom#map('insert', '<C-n>', '<denite:move_to_next_line>', 'noremap')
	call denite#custom#map('normal', '<C-p>', '<denite:move_to_previous_line>', 'noremap')
	call denite#custom#map('insert', '<C-p>', '<denite:move_to_previous_line>', 'noremap')
	call denite#custom#map('normal', '<C-u>', '<denite:move_up_path>', 'noremap')
	call denite#custom#map('insert', '<C-u>', '<denite:move_up_path>', 'noremap')
endif

set termguicolors
colorscheme monokai_pro
