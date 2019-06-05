
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
set fileencodings=utf-8,sjis,euc-jp

" keymapping
noremap <C-J> <C-E>
noremap <C-K> <C-Y>
noremap <C-H> <C-W><
noremap <C-L> <C-W>>

" auto-install vim-plug                                                                                                                
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugin Management
call plug#begin('~/.config/nvim/plugged')

Plug 'cocopon/vaffle.vim', { 'on': 'Vaffle'}
Plug 'crusoexia/vim-monokai'
Plug 'phanviet/vim-monokai-pro'

" JavaScript
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }

" Rust
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
Plug 'racer-rust/vim-racer', { 'for': 'rust' }

" TypeScript
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'

" set filetypes as typescript.tsx
"autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescript.tsx

" Kotlin
Plug 'udalov/kotlin-vim', { 'for': 'kotlin' }

Plug 'easymotion/vim-easymotion'
Plug 'Shougo/denite.nvim'
Plug 'Shougo/neomru.vim'
Plug 'Shougo/vimproc.vim', { 'do': 'make' }
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'kristijanhusak/defx-git'
Plug 'nixprime/cpsm', { 'do': ':UpdateRemotePlugins' }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'thinca/vim-quickrun'
Plug 'junegunn/vim-emoji'
Plug 'szw/vim-tags'

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

	" Define mappings
	autocmd FileType denite call s:denite_my_settings()
	function! s:denite_my_settings() abort
	  nnoremap <silent><buffer><expr> <CR>
	  \ denite#do_map('do_action')
	  nnoremap <silent><buffer><expr> d
	  \ denite#do_map('do_action', 'delete')
	  nnoremap <silent><buffer><expr> p
	  \ denite#do_map('do_action', 'preview')
	  nnoremap <silent><buffer><expr> q
	  \ denite#do_map('quit')
	  nnoremap <silent><buffer><expr> i
	  \ denite#do_map('open_filter_buffer')
	  nnoremap <silent><buffer><expr> <Space>
	  \ denite#do_map('toggle_select').'j'
	endfunction

	call denite#custom#var('file/rec', 'command', ['rg', '--files', '--glob', '!.git', '--glob', '!node_modules'])
	call denite#custom#source('file/rec', 'matchers', ['matcher/cpsm', 'matcher/project_files', 'matcher/ignore_globs'])
	call denite#custom#source('file/rec', 'sorters', ['sorter/sublime'])

	call denite#custom#var('grep', 'command', ['pt', '--nogroup', '--nocolor', '--smart-case', '--hidden'])
	call denite#custom#var('grep', 'default_opts', [])
	call denite#custom#var('grep', 'recursive_opts', [])
	" narrow by path in grep source
	call denite#custom#source('grep', 'converters', ['converter/abbr_word'])

	call denite#custom#source('file_mru', 'matchers', ['matcher/substring'])

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
	noremap <C-p> :Denite file/rec<CR>
	noremap [denite]<C-f> :Denite file/rec<CR>

	" list directories
	noremap [denite]<C-d> :<C-u>Denite directory_rec<CR>
	noremap [denite]<C-c> :<C-u>Denite directory_rec<CR>

	" list file_mru
	noremap [denite]<C-u> :<C-u>Denite file_mru<CR>

	" grep
	nnoremap <silent> [denite]<C-g> :<C-u>Denite grep<CR>
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
	" cursor key
	call denite#custom#map('insert','<Down>', '<denite:move_to_next_line>', 'noremap')
	call denite#custom#map('insert', '<Up>', '<denite:move_to_previous_line>', 'noremap')

	call denite#custom#option('_', {
		\ 'start_filter': v:true
		\ })
endif

if s:is_plugged("neomru.vim")
	let g:neomru#file_mru_limit = 3000
	let g:neomru#follow_links = 1
endif

if s:is_plugged("defx.nvim")
	command DefxBufferDir Defx `expand('%:p:h')` -search=`expand('%:p')` -new -columns=git:mark:filename:type
	command DefxSplit Defx -split=vertical -winwidth=50 -direction=topleft
	command VimFilerBufferDir DefxBufferDir
	command VimFiler Defx -new -columns=git:mark:filename:type

	let g:defx_git#column_length = 2

	autocmd FileType defx call s:defx_my_settings()
	function! s:defx_my_settings() abort
	  " Define mappings
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
	  nnoremap <silent><buffer><expr> <CR>
	  \ defx#do_action('drop')
	  nnoremap <silent><buffer><expr> j
	  \ line('.') == line('$') ? 'gg' : 'j'
	  nnoremap <silent><buffer><expr> k
	  \ line('.') == 1 ? 'G' : 'k'
	  nnoremap <silent><buffer><expr> <C-l>
	  \ defx#do_action('redraw')
	  nnoremap <silent><buffer><expr> <C-g>
	  \ defx#do_action('print')
	  nnoremap <silent><buffer><expr> cd
	  \ defx#do_action('change_vim_cwd')
	endfunction
endif

if s:is_plugged("ale")
	let g:ale_linters = {
	\  'javascript': ['eslint'],
	\  'typescript': ['eslint'],
	\  'rust': ['rustc'],
	\}
	" Set this. Airline will handle the rest.
	let g:airline#extensions#ale#enabled = 1

	let g:ale_lint_on_text_changed = 'never'

	let g:ale_set_loclist = 0
	let g:ale_set_quickfix = 1

	function! LinterStatus() abort
		let l:counts = ale#statusline#Count(bufnr(''))

		let l:all_errors = l:counts.error + l:counts.style_error
		let l:all_non_errors = l:counts.total - l:all_errors

		return l:counts.total == 0 ? 'OK' : printf(
		\   '%dW %dE',
		\   all_non_errors,
		\   all_errors
		\)
	endfunction
	set statusline=%{LinterStatus()}

	" perttier settings
	let g:ale_fixers = {}
	let g:ale_fixers['javascript'] = ['prettier-eslint']
    let g:ale_fixers['typescript'] = ['prettier']
    let g:ale_fixers['typescript'] = ['eslint']

	" ファイル保存時に実行
	let g:ale_fix_on_save = 1

	" ローカルの設定ファイルを考慮する
	let g:ale_javascript_prettier_use_local_config = 1
	let g:ale_typescript_prettier_use_local_config = 1

endif

if s:is_plugged("rust.vim")
	let g:rustfmt_autosave = 1
	let g:rustfmt_command = "$HOME/.cargo/bin/rustfmt"
endif

if s:is_plugged("vim-racer")
	set hidden
	let g:racer_cmd = "$HOME/.cargo/bin/racer"
	let g:racer_experimental_completer = 1

	au FileType rust nmap gd <Plug>(rust-def)
	au FileType rust nmap gs <Plug>(rust-def-split)
	au FileType rust nmap gx <Plug>(rust-def-vertical)
	au FileType rust nmap <leader>gd <Plug>(rust-doc)
endif

if s:is_plugged("vim-airline")
	let g:airline_powerline_fonts = 1
endif

if s:is_plugged("deoplete.nvim")
	let g:deoplete#enable_at_startup = 1
	" Use smartcase.
	call deoplete#custom#option('smart_case', v:true)

	" <C-h>, <BS>: close popup and delete backword char.
	inoremap <expr><C-h> deoplete#smart_close_popup()."\<C-h>"
	inoremap <expr><BS>  deoplete#smart_close_popup()."\<C-h>"
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

if s:is_plugged("vim-tags")
	nmap <C-i> :pop<CR>
endif
