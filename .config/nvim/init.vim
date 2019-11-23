
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

Plug 'crusoexia/vim-monokai'
Plug 'phanviet/vim-monokai-pro'
Plug 'ryanoasis/vim-devicons'

" JavaScript
"Plug 'pangloss/vim-javascript', { 'for': 'javascript' }

" Rust
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
Plug 'racer-rust/vim-racer', { 'for': 'rust' }

" TypeScript
"Plug 'leafgarland/typescript-vim'
"Plug 'peitalin/vim-jsx-typescript'

" set filetypes as typescript.tsx
autocmd BufNewFile,BufRead *.tsx,*.jsx set filetype=typescript.tsx

" Kotlin
Plug 'udalov/kotlin-vim', { 'for': 'kotlin' }

Plug 'easymotion/vim-easymotion'
Plug 'Shougo/denite.nvim'
Plug 'Shougo/neomru.vim'
Plug 'Shougo/vimproc.vim', { 'do': 'make' }
"Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'kristijanhusak/defx-git'
Plug 'kristijanhusak/defx-icons'
Plug 'nixprime/cpsm', { 'do': ':UpdateRemotePlugins' }
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'thinca/vim-quickrun'
Plug 'junegunn/vim-emoji'
Plug 'szw/vim-tags'
Plug 'gabrielelana/vim-markdown'
Plug 'suan/vim-instant-markdown', {'for': 'markdown'}

" git plugin
" https://github.com/tpope/vim-fugitive
Plug 'tpope/vim-fugitive'
" asynchronous lint engine
"Plug 'w0rp/ale'

" completion plugin
" Use release branch
Plug 'neoclide/coc.nvim', { 'do': { -> coc#util#install() }}
Plug 'honza/vim-snippets'
" snake camel converter
Plug 'tpope/vim-abolish'

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

	" Floating Window
	let s:denite_win_width_percent = 0.85
	let s:denite_win_height_percent = 0.7

	" Change denite default options
	call denite#custom#option('default', {
		\ 'split': 'floating',
		\ 'winwidth': float2nr(&columns * s:denite_win_width_percent),
		\ 'wincol': float2nr((&columns - (&columns * s:denite_win_width_percent)) / 2),
		\ 'winheight': float2nr(&lines * s:denite_win_height_percent),
		\ 'winrow': float2nr((&lines - (&lines * s:denite_win_height_percent)) / 2),
		\ })

	" Enable icons (depends on vim-devicons)
	let g:webdevicons_enable_denite = 1

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
	" call denite#custom#var('grep', 'command', ['rg', '--files', '--glob', '!.git', '--glob', '!node_modules'])
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
		\   'venv/', 'images/', '*.min.*', 'img/', 'fonts/','.next/', 'node_modules/'])

	" key mapping
	" list flies ctrlp
	"noremap <C-p> :Denite file/rec<CR>
	noremap [denite]<C-f> :Denite file/rec<CR>

	" list directories
	noremap [denite]<C-d> :<C-u>Denite directory_rec<CR>
	noremap [denite]<C-c> :<C-u>Denite directory_rec<CR>

	" list file_mru
	"noremap [denite]<C-u> :<C-u>Denite file_mru<CR> "coc移行

	" grep
	"nnoremap <silent> [denite]<C-g> :<C-u>Denite grep<CR>
	"nnoremap <silent> [denite]<C-r> :<C-u>Denite -resume<CR>
	"nnoremap <silent> [denite]<C-n> :<C-u>Denite -resume -cursor-pos=+1 -immediately<CR>
	"nnoremap <silent> [denite]<C-p> :<C-u>Denite -resume -cursor-pos=-1 -immediately<CR>

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
	command DefxBufferDir Defx `expand('%:p:h')` -search=`expand('%:p')` -new -listed -resume -columns=mark:indent:git:icons:indent:filename:type
	command DefxSplit Defx -split=vertical -winwidth=50 -direction=topleft
	command VimFilerBufferDir DefxBufferDir
	command VimFiler Defx -new -listed -resume -columns=mark:indent:git:icons:indent:filename:type
	nnoremap <silent> <Space>f :VimFilerBufferDir<CR>

	let g:defx_git#column_length = 2
	let g:defx_icons_column_length = 2
	let g:defx_icons_enable_syntax_highlight = 0

	autocmd FileType defx call s:defx_my_settings()
	function! s:defx_my_settings() abort
	  " Define mappings
	  nnoremap <silent><buffer><expr> <CR>
	  \ defx#is_directory() ?
	  \ defx#do_action('open') :
	  \ defx#do_action('multi', ['drop', 'quit'])
	  nnoremap <silent><buffer><expr> c defx#do_action('copy')
	  nnoremap <silent><buffer><expr> m defx#do_action('move')
	  nnoremap <silent><buffer><expr> p defx#do_action('paste')
	  nnoremap <silent><buffer><expr> l defx#async_action('open')
	  nnoremap <silent><buffer><expr> E defx#do_action('open', 'vsplit')
	  nnoremap <silent><buffer><expr> P defx#do_action('open', 'pedit')
	  nnoremap <silent><buffer><expr> o defx#async_action('open_or_close_tree')
	  nnoremap <silent><buffer><expr> O defx#async_action('open_tree_recursive')
	  nnoremap <silent><buffer><expr> K defx#do_action('new_directory')
	  nnoremap <silent><buffer><expr> N defx#do_action('new_file')
	  nnoremap <silent><buffer><expr> M defx#do_action('new_multiple_files')
	  nnoremap <silent><buffer><expr> C defx#do_action('toggle_columns', 'mark:indent:icon:filename:type:size:time')
	  nnoremap <silent><buffer><expr> S defx#do_action('toggle_sort', 'time')
	  nnoremap <silent><buffer><expr> d defx#do_action('remove')
	  nnoremap <silent><buffer><expr> r defx#do_action('rename')
	  nnoremap <silent><buffer><expr> ! defx#do_action('execute_command')
	  nnoremap <silent><buffer><expr> x defx#do_action('execute_system')
	  nnoremap <silent><buffer><expr> yy defx#do_action('yank_path')
	  nnoremap <silent><buffer><expr> . defx#do_action('toggle_ignored_files')
	  nnoremap <silent><buffer><expr> ; defx#do_action('repeat')
	  nnoremap <silent><buffer><expr> h defx#async_action('cd', ['..'])
	  nnoremap <silent><buffer><expr> ~ defx#async_action('cd')
	  nnoremap <silent><buffer><expr> q defx#do_action('quit')
	  nnoremap <silent><buffer><expr> <Space> defx#do_action('toggle_select') . 'j'
	  nnoremap <silent><buffer><expr> * defx#do_action('toggle_select_all')
	  nnoremap <silent><buffer><expr> j line('.') == line('$') ? 'gg' : 'j'
	  nnoremap <silent><buffer><expr> k line('.') == 1 ? 'G' : 'k'
	  nnoremap <silent><buffer><expr> <C-l> defx#do_action('redraw')
	  nnoremap <silent><buffer><expr> <C-g> defx#do_action('print')
	  nnoremap <silent><buffer><expr> cd defx#do_action('change_vim_cwd')
	endfunction
