set nocompatible
if !has('mac')
  source $VIMRUNTIME/vimrc_example.vim
  source $VIMRUNTIME/ftplugin/xml-sql_fold.vim
endif
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

let mapleader="\<Space>"

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
if has('mac')
  set guifont=Ricty:h16
endif
set wrap
set wildmenu
set tabstop=4
set list lcs=tab:>-
set clipboard=unnamed,autoselect
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
" vimfilerでのファイル操作有効化
set modifiable
set write
set backspace=indent,eol,start

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

if &compatible
  set nocompatible
endif

filetype plugin indent off

let s:dein_dir = expand('~/.vim/dein')
let s:dein_repo_dir = s:dein_dir . 'repos/github.com/Shougo/dein.vim'

if !isdirectory(s:dein_repo_dir)
  execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
endif
execute 'set runtimepath^=' . s:dein_repo_dir

let g:dein#install_progress_type = 'title'
let g:dein#install_message_type = 'none'
let g:dein#enable_notification = 1

let s:dein_path = expand('~/.vim/dein')
if dein#load_state(s:dein_path)

  call dein#begin(s:dein_path, split(glob('~/.vim/rc/*.toml'), '\n'))

  call dein#load_toml('~/.vim/rc/dein.toml', {'lazy': 0})
  call dein#load_toml('~/.vim/rc/dein_lazy.toml', {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

if dein#check_install(['vimproc'])
  call dein#install(['vimproc'])
endif

if dein#check_install()
  " Installation check.
  call dein#install()
endif

filetype plugin indent on

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

"--------------------------------------------
" Configuration of vim-markdown, previm, open-browser
" -------------------------------------------
au BufRead,BufNewFile *.md set filetype=markdown
let g:previm_open_cmd = 'google-chrome'

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
