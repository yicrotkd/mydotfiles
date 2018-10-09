
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
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'nixprime/cpsm', { 'do': ':UpdateRemotePlugins' }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'junegunn/vim-emoji'

" git plugin
" https://github.com/tpope/vim-fugitive
Plug 'tpope/vim-fugitive'
" asynchronous lint engine
Plug 'w0rp/ale'

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
	call denite#custom#source('file/rec', 'matchers', ['matcher/cpsm'])

	call denite#custom#var('grep', 'command', ['pt', '--nogroup', '--nocolor', '--smart-case', '--hidden'])
	call denite#custom#var('grep', 'default_opts', [])
	call denite#custom#var('grep', 'recursive_opts', [])

	call denite#custom#source('file_mru', 'matchers', ['matcher/cpsm'])

	" tabopen や vsplit のキーバインドを割り当て
	call denite#custom#map('insert', "<C-t>", '<denite:do_action:tabopen>')
	call denite#custom#map('insert', "<C-v>", '<denite:do_action:vsplit>')
	call denite#custom#map('normal', "v", '<denite:do_action:vsplit>')


	" jj で denite/insert を抜けるようにする
	call denite#custom#map('insert', 'jj', '<denite:enter_mode:normal>')

	" Change ignore_globs
	call denite#custom#filter('matcher/ignore_globs', 'ignore_globs',
		\ [ '.git/', '.ropeproject/', '__pycache__/',
		\   'venv/', 'images/', '*.min.*', 'img/', 'fonts/'])

	" key mapping
	" list flies ctrlp
	noremap <C-p> :Denite file/rec -mode=insert<CR>
	noremap [denite]<C-f> :Denite file/rec -mode=insert<CR>

	" list directories
	noremap [denite]<C-d> :<C-u>Denite directory_rec<CR>
	noremap [denite]<C-c> :<C-u>Denite directory_rec -default-action=cd<CR>

	" list file_mru
	noremap [denite]<C-u> :<C-u>Denite file_mru -mode=insert<CR>

	" grep
	nnoremap <silent> [denite]<C-g> :<C-u>Denite grep -mode=insert<CR>
	nnoremap <silent> [denite]<C-r> :<C-u>Denite -resume<CR>
	nnoremap <silent> [denite]<C-n> :<C-u>Denite -resume -cursor-pos=+1 -immediately<CR>
	nnoremap <silent> [denite]<C-p> :<C-u>Denite -resume -cursor-pos=-1 -immediately<CR>

	" moving
	call denite#custom#map('normal', '<C-n>', '<denite:move_to_next_line>', 'noremap')
	call denite#custom#map('insert', '<C-n>', '<denite:move_to_next_line>', 'noremap')
	call denite#custom#map('insert', "<Down>", '<denite:move_to_next_line>', 'noremap')
	call denite#custom#map('normal', '<C-p>', '<denite:move_to_previous_line>', 'noremap')
	call denite#custom#map('insert', '<C-p>', '<denite:move_to_previous_line>', 'noremap')
	call denite#custom#map('insert', "<Up>", '<denite:move_to_previous_line>', 'noremap')
	call denite#custom#map('normal', '<C-u>', '<denite:move_up_path>', 'noremap')
	call denite#custom#map('insert', '<C-u>', '<denite:move_up_path>', 'noremap')
endif

if s:is_plugged("neomru.vim")
	let g:neomru#file_mru_limit = 3000
	let g:neomru#follow_links = 1
endif

if s:is_plugged("ale")
	let b:ale_linters = {
	\	'javascript': ['eslint'],
	\}
	let g:ale_lint_on_text_changes = 'never'
	let g:ale_lint_on_enter = 0

	" Only run linters named in ale_linters settings.
	let g:ale_linters_explicit = 1
endif

if s:is_plugged("vim-airline")
	let g:airline_powerline_fonts=1
endif

if s:is_plugged("deoplete.nvim")
	let g:deoplete#enable_at_startup = 1
endif

set termguicolors
colorscheme monokai_pro