endif

"if s:is_plugged("ale")
"	let g:ale_linters = {
"	\  'javascript': ['eslint'],
"	\  'typescript': ['eslint'],
"	\  'rust': ['rustc'],
"	\  'python': [],
"	\}
"	" Set this. Airline will handle the rest.
"	let g:airline#extensions#ale#enabled = 1
"
"	let g:ale_lint_on_text_changed = 'never'
"
"	let g:ale_set_loclist = 0
"	let g:ale_set_quickfix = 1
"
"	command! ALEToggleFixer execute "let g:ale_fix_on_save = get(g:, 'ale_fix_on_save', 0) ? 0 : 1"
"
"	function! LinterStatus() abort
"		let l:counts = ale#statusline#Count(bufnr(''))
"
"		let l:all_errors = l:counts.error + l:counts.style_error
"		let l:all_non_errors = l:counts.total - l:all_errors
"
"		return l:counts.total == 0 ? 'OK' : printf(
"		\   '%dW %dE',
"		\   all_non_errors,
"		\   all_errors
"		\)
"	endfunction
"	set statusline=%{LinterStatus()}
"
"	" perttier settings
"	let g:ale_fixers = {}
"	let g:ale_fixers['javascript'] = ['prettier']
"    let g:ale_fixers['typescript'] = ['prettier']
"    let g:ale_fixers['yaml'] = ['prettier']
"
"	let g:ale_pattern_options = {
"	\   'renngadev': {'ale_fixers': []},
"	\}
"
"	" ファイル保存時に実行
"	let g:ale_fix_on_save = 1
"
"	" ローカルの設定ファイルを考慮する
"	let g:ale_javascript_prettier_use_local_config = 1
"	let g:ale_typescript_prettier_use_local_config = 1
"
"endif

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

