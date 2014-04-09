if has('vim_starting')
  set nocompatible               " Be iMproved
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#rc(expand('~/.vim/bundle/'))

NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'elzr/vim-json'
NeoBundle 'msanders/snipmate.vim'
NeoBundle 'Shougo/unite.vim'

let g:neocomplcache_enable_at_startup = 1
let g:zencoding_debug = 1
let g:user_zen_expandabbr_key = '<c-o>'
"---------------------------------------------------------------------------
" 文字コード改行コードに関する設定:
"
" 文字コードの自動認識
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

"---------------------------------------------------------------------------
" バックアップに関する設定:
"
" バックアップをとらない
set nobackup
" ファイルの上書きの前にバックアップを作る
" (ただし、backup がオンでない限り、バックアップは上書きに成功した後削除される)
set writebackup
" バックアップをとる場合
"set backup
" バックアップファイルを作るディレクトリ
"set backupdir=~/backup
" スワップファイルを作るディレクトリ
"set directory=~/swap


"---------------------------------------------------------------------------
" 検索の挙動に関する設定:
"
" 検索時に大文字小文字を無視 (noignorecase:無視しない)
set ignorecase
" 大文字小文字の両方が含まれている場合は大文字小文字を区別
set smartcase
" 検索時に最後まで行ったら最初に戻る
set wrapscan
" 検索文字ハイライト表示
set hlsearch
" ハイライトはEsc二回で削除
nmap <silent> <Esc><Esc> :nohlsearch<CR><Esc>

"---------------------------------------------------------------------------
" 編集に関する設定:
"
" ソフトタブを利用する
set expandtab
" タブの画面上での幅
set tabstop=4
" 自動挿入時のタブサイズ
set shiftwidth=4
" ソフトタブサイズ
set softtabstop=4
" 自動的にインデントする (noautoindent:インデントしない)
set noautoindent
" バックスペースでインデントや改行を削除できるようにする
" indent  : 行頭の空白
" eol     : 改行
" start   : 挿入モード開始位置より手前の文字
set backspace=indent,eol,start
"set backspace=2
" 括弧入力時に対応する括弧を表示 (noshowmatch:表示しない)
set showmatch
" コマンドライン補完するときに強化されたものを使う(参照 :help wildmenu)
set wildmenu
" いい感じに補完する
set wildmode=list:longest
" テキスト挿入中の自動折り返しを日本語に対応させる
set formatoptions+=mM

"---------------------------------------------------------------------------
" GUI固有ではない画面表示の設定:
"
" 色表示
syntax on
" ファイルタイプ別の表示
filetype on
" 行番号を表示 (nonumber:非表示)
set number
" ルーラーを表示 (noruler:非表示)
set ruler
" カーソル行を表示
set cursorline
" mode表示
set showmode
" タブや改行を表示 (nolist:非表示)
set list
" タブ、行末の可視化
set listchars=tab:>-,trail:-,extends:>,precedes:<
" 全角スペースを可視化
function! JISX0208SpaceHilight()
  syntax match JISX0208Space "　" display containedin=ALL
  highlight JISX0208Space term=underline ctermbg=Cyan guibg=Cyan
endf
augroup invisible
  autocmd! invisible
  autocmd BufNew,BufRead * call JISX0208SpaceHilight()
augroup END
" 長い行を折り返して表示 (nowrap:折り返さない)
set wrap
" 利用時のみタブを表示
set showtabline=1
" 常にステータス行を表示 (詳細は:he laststatus)
set laststatus=2
" コマンドラインの高さ (Windows用gvim使用時はgvimrcを編集すること)
set cmdheight=2
" コマンドをステータス行に表示
set showcmd
" タイトルを表示
set notitle
" ステータスライン
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P
" ステータスラインの色
highlight StatusLine term=NONE cterm=NONE ctermfg=black ctermbg=white
"---------------------------------------------------------------------------
"" その他:
"
" ビープ音を鳴らさない
set vb t_vb=
"" KAORIYA
command! -nargs=0 CdCurrent cd %:p:h
" expand path
cmap <c-x> <c-r>=expand('%:p:h')<cr>/
" expand file (not ext)
cmap <c-z> <c-r>=expand('%:p:r')<cr>
" ブラウジング
nn ,e :edit %:p:h<CR>
nn ,t :tabnew<CR>
nmap <silent> <C-E> :e %:p:h<CR>
nmap <silent> <C-T> :tabe %:p:h<CR>
" vimrc 読み直す or 編集する
if has("win32")
  let vimrc='$HOME/_vimrc'
