set nocompatible
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/ftplugin/xml-sql_fold.vim
behave mswin

set diffexpr=MyDiff()
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let eq = ''
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      let cmd = '""' . $VIMRUNTIME . '\diff"'
      let eq = '"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction

" custom settings (takeda)
"
"
syntax on
au BufRead,BufNewFile *.fsp set filetype=fsp
au BufRead,BufNewFile *.sqltmpl set filetype=sqltmpl
au BufRead,BufNewFile SQL*.xml set filetype=xml-sql
au BufRead,BufNewFile *_*.xml set filetype=honeybee
au BufRead,BufNewFile *_*.xml.* set filetype=honeybee
au BufRead,BufNewFile *_*.js set filetype=js-fsp

set background=dark
set t_Co=256
" colorscheme robokai
colorscheme molokai
if has("gui_running")
  colorscheme molokai
endif

" let g:xml_syntax_folding = 1
" set foldmethod=syntax

set foldmethod=expr foldexpr=XmlSQLFold(v:lnum)

set number
set ruler
set cursorcolumn
set cursorline
set title
set titlelen=95
set showcmd
set cmdheight=2
set smartindent
set backup
set backupdir=~/tmp/vim_backup
set softtabstop=4
set shiftwidth=4
set tabstop=4
set showtabline=2
set laststatus=2
" set shiftwidth=4
set ignorecase
set smartcase
set whichwrap=b,s,h,l,<,>,[,]
set wrapscan
set incsearch
set hlsearch
set showmatch
set guifont=Ricty\ 10.5
set wrap
set wildmenu
set tabstop=4
set list lcs=tab:>-
set clipboard=unnamed,autoselect
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]

" keymap
"
noremap <C-J> <C-E>
noremap <C-K> <C-Y>
noremap <C-H> <C-W><
noremap <C-L> <C-W>>

"" quickfix keymap
nnoremap [q :cprevious<CR>
nnoremap ]q :cnext<CR>
nnoremap [Q :<C-u>cfirst<CR>
nnoremap ]Q :<C-u>clast<CR>
autocmd QuickFixCmdPost *grep* cwindow

" @ uzai
"
inoremap <C-@> <C-[>

set nocompatible
filetype plugin indent off

if has('vim_starting')
    set runtimepath+=~/.vim/neobundle.vim
    call neobundle#rc(expand('~/.bundle'))
endif

NeoBundle 'git://github.com/Shougo/unite.vim.git'
NeoBundle 'git://github.com/Shougo/neobundle.vim.git'
NeoBundle 'git://github.com/Shougo/neomru.vim.git'
NeoBundle 'https://github.com/Shougo/neocomplcache'
NeoBundle 'https://github.com/Shougo/vimshell'
NeoBundle 'https://github.com/Shougo/vimproc'
NeoBundle 'https://github.com/Shougo/vimfiler'
NeoBundle 'https://github.com/thinca/vim-quickrun'
NeoBundle 'https://github.com/scrooloose/nerdtree'
NeoBundle 'git://github.com/vim-scripts/sudo.vim.git'
NeoBundle 'git://github.com/scrooloose/syntastic.git'
NeoBundle 'git://github.com/fatih/vim-go.git'
NeoBundle 'https://github.com/ctrlpvim/ctrlp.vim'
NeoBundle 'https://github.com/dag/vim2hs'
NeoBundle 'https://github.com/eagletmt/neco-ghc'
NeoBundle 'https://github.com/eagletmt/ghcmod-vim'
NeoBundle 'https://github.com/easymotion/vim-easymotion'
NeoBundle 'https://github.com/Shougo/neosnippet'
NeoBundle 'https://github.com/Shougo/neosnippet-snippets'
NeoBundle 'haya14busa/incsearch.vim'
NeoBundle 'haya14busa/incsearch-migemo.vim'
NeoBundle 'haya14busa/vim-migemo'
NeoBundle 'tmhedberg/matchit'
NeoBundle 'rking/ag.vim'

filetype plugin indent on

execute pathogen#infect()

"-----------------------------------------------
" Configuration of syntastic
"-----------------------------------------------
let g:syntastic_mode_map = { 'mode': 'active',
                           \ 'active_filetypes': ['ruby', 'javascript', 'python', 'haskell'],
                           \ 'passive_filetypes': ['java', 'c'] }
let g:syntastic_enable_signs=1
let g:syntastic_javascript_checkers=['eslint']
let g:syntastic_auto_loc_list=1
let g:syntastic_loc_list_height=4
let g:syntastic_python_checkers = ['pyflakes', 'pep8']

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0


"-----------------------------------------------
" Configuration of neocomplcache
"-----------------------------------------------
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Use camel case completion.
let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
let g:neocomplcache_enable_underbar_completion = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
    \ 'default' : '',
    \ 'perl' : $HOME.'/.vim/dictionary/perl.dict'
    \ }

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
  let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