"if s:is_plugged("deoplete.nvim")
"	let g:deoplete#enable_at_startup = 1
"	" Use smartcase.
"	call deoplete#custom#option('smart_case', v:true)
"
"	" <C-h>, <BS>: close popup and delete backword char.
"	inoremap <expr><C-h> deoplete#smart_close_popup()."\<C-h>"
"	inoremap <expr><BS>  deoplete#smart_close_popup()."\<C-h>"
"endif

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

if s:is_plugged("vim-markdown")
	let g:markdown_enable_folding = 1
endif

if s:is_plugged("vim-instant-markdown")
	filetype plugin on
	"Uncomment to override defaults:
	let g:instant_markdown_slow = 1
	let g:instant_markdown_autostart = 0
	"let g:instant_markdown_open_to_the_world = 1 
	"let g:instant_markdown_allow_unsafe_content = 1
	"let g:instant_markdown_allow_external_content = 0
	"let g:instant_markdown_mathjax = 1
endif

if s:is_plugged("coc.nvim")
	nmap <C-u> [coc]
	" for multi cursor
	hi CocCursorRange guibg=#b16286 guifg=#ebdbb2

	augroup HTMLANDXML
		autocmd!
		autocmd Filetype xml inoremap <buffer> </ </<C-x><C-o>
		autocmd Filetype html inoremap <buffer> </ </<C-x><C-o>
	augroup END

	" use <tab> for trigger completion and navigate to next complete item
	function! s:check_back_space() abort
		let col = col('.') - 1
		return !col || getline('.')[col - 1]  =~ '\s'
	endfunction
	inoremap <silent><expr> <TAB>
		  \ pumvisible() ? coc#_select_confirm() :
		  \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
		  \ <SID>check_back_space() ? "\<TAB>" :
		  \ coc#refresh()

	let g:airline#extensions#coc#enabled = 1
	let airline#extensions#coc#error_symbol = 'E:'
	let airline#extensions#coc#warning_symbol = 'W:'
	let airline#extensions#coc#stl_format_err = '%E{[%e(#%fe)]}'
	let airline#extensions#coc#stl_format_warn = '%W{[%w(#%fw)]}'

	"ノーマルモードで
	"スペース2回でCocList
	nmap <silent> <space><space> :<C-u>CocList<cr>
	"スペースhでHover
	nmap <silent> <space>h :<C-u>call CocAction('doHover')<cr>
	"スペースdfでDefinition
	nmap <silent> <space>d <Plug>(coc-definition)
	"スペースbで戻る
	nmap <silent> <space>b :<C-u>CocPrev<cr>
	"スペースrfでReferences
	nmap <silent> <space>rf <Plug>(coc-references)
	"スペースtyでTypeDefinition
	nmap <silent> <space>t <Plug>(coc-type-definition)
	"スペースimpでImplementation
	nmap <silent> <space>i <Plug>(coc-implementation)
	"スペースrnでRename
	nmap <silent> <space>rn <Plug>(coc-rename)
	"スペースfmtでFormat
	nmap <silent> <space>fmt <Plug>(coc-format)
	"スペースqfでFormat
	nmap <silent> <space>qf <Plug>(coc-fix-current)

	" Use `[g` and `]g` to navigate diagnostics
	nmap <silent> [g <Plug>(coc-diagnostic-prev)
	nmap <silent> ]g <Plug>(coc-diagnostic-next)

	" Use <C-l> for trigger snippet expand.
	imap <C-l> <Plug>(coc-snippets-expand)

	" Use <C-j> for select text for visual placeholder of snippet.
	"vmap <C-j> <Plug>(coc-snippets-select)

	let g:coc_snippet_next = '<tab>'

	" Use <C-j> for both expand and jump (make expand higher priority.)
	imap <C-j> <Plug>(coc-snippets-expand-jump)

	" multi cursor settings
	nmap <silent> <C-c> <Plug>(coc-cursors-position)
	nmap <silent> <C-d> <Plug>(coc-cursors-word)*
	xmap <silent> <C-d> y/\V<C-r>=escape(@",'/\')<CR><CR>gN<Plug>(coc-cursors-range)gn
	" use normal command like `<leader>xi(`
	nmap <leader>x  <Plug>(coc-cursors-operator)

	" CocList settings
	" grep current word in current buffer
	nnoremap <silent> <space>w  :exe 'CocList -I --normal --input='.expand('<cword>').' words'<CR>

	" 全てのファイルを対象とする
	noremap [coc]<C-u> :<C-u>CocList mru -A<CR>
	" grep
	noremap [coc]<C-g> :<C-u>CocList grep<CR>
	noremap <C-p> :<C-u>CocList files<CR>

	noremap [coc]<C-r> :<C-u>CocListResume<CR>

endif
