try
	call plug#begin('~/.vim/plugged')
	Plug 'https://github.com/scrooloose/syntastic'
	Plug 'https://github.com/morhetz/gruvbox'
	Plug 'https://github.com/scrooloose/nerdtree'
	Plug 'https://github.com/chriskempson/base16-vim'
	Plug 'https://github.com/mhartington/oceanic-next'
	Plug 'https://github.com/bling/vim-airline'
	Plug 'https://github.com/luochen1990/rainbow'
	Plug 'https://github.com/itchyny/vim-cursorword'
	Plug 'https://github.com/octol/vim-cpp-enhanced-highlight'
	Plug 'https://github.com/will133/vim-dirdiff'
	Plug 'https://github.com/vim-scripts/a.vim'
	Plug 'https://github.com/tpope/vim-fugitive'
	Plug 'https://github.com/mbbill/undotree'
	Plug 'https://github.com/ryanoasis/vim-devicons'
	"Plug 'https://github.com/vim-scripts/vim-pad'
	Plug 'https://github.com/godlygeek/tabular'
	Plug 'https://github.com/vim-scripts/mru.vim'
	Plug 'https://github.com/easymotion/vim-easymotion'
    Plug 'https://github.com/matze/vim-move'
    Plug 'https://github.com/kana/vim-textobj-user'
    Plug 'https://github.com/kana/vim-textobj-function'
    Plug 'https://github.com/rhysd/vim-textobj-anyblock' 
    Plug 'https://github.com/AndrewRadev/switch.vim'
    Plug 'https://github.com/terryma/vim-multiple-cursors'

	if has('nvim')
		Plug 'https://github.com/critiqjo/lldb.nvim'
	endif

	call plug#end()
catch
endtry
let g:airline#extensions#hunks#enabled=0
let g:airline#extensions#branch#enabled=1
let g:airline_powerline_fonts = 1

let g:syntastic_cpp_compiler = 'g++'
let g:syntastic_cpp_compiler_options = ' -std=c++03 -stdlib=libc++ -Wall -Werror -Wextra'
let g:syntastic_cpp_include_dirs = ['../../../include', '../../include','../include','./include']

let g:syntastic_c_compiler = 'gcc'
let g:syntastic_c_compiler_options = ' -Wall -Werror -Wextra'
let g:syntastic_c_include_dirs = ['../../../include', '../../include','../include','./include']

let g:switch_mapping = '>'
let g:switch_reverse_mapping = '<'
let g:switch_custom_definitions = [
      \   ['--', '++']
      \ ]
let g:cpp_class_scope_highlight = 1

let g:NERDTreeDirArrows=0
syntax on
try
	colorscheme gruvbox
catch
endtry
set background=dark

set number									" display line number
set cc=80									" display column layout
set tabstop=4								" redifine tab display as n space
set t_Co=256								" change nubmer of term color
set cursorline								" hightlight current line
set shiftwidth=4
set expandtab
set autoindent
set smartindent
set whichwrap+=<,>,h,l,[,]					" warp cusrsor when reache end and begin of line
set list listchars=tab:»·,trail:·,eol:¶		" highlight tab space en eol
set foldnestmax=1							" allow 0 nested fold
set noswapfile
set autoread								" change file when editing from the outside
set hlsearch								" highligth search
set ic										" case insensitive
set laststatus=2							" alway show status line
set wildmenu								" pop menu when autocomplete command
set wildmode=longest:full,full				" widlmenu option
set autochdir								" auto change directories of file
set nowrap									" dont warp long line
set virtualedit=onemore
set timeoutlen=400							" delay of key combinations ms
set updatetime=500
set matchpairs=(:),[:],{:},<:>
set lazyredraw          " redraw only when we need to.
set incsearch           "search as characters are entered
set undodir=/tmp
set undofile
hi Folded ctermbg=16

