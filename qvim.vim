let mapleader = "\<Space>"
let g:mapleader = "\<Space>"

"{{{ Basic Settings
set noeol
set background=dark
set nocompatible                            " vi legacy
set hidden
set showtabline=1                           " enable tabline
set noshowmode                              " disable --[mode]-- in cmd line
set number                                  " display line number
set numberwidth=1                           " minimum number column size
"set colorcolumn=80                          " display column layout
set tabstop=4                               " redifine tab display as n space
set t_Co=256                                " change nubmer of term color
set cursorline                              " hightlight current line
set shiftwidth=4
set expandtab                               " use muliple space instead of tab
set autoindent
set smartindent
set whichwrap+=<,>,h,l,[,]                  " warp cusrsor when reache end and begin of line
set list listchars=tab:>\ ,trail:_,extends:$,precedes:$",eol:ÃÂ¶  " highlight tab space en eol
set foldnestmax=1                           " allow 0 nested fold
set foldcolumn=0                            " hide fold column
set noswapfile                              " do not use ~swapfile
set autoread                                " change file when editing from the outside
set hlsearch                                " highligth search
set ignorecase                              " case insensitive
set smartcase                               " Override the 'ignorecase' option if the search pattern contains upper case characters
set laststatus=2                            " alway show status line
set wildmenu                                " pop menu when autocomplete command
set wildmode=longest:full,full              " widlmenu option
set autochdir                               " auto change directories of file
set nowrap                                  " dont warp long line
set linebreak                               " break at a word boundary
set virtualedit=onemore                     " allow normal mode to go one more charater at the end
set timeoutlen=400                          " delay of key combinations ms
set updatetime=250
set matchpairs=(:),[:],{:},<:>              " hl pairs and jump with %
set lazyredraw                              " redraw only when we need to.
set incsearch                               " While typing a search command, show where the pattern is
set undofile                                " use undofile
set undodir=/tmp                            " undofile location
set fillchars="" "vert:'|'                  " use pipe as split character
set pastetoggle=<F2>                        " toggle paste mode vi legacy
set notagbsearch                            " disable the error E432 see :h E432
set completeopt=menuone,menu,longest,preview
set cmdheight=1
set mouse=a
set display+=uhex
"}}} Basic Settings

