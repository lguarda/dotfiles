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
"}}}
"
"{{{ Leader Command
nnoremap <leader><Tab> :let @a = expand("%:p")<CR>:q<CR>:execute "tabedit " . @a<CR>
nnoremap <leader>d :w !diff % -<CR>
"}}}

" instantly select the first autocomplet choice
inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
   \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