let mapleader = ","
let g:mapleader = ","
nnoremap t <C-]>
nnoremap <S-t> <C-t>
nmap <leader>t :term<cr>
inoremap {<CR>	{}<Left><cr><cr><up><tab>
inoremap {}	{}<Left>
inoremap {};	{};<Left><Left><cr><cr><up><tab>
inoremap {}<CR>	{}<Left><cr><cr><up><tab>
inoremap ''	''<Left>
inoremap ""	""<Left>
inoremap ()	()<Left>
inoremap []	[]<Left>
inoremap <>	<><Left>
inoremap <C-a>	<Esc><S-i>
inoremap <C-e>	<Esc><S-a>
inoremap <M-left>	20z<left>
inoremap <C-e>	<Esc><S-a>
inoremap hh <C-o>:stopinsert<CR>:echo<CR>

cnoremap hh <Esc>
noremap <C-f>   /
noremap ;     :
noremap <M-left>	20z<left>
noremap <M-right>	20z<right>
noremap <leader>k  :m--<CR>
noremap <leader>j  :m+<CR>

noremap <C-A>			gI
noremap <C-a>			0i
noremap <C-e>			$a
noremap <Space><Space>		:tabedit ~/.vimrc<CR>

noremap <S-e>				b
noremap <Space><Space>		:tabedit ~/.vimrc<CR>
nnoremap <S-Tab>				:tabprevious<CR>
nnoremap <Tab>				:tabnext<CR>

noremap <M-r>               :RainbowToggle<CR>
noremap <C-g>				:NERDTreeToggle<CR>
noremap <C-b>				:UndotreeToggle<CR>:UndotreeFocus<CR>
noremap <S-z>				:set fdm=syntax<CR>zR
nnoremap <space>			:nohlsearch<CR>

noremap <S-right> :vertical resize +5<CR>
noremap <S-left> :vertical resize -5<CR>
noremap <S-up> 5<C-w>+
noremap <S-down> 5<C-w>-

vnoremap <Tab>				>
vnoremap <S-Tab>			<

inoremap <C-k>	<Up>
inoremap <C-j>	<Down>
inoremap <C-h>	<Left>
inoremap <C-l>	<Right>

noremap <S-k>				<C-w><Up>
noremap <S-j>				<C-w><Down>
noremap <S-h>				<C-w><Left>
noremap <S-l>				<C-w><Right>

cnoremap <C-h>	<Left>
cnoremap <C-l>	<Right>
cnoremap <C-j>	<Down>
cnoremap <C-k>	<Up>

inoremap <C-u>				<Esc><C-r>
noremap <C-u>				<C-r>

inoremap <C-s>        <Esc>:w<CR><insert><Right>
noremap <silent>			<C-s>	:w<CR>
noremap <silent>			<C-q>	:q<CR>
noremap <C-x><C-w>        :execute ToggleLineWrap()<CR>''
noremap <C-x><C-r>        :so $MYVIMRC<CR>

noremap <C-x><S-s>  :w !sudo tee %<CR>L<CR>
noremap <C-j>       <S-j>
noremap <C-l>       <S-l>
noremap <C-h>       <S-h>

"==========system ClipBoard access
vnoremap <M-c> "+2yy
vnoremap <M-x> "+dd 
noremap <M-v> "+P
inoremap <M-v> <C-o>"+P
"==========

set pastetoggle=<F2>
map! <F3> <C-R>=strftime('%c')<CR>
autocmd FileType cpp map! <F4> std::cout << __func__<< " line:" << __LINE__ << std::endl;
autocmd FileType cpp map! <F5> std::cout << __func__<< " msg:" <<  << std::endl;<Esc>13<Left><insert>""

autocmd FileType c map! <F4> printf( __func__" line:"__LINE__"\n");
autocmd FileType c map! <F5> printf(__func__" \n");<Esc>4<Left><insert>

autocmd FileType php map! <F5> print_r('');<Esc>3<Left><insert>
noremap <C-x>k  :topleft new<CR>:terminal<CR>
noremap <C-x>j  :botright new<CR>:terminal<CR>
noremap <C-x>h  :leftabove vnew<CR>:terminal<CR>
noremap <C-x>l  :rightbelow vnew<CR>:terminal<CR>
noremap <C-x><Tab>  :tabnew<CR>:terminal<CR>
noremap <C-x><C-b> :call ToggleBinaryMode()<CR>
noremap <C-x><C-q> :%s/cb2a/cup/gc
noremap + <C-a>
noremap - <C-x>
nnoremap <up> <C-y>
nnoremap <down> <C-e>
if has('nvim')
  autocmd BufEnter, term://* startinsert
  autocmd BufLeave, term://* stopinsert
  tnoremap <Esc> <C-\><C-n>
  tnoremap <C-x>k <C-\><C-n>:topleft new<CR>:terminal<CR>
  tnoremap <C-x>j <C-\><C-n>:botright new<CR>:terminal<CR>
  tnoremap <C-x>h <C-\><C-n>:leftabove vnew<CR>:terminal<CR>
  tnoremap <C-x>l <C-\><C-n>:rightbelow vnew<CR>:terminal<CR>
  tnoremap <C-x><Tab>  <C-\><C-n>:tabnew<CR>:terminal<CR>
  tnoremap <M-v> <Esc>"+p<insert>
  tnoremap ''	''<Left>
  tnoremap ""	""<Left>
  tnoremap ()	()<Left>
  tnoremap []	[]<Left>
  tnoremap <>	<><Left>
  tnoremap hh	<Esc>
endif
au BufEnter * if !exists('b:isWrap') | let b:isWrap = 1 | endif
function! ToggleLineWrap()
  if b:isWrap == 0
    set nowrap
    noremap <buffer> j j
    noremap <buffer> k k
    let b:isWrap = 1
    echo "Toggle wrap off"
  else
    setlocal wrap linebreak
    noremap <buffer> j gj
    noremap <buffer> k gk
    let b:isWrap = 0
    echo "Toggle wrap on"
  endif
endfunction

au BufEnter * if !exists('b:isBinary') | let b:isBinary = 0 | endif
function! ToggleBinaryMode()
    if b:isBinary == 0
        :%!xxd
        let b:isBinary = 1
    else
        :%!xxd -r
        let b:isBinary = 0
    endif
endfunction

au CursorMoved * call Anchor()
command! AnchorToggle call AnchorToggle()
function! AnchorToggle()
    if !exists("b:isAnchor")
        let b:isAnchor = 1
    endif
    if b:isAnchor == 1
        let b:isAnchor = 0
        exec "noremap j j"
        exec "noremap k k"
    else
        let b:isAnchor = 1
    endif
endfunction

function! Anchor()
    if !exists("b:isAnchor")
        let b:isAnchor = 1
    endif
    if b:isAnchor == 1
        if winline() < winheight(0) / 8
            exec "noremap <buffer> k k<C-y>"
        else
            exec "noremap <buffer> k k"
        endif
        if winline() > (winheight(0) - winheight(0) / 8)
            exec "noremap <buffer> j j<C-e>"
        else
            exec "noremap <buffer> j j"
        endif
    endif
endfunction

let g:EasyMotion_do_mapping = 0 " Disable default mappings
nmap f <Plug>(easymotion-sl)
nmap F <Plug>(easymotion-overwin-f2)
let g:EasyMotion_keys = 'alskjdhfwiueg'
let g:EasyMotion_do_shade = 1
map W <Plug>(easymotion-bd-w)
let g:EasyMotion_smartcase = 0