"{{{ Pair characters change
inoremap {<CR>  {}<Left><cr><cr><up><tab>
inoremap {} {}<Left>
inoremap {};    {};<Left><Left><cr><cr><up><tab>
inoremap {}<CR> {}<Left><cr><cr><up><tab>
inoremap '' ''<Left>
inoremap "" ""<Left>
inoremap () ()<Left>
inoremap [] []<Left>
inoremap <> <><Left>
"}}}

"{{{ Comfort remap
nnoremap Q q
nnoremap <silent> x "_x
nnoremap <silent> <S-x> "_<S-x>
nnoremap <silent> <C-t> :let @3=@"<CR>xlP:let@"=@3<CR>
nnoremap ; :
nnoremap <space><space> :tabedit $MYVIMRC<CR>
nnoremap <S-Tab> :tabprevious<CR>
nnoremap <Tab> :tabnext<CR>
" Incremente or decrement indentation
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv
inoremap <C-u> <Esc><C-r>
noremap <C-u> <C-r>
inoremap <C-s> <Esc>:w<CR><insert><Right>
nnoremap <silent> <C-s>   :w<CR>
nnoremap <silent> <C-q>   :q<CR>
nnoremap <C-j> <S-j>
nnoremap <C-l> <S-l>
nnoremap <C-h> <S-h>
nnoremap <M-t> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
nnoremap <S-t> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
noremap + <C-a>
noremap - <C-x>
nnoremap <up> <C-y>
nnoremap <down> <C-e>
nnoremap <S-k> <PageUp>
nnoremap <S-j> <PageDown>
"}}} Comfort remap

"{{{ Resize Pane
noremap <S-right> :vertical resize +5<CR>
noremap <S-left> :vertical resize -5<CR>
noremap <S-up> 5<C-w>+
noremap <S-down> 5<C-w>-
"}}}

"{{{ Basic Move Modif
inoremap <C-a> <Esc><S-i>
inoremap <C-e> <Esc><S-a>
inoremap <C-e> <Esc><S-a>
nnoremap <C-a> 0
nnoremap <C-e> $<right>
vnoremap <C-a> ^
vnoremap <C-e> $
inoremap <C-k> <Up>
inoremap <C-j> <Down>
inoremap <C-h> <Left>
inoremap <C-l> <Right>
cnoremap <C-h> <Left>
cnoremap <C-l> <Right>
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>
nnoremap <S-h> <C-w><Left>
nnoremap <S-l> <C-w><Right>
nnoremap <M-h> b
nnoremap <M-l> w
nnoremap n nzz
nnoremap N Nzz
"}}} Basic Move Modif
"
inoremap hh <C-o>:stopinsert<CR>:echo<CR>
inoremap jk <C-o>:stopinsert<CR>:echo<CR>
inoremap qq <C-o>:stopinsert<CR>:echo<CR>
cnoremap jk <Esc>
cnoremap qq <Esc>
cnoremap hh <Esc>
vnoremap qq <Esc>
cnoremap qq <Esc>
nnoremap qq <Esc>

vnoremap <S-k> :m '<-2<CR>gv=gv
vnoremap <S-j> :m '>+1<CR>gv=gv
nnoremap <C-x><C-v> "+P

vnoremap <C-x><C-c> "+2yy
nnoremap <C-x><C-v> "+P

"{{{ Search and Replace
" Delete Extra white sapce from selection
vnoremap <Space> :s/\s\+$//<CR>
" Replace selection by last yank and keep previous yank
vnoremap P <esc>:let @a = @"<cr>gvd"aP
" Yank selection and replace it by previous yank
vnoremap p "_dP
" Replace all selection
vnoremap <C-r> "hy<ESC>:%s/<C-r>h/<C-r>h/gc<left><left><left>
" Replace all selection by last yank
vnoremap <S-r> "hy<ESC>:%s/<C-r>h/<C-r>0/gc<left><left><left>
nnoremap <space> :nohlsearch<CR>
nnoremap <c-r> yiw:%s/\<"\>/"/gc<left><left><left>
cnoremap <C-r><C-r> <CR>:%s/<C-R>/
vnoremap /  "ay:let @a = "/" . @a<CR>@a<CR>
"}}}
"
"{{{ Leader Command
nnoremap <leader><Tab> :let @a = expand("%:p")<CR>:q<CR>:execute "tabedit " . @a<CR>
nnoremap <leader>d :w !diff % -<CR>
nnoremap <leader>w :set wrap!<CR>
nnoremap <leader>r :so $MYVIMRC<CR>:nohlsearch<CR>
nnoremap <leader>b :call ToggleBinaryMode()<CR>
"}}}
" instantly select the first autocomplet choice
inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
   \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

"{{{ C function argument switcher
nnoremap <leader>1 :call Switch_arg(1)<CR>@a
nnoremap <leader>2  :call Switch_arg(2)<CR>@a
nnoremap <leader>3  :call Switch_arg(3)<CR>@a
nnoremap <leader>4  :call Switch_arg(4)<CR>@a
nnoremap <leader>5  :call Switch_arg(5)<CR>@a
nnoremap <leader>6  :call Switch_arg(6)<CR>@a
nnoremap <leader>7  :call Switch_arg(7)<CR>@a
"}}} C function argument switcher

"{{{ Autocmd
autocmd BufEnter * set autochdir
autocmd StdinReadPre * let s:std_in=1
autocmd BufEnter * if !exists('b:isBinary') | let b:isBinary = 0 | endif
autocmd BufEnter * silent! execute "normal! :setlocal scrolloff=" . winheight(0) / 5 . "\r"
autocmd FileType cpp map! <F4> std::cout << __func__<< " line:" << __LINE__ << std::endl;
autocmd FileType cpp map! <F5> std::cout << __func__<< " msg:" <<  << std::endl;<Esc>13<Left><insert>""
autocmd FileType cpp inoremap <buffer> \n  <space><< std::endl;
autocmd FileType c map! <F4> printf( __func__" line:"__LINE__"\n");
autocmd FileType c map! <F5> printf(__func__" \n");<Esc>4<Left><insert>
autocmd FileType php map! <F4> print_r("file: ".__FILE__."line: ".__LINE__);
autocmd FileType php map! <F5> print_r("file: ".__FILE__."line: ".__LINE__.''<Right>);<Esc>2<Left><insert>
autocmd FileType vim set fdm=marker
autocmd BufRead,BufNewFile *.conf setfiletype dosini

highlight ExtraCarriageReturn ctermbg=red gui=bold,undercurl guifg=#ababcc "guibg=#000000
highlight ExtraWhitespace ctermbg=red gui=bold,undercurl guifg=#ab4444 "guibg=#000000
highlight ExtraSpaceDwich ctermbg=red gui=bold,undercurl guifg=#ab4444 "guibg=#000000
augroup WhitespaceMatch
  " Remove ALL autocommands for the WhitespaceMatch group.
  autocmd!
  autocmd BufWinEnter * let w:whitespace_match_number =
        \ matchadd('ExtraWhitespace', '\s\+$')
  autocmd BufWinEnter * let w:spacedwich_match_number =
        \ matchadd('ExtraSpaceDwich', ' \t\|\t ')
  autocmd BufWinEnter * let w:CRLF =
        \ matchadd('ExtraCarriageReturn', '\r')
augroup END
"}}}

"{{{ Function
function! ToggleBinaryMode()
	if b:isBinary == 0
		:%!xxd
		let b:isBinary = 1
	else
		:%!xxd -r
		let b:isBinary = 0
	endif
endfunction

command! Ifndef call Insert_ifndef()

function! Insert_ifndef()
	let l:filename = substitute(toupper(expand("%:t")), "\\.", "_", "g")
    0put = '#ifndef ' . l:filename
    1put = '# define ' . l:filename
    2put = ''
    $put = '#endif /* ' . l:filename . ' */'
endfunction

function! Switch_arg(nb)
	let l:c = 1
	let l:str = ":s/(\\(.*\\)"

	while l:c < a:nb
		let l:str = join([l:str, ",\\s*\\(.*\\)"], "")
		let l:c += 1
	endwhile
	let l:str = join([l:str, ")"], "")
	let l:c = 1
	let l:str = join([l:str, "/(\\1"], "")
	while l:c < a:nb
		let l:str = join([l:str, ", \\", l:c+1], "")
		let l:c += 1
	endwhile
	"kl -> left key obtained from pasted macro
	let l:str = join([l:str, ")/g|:nohlsearch"], "")
	let @a = l:str
endfunction

highlight currawong ctermbg=darkred guibg=darkred

command! JsonIndent call JsonIndent()
function! JsonIndent()
	execute '%!python -m json.tool'
endfunction

function! DoPrettyXML()
	let l:origft = &ft
	set ft=
	1s/<?xml .*?>//e
	0put ='<PrettyXML>'
	$put ='</PrettyXML>'
	silent %!xmllint --format -
	2d
	$d
	silent %<
	1
	exe "set ft=" . l:origft
endfunction
command! PrettyXML call DoPrettyXML()

function! IsMac()
   if has("unix")
      let s:uname = system("uname")
      if s:uname == "Darwin\n"
         return 1
      endif
      return 0
   endif
endfunction

function! GetExplorer()
   if executable('nautilus')
      return 'nautilus'
   elseif executable('dolfin')
      return 'dolphin'
   elseif executable('thunar')
      return 'thunar'
   elseif IsMac()
      return 'open'
   elseif has("win32")
      return 'start'
   endif
   return 'none'
endfunction

function! OpenExplorer()
   let l:open = GetExplorer()
   if l:open != 'none'
      execute "!". l:open . " ."
   else
      echomsg "/!\\ No Explorer Provided /!\\"
   endif
endfunction
"}}}