else
  let vimrc='$HOME/.vimrc'
endif
nn ,u :source <C-R>=vimrc<CR><CR>
nn ,v :edit <C-R>=vimrc<CR><CR>
" 表示行単位で移動
nn j gj
nn k gk
" 括弧の自動補完
"ino { {}<LEFT>
"ino [ []<LEFT>
"ino ( ()<LEFT>
"ino " ""<LEFT>
"ino ' ''<LEFT>
vn { "zdi{<C-R>z}<ESC>
vn [ "zdi[<C-R>z]<ESC>
vn ( "zdi(<C-R>z)<ESC>
vn " "zdi"<C-R>z"<ESC>
vn ' "zdi'<C-R>z'<ESC>
"検索語が真ん中にくるように
nmap n nzz
nmap N Nzz
nmap * *zz
nmap # #zz
nmap g* g*zz
nmap g# g#zz
" コマンドラインモードでbash風に
cno <C-A> <Home>
cno <C-E> <End>
cno <Up> <PageUp>
cno <Down> <PageDown>

" OSのクリップボードを仕様する
set clipboard+=unnamed

" クリップボードコピヤン可能に
set clipboard=unnamed
" マウスの設定
set guioptions+=a
set mouse=a
set ttymouse=xterm2
" Tabで補完
"set wildchar=<TAB>

" 雑多
" 日付
" Example: 1997-01-21
iab Ymd <C-R>=strftime("%Y-%m-%d")<CR>
" Example: 970121
iab Ydate <C-R>=strftime("%y%m%d")<CR>
" Example: 14:28
iab Ytime <C-R>=strftime("%H:%M")<CR>
" Example: 1997-01-21 20:20:20
iab Yall   <C-R>=strftime("%y%m%d %X")<CR>
" 全角スペース
iab YSP 　
" ,cel = "clear empty lines"
map ,cel :%s/\s\+$//<CR>
" ,del = "delete 'empty' lines"
map ,del :g/^\s\+$/d
" ,cqel = "clear quoted empty lines"
nmap ,cqel :%s/^[>]\+$//
vmap ,cqel  :s/^[><C-I> ]\+$//
" ,ksr = "kill space runs"
nmap ,ksr :%s/  \+/ /g
vmap ,ksr  :s/  \+/ /g

"nmap <silent> <C-W> :tabc<CR>
nmap <silent> <F2> :tabpre<CR>
nmap <silent> <F3> :tabn<CR>
nmap <silent> <F4> :tabc<CR>
nmap <silent> <C-Tab> :tabn<CR>
imap <silent> <C-Tab> <ESC>:tabn<CR>
nmap <silent> <C-S-Tab> :tabpre<CR>
nmap <silent> gt :tabn<CR>
nmap <silent> gT :tabpre<CR>
" バッファ 前 次 削除
"map <F2> <ESC>:bp<CR>
"map <F3> <ESC>:bn<CR>
"map <F4> <ESC>:bw<CR>

" TwitVim plugin settings
let twitvim_enable_perl = 1

" omnifunc
ino <C-F> <C-X><C-O>

" php settings
au FileType php set ts=4 sw=4 sts=4 noexpandtab
au FileType php set omnifunc=phpcomplete#CompletePHP
au BufRead,BufNewFile *.tpl setfiletype php
au BufRead,BufNewFile *.inc setfiletype php
"let php_folding=1
let php_sql_query=1
let php_htmlInStrings=1
let php_noShortTags = 1
" 実行 <C-X>
function! PHPExec()
  let result = system( &ft . ' ' . bufname(""))
  echo result
endfunction
au FileType php :nn <C-X> <ESC>:call PHPExec()<CR>
" 構文チェック <C-C>
function! PHPLint()
  let result = system( &ft . ' -l ' . bufname(""))
  echo result
endfunction
au FileType php :nn <C-C> <ESC>:call PHPLint()<CR>
" srround.vim settings
au FileType php let g:surround_45 = "<?php echo \r ?>" "ascii:45 -
au FileType php let g:surround_101 = "<?php echo \r ?>" "ascii:45 e
au FileType php let g:surround_94 = "<?php echo link_to('\r') ?>" "ascii:115 l
"iab lt <C-R>="<?php echo link_to(, ) ?>"<CR>
" plugin php-doc.vim settings
if filereadable('$HOME/.vim/php-doc.vim')
  so $HOME/.vim/php-doc.vim
  ino <C-P> <ESC>:call PhpDocSingle()<CR>
  nn <C-P> :call PhpDocSingle()<CR>
  vn <C-P> :call PhpDocRange()<CR>
  let g:pdv_cfg_Uses = 1
  let g:pdv_cfg_Type = "string"
  let g:pdv_cfg_Package = ""
  let g:pdv_cfg_Version = "$id$"
  let g:pdv_cfg_Author = ''
  let g:pdv_cfg_Copyright = "Copyright (C) 2010 cheki.net All Rights Reserved."
"let g:pdv_cfg_License = "http://www.opensource.org/licenses/mit-license.php The MIT Licence"
endif
" plugin symfony.vim settings
silent map <F8> :SfSwitchView <CR>

" ruby settings
au FileType ruby set ts=2 sw=2 sts=2 expandtab
au FileType ruby,eruby set omnifunc=rubycomplete#Complete
" 実行 <C-X>
function! RubyExec()
  let result = system( &ft . ' ' . bufname(""))
  echo result
endfunction
au FileType ruby :nn <C-X> <ESC>:call RubyExec()<CR>
" 構文チェック <C-C>
function! RubyLint()
  let result = system( &ft . ' -c ' . bufname(""))
  echo result
endfunction
au FileType ruby :nn <C-C> <ESC>:call RubyLint()<CR>

" perl settings
au FileType perl set ts=2 sw=2 sts=2 expandtab
" 実行 <C-X>
function! PerlExec()
  let result = system( &ft . ' ' . bufname(""))
  echo result
endfunction
au FileType perl :nn <C-X> <ESC>:call PerlExec()<CR>
" 構文チェック <C-C>
function! PerlLint()
  let result = system( &ft . ' -c ' . bufname(""))
  echo result
endfunction
au FileType perl :nn <C-C> <ESC>:call PerlLint()<CR>

" javascript settings
au Syntax javascript set ts=2 st=2 sts=2
au FileType javascript set omnifunc=javascriptcomplete#CompleteJS
au BufRead,BufNewFile *.json setfiletype javascript
" 構文チェック <C-C>
function! JavascriptLint()
  let result = system('gjslint ' . bufname(""))
  echo result
endfunction
au FileType javascript :nn <C-C> <ESC>:call JavascriptLint()<CR>

" vim settings
au Syntax vim set ts=2 st=2 sts=2

" yaml settings
au Syntax yaml set ts=2 st=2 sts=2

" python settings
au Syntax python set ts=2 st=2 sts=2
au FileType python set omnifunc=pythoncomplete#Complete
" 実行 <C-X>
function! PythonExec()
  let result = system(&ft . ' ' . bufname(""))
  echo result
endfunction
au FileType python :nn <C-X> <ESC>:call PythonExec()<CR>

" html settings
au Syntax html,xhtml set ts=2 st=2 sts=2
au FileType html set omnifunc=htmlcomplete#CompleteTags
au FileType html let b:surround_49  = "<h1>\r</h1>" " 1
au FileType html let b:surround_50  = "<h2>\r</h2>" " 2
au FileType html let b:surround_51  = "<h3>\r</h3>" " 3
au FileType html let b:surround_52  = "<h4>\r</h4>" " 4
au FileType html let b:surround_53  = "<h5>\r</h5>" " 5
au FileType html let b:surround_54  = "<h6>\r</h6>" " 6
au FileType html let b:surround_112 = "<p>\r</p>"   " p
au FileType html let b:surround_117 = "<ul>\r</ul>" " u
au FileType html let b:surround_111 = "<ol>\r</ol>" " o
au FileType html let b:surround_108 = "<li>\r</li>" " l
au FileType html let b:surround_97  = "<a href=\"\">\r</a>" " a
au FileType html let b:surround_65  = "<a href=\"\r\"></a>" " A
au FileType html let b:surround_105 = "<img src=\"\r\" alt=\"\" />" " i
au FileType html let b:surround_73  = "<img src=\"\" alt=\"\r\" />" " I
au FileType html let b:surround_100 = "<div>\r</div>" " d
au FileType html let b:surround_68  = "<div class=\"section\">\r</div>" " D

" xml settings
au FileType xml set omnifunc=xmlcomplete#CompleteTags

" css settings
au FileType css set omnifunc=csscomplete#CompleteCSS

command! -nargs=? Jq call s:Jq(<f-args>)
function! s:Jq(...)
  if 0 == a:0
    let l:arg = "."
  else
    let l:arg = a:1
  endif
  execute "%! jq \"" . l:arg . "\""
endfunction

filetype plugin indent on
NeoBundleCheck