imap <C-k>     <Plug>(neocomplcache_snippets_expand)
smap <C-k>     <Plug>(neocomplcache_snippets_expand)
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" SuperTab like snippets behavior.
"imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ? "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()

"--------------------------------------------
" unite.vim configuration
" -------------------------------------------
" Start with insert-mode
let g:unite_enable_start_insert = 1
let g:unite_source_history_yank_enable = 1

let g:unite_enable_ignore_case = 1
let g:unite_enable_smart_case = 1

let g:unite_source_file_mru_limit = 1000
" View all buffer
noremap <C-U><C-B> :Unite buffer<CR>
" Vier all files
noremap <C-U><C-F> :UniteWithBufferDir -buffer-name=files file<CR>
" View history of yank
noremap <C-U><C-Y> :Unite history/yank<CR>
" View all registers
noremap <C-U><C-R> :Unite -buffer-name=register register<CR>
" Files and buffers
noremap <C-U><C-U> :Unite buffer file_mru<CR>
" All view
noremap <C-U><C-A> :Unite -buffer-name=files buffer file_mru bookmark file<CR>
" Search like ctrlp
noremap <C-U><C-P> :Unite file_rec/async<CR>
" Close unite
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>:q<CR>

" Search all files under current directory
nnoremap <silent> ,g :<C-u>Unite grep:. -buffer-name=search-buffer<CR>
" Search under current directory with cursor's word
nnoremap <silent> ,cg :<C-u>Unite grep:. -buffer-name=search-buffer<CR><C-R><C-W>
" Re-open the search result
nnoremap <silent> ,r :<C-u>UniteResume search-buffer<CR>
" Use ag(The Silver Searcher) if exists
if executable('ag')
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts = '--nogroup --nocolor --column'
  let g:unite_source_grep_recursive_opt = '--nogroup --nocolor --column'
endif

"--------------------------------------------
" ghcmod-vim configuration
" -------------------------------------------
command T GhcModType 

"-----------------------------------------------
" Configuration of easymotion
"-----------------------------------------------
map <Leader> <Plug>(easymotino-prefix)
nmap s <Plug>(easymotion-s2)

"-----------------------------------------------
" Configuration of ctrlp
"-----------------------------------------------
if executable('ag')
  let g:ctrlp_use_caching = 0
  let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup -g ""'
endif

"--------------------------------------------
" Configuration of neosnippet
" -------------------------------------------
" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"

" For conceal markers.
if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

"--------------------------------------------
" Configuration of quickrun
" -------------------------------------------
let g:quickrun_config = {}
let g:quickrun_config['sql'] = {
	\ 'command': 'psql',
	\ 'exec': ['%c %o < %s'],
	\ 'cmdopt': '%{MakepgsqlCommandOptions()}',
	\ }

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

"--------------------------------------------
" Configuration of incsearch
" -------------------------------------------
map m/ <Plug>(incsearch-migemo-/)
map m? <Plug>(incsearch-migemo-?)
map mg/ <Plug>(incsearch-migemo-stay)

" -------------------------------------------
" 文字コードの自動認識
" -------------------------------------------
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがeucJP-msに対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  " iconvがJISX0213に対応しているかをチェック
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  " 定数を処分
  unlet s:enc_euc
  unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" 改行コードの自動認識
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif

" original http://stackoverflow.com/questions/12374200/using-uncrustify-with-vim/15513829#15513829
function! Preserve(command)
  " Save the last search.
  let search = @/
  " Save the current cursor position.
  let cursor_position = getpos('.')
  " Save the current window position.
  normal! H
  let window_position = getpos('.')
  call setpos('.', cursor_position)
  " Execute the command.
  execute a:command
  " Restore the last search.
  let @/ = search
  " Restore the previous window position.
  call setpos('.', window_position)
  normal! zt
  " Restore the previous cursor position.
  call setpos('.', cursor_position)
endfunction

function! Autopep8()
  call Preserve(':silent %!autopep8 -')
endfunction


"" autocmd
" Shift + F で自動修正
autocmd FileType python nnoremap <S-f> :call Autopep8()<CR>
" vim起動時にファイル指定しなければVimFilerを開く
autocmd VimEnter * if !argc() | VimFiler | endif
