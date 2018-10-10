
syntax on

let mapleader=";"

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
Plug 'easymotion/vim-easymotion'
Plug 'Shougo/denite.nvim'
Plug 'Shougo/neomru.vim'
Plug 'Shougo/vimproc.vim', { 'do': 'make' }
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'nixprime/cpsm', { 'do': ':UpdateRemotePlugins' }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'thinca/vim-quickrun'
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
	call denite#custom#source('file/rec', 'matchers', ['matcher/cpsm', 'matcher/ignore_globs'])
	call denite#custom#source('file/rec', 'sorters', ['sorter/sublime'])

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

if s:is_plugged("defx.nvim")
	command DefxBufferDir Defx `expand('%:p:h')` -search=`expand('%:p')` -split=vertical
	command DefxSplit Defx -split=vertical -winwidth=50 -direction=topleft
	command VimFilerBufferDir DefxBufferDir
	command VimFiler Defx -new
	nnoremap <silent> <C-u><C-f> :<C-u>Defx -new -split=vertical<CR>

	autocmd FileType defx call s:defx_my_settings()
	function! s:defx_my_settings() abort
	  " Define mappings
	  nnoremap <silent><buffer><expr> <CR>
	  \ defx#do_action('open')
	  nnoremap <silent><buffer><expr> c
	  \ defx#do_action('copy')
	  nnoremap <silent><buffer><expr> m
	  \ defx#do_action('move')
	  nnoremap <silent><buffer><expr> p
	  \ defx#do_action('paste')
	  nnoremap <silent><buffer><expr> l
	  \ defx#do_action('open')
	  nnoremap <silent><buffer><expr> E
	  \ defx#do_action('open', 'vsplit')
	  nnoremap <silent><buffer><expr> P
	  \ defx#do_action('open', 'pedit')
	  nnoremap <silent><buffer><expr> K
	  \ defx#do_action('new_directory')
	  nnoremap <silent><buffer><expr> N
	  \ defx#do_action('new_file')
	  nnoremap <silent><buffer><expr> d
	  \ defx#do_action('remove')
	  nnoremap <silent><buffer><expr> r
	  \ defx#do_action('rename')
	  nnoremap <silent><buffer><expr> x
	  \ defx#do_action('execute_system')
	  nnoremap <silent><buffer><expr> yy
	  \ defx#do_action('yank_path')
	  nnoremap <silent><buffer><expr> .
	  \ defx#do_action('toggle_ignored_files')
	  nnoremap <silent><buffer><expr> h
	  \ defx#do_action('cd', ['..'])
	  nnoremap <silent><buffer><expr> ~
	  \ defx#do_action('cd')
	  nnoremap <silent><buffer><expr> q
	  \ defx#do_action('quit')
	  nnoremap <silent><buffer><expr> <Space>
	  \ defx#do_action('toggle_select') . 'j'
	  nnoremap <silent><buffer><expr> *
	  \ defx#do_action('toggle_select_all')
	  nnoremap <silent><buffer><expr> j
	  \ line('.') == line('$') ? 'gg' : 'j'
	  nnoremap <silent><buffer><expr> k
	  \ line('.') == 1 ? 'G' : 'k'
	  nnoremap <silent><buffer><expr> <C-l>
	  \ defx#do_action('redraw')
	  nnoremap <silent><buffer><expr> <C-g>
	  \ defx#do_action('print')
	    nnoremap <silent><buffer><expr> <Tab> winnr('$') != 1 ?
	  \ ':<C-u>wincmd w<CR>' : ':<C-u>Defx -new -split=vertical<CR>'
	endfunction
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

if s:is_plugged("vim-quickrun")
	let g:quickrun_config = get(g:, 'quickrun_config', {})
	let g:quickrun_config._ = {
		\ 'runner'    : 'vimproc',
		\ 'runner/vimproc/updatetime' : 60,
		\ 'outputter' : 'error',
		\ 'outputter/error/success' : 'buffer',
		\ 'outputter/error/error'   : 'quickfix',
		\ 'outputter/buffer/close_on_empty' : 1,
		\ }
	  let g:quickrun_config['sql'] = {
		\ 'command': 'psql',
		\ 'exec': ['%c %o < %s'],
		\ 'cmdopt': '%{MakepgsqlCommandOptions()}',
		\ }
	" stop quickrun with <Ctrl-c>
	nnoremap <expr><silent> <C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "\<C-c>"

	function ResetpgsqlOptions()
		unlet g:pgsql_config_host
		unlet g:pgsql_config_port
		unlet g:pgsql_config_user
		unlet g:pgsql_config_db
	endfunction

	function! MakepgsqlCommandOptions()
		if !exists("g:pgsql_config_host")
			let g:pgsql_config_host = input("host> ")
		endif
		if !exists("g:pgsql_config_port")
			let g:pgsql_config_port = input("port> ")
		endif
		if !exists("g:pgsql_config_user")
			let g:pgsql_config_user = input("user> ")
		endif
		if !exists("g:pgsql_config_db")
			let g:pgsql_config_db = input("database> ")
		endif

		let optlist = []
		if g:pgsql_config_user != ''
			call add(optlist, '-U ' . g:pgsql_config_user)
		endif
		if g:pgsql_config_host != ''
			call add(optlist, '-h ' . g:pgsql_config_host)
		endif
		if g:pgsql_config_port != ''
			call add(optlist, '-p ' . g:pgsql_config_port)
		endif
		if exists("g:pgsql_config_otheropts")
			call add(optlist, g:pgsql_config_otheropts)
		endif

		call add(optlist, g:pgsql_config_db)
		return join(optlist, ' ')
	endfunction
endif

if s:is_plugged("vim-monokai-pro")
	set termguicolors
	colorscheme monokai_pro
endif

if s:is_plugged("vim-easymotion")
	let g:EasyMotion_do_mapping = 0
	" <leader>f{char} to move to {char}
	map  <leader>f <Plug>(easymotion-bd-f)
	nmap <leader>f <Plug>(easymotion-overwin-f)

	" s{char}{char} to move to {char}{char}
	nmap s <Plug>(easymotion-overwin-f2)
	vmap s <Plug>(easymotion-bd-f2)

	" Move to line
	map <leader>L <Plug>(easymotion-bd-jk)
	nmap <leader>L <Plug>(easymotion-overwin-line)

	" Move to word
	map  <leader>w <Plug>(easymotion-bd-w)
	nmap <leader>w <Plug>(easymotion-overwin-w)
endif
