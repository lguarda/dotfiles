try
	call plug#begin('~/.vim/plugged')
	Plug 'https://github.com/kien/ctrlp.vim'
	Plug 'https://github.com/scrooloose/syntastic'
	Plug 'https://github.com/morhetz/gruvbox'
	Plug 'https://github.com/mtglsk/mushroom'
	Plug 'https://github.com/scrooloose/nerdtree'
	Plug 'https://github.com/bling/vim-airline'
	Plug 'https://github.com/luochen1990/rainbow'
	Plug 'https://github.com/itchyny/vim-cursorword'
	Plug 'https://github.com/octol/vim-cpp-enhanced-highlight'
	Plug 'https://github.com/will133/vim-dirdiff'
	Plug 'https://github.com/vim-scripts/a.vim'

	if has('nvim')
		Plug 'https://github.com/critiqjo/lldb.nvim'
	endif

	call plug#end()
catch
endtry

let g:syntastic_cpp_compiler = 'c++'
let g:syntastic_cpp_compiler_options = ' -std=c++03 -stdlib=libc++ -Wall -Werror -Wextra'
let g:syntastic_cpp_include_dirs = ['../../../include', '../../include','../include','./include']

let g:syntastic_c_compiler = 'gcc'
let g:syntastic_c_compiler_options = ' -Wall -Werror -Wextra'
let g:syntastic_c_include_dirs = ['../../../include', '../../include','../include','./include']

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:cpp_class_scope_highlight = 1

let g:colorScheme = ['gruvbox', 'mushroom']

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
"set expandtab
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

hi Folded ctermbg=16

let mapleader = ","
let g:mapleader = ","

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

noremap <C-f>   /
noremap ;     :
noremap gg=G		gg=G''
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
noremap <S-Tab>				:tabprevious<CR>
noremap <Tab>				:tabnext<CR>

noremap <C-g>				:NERDTreeToggle<CR>
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

noremap <silent>			<C-s>	:w!<CR>
noremap <silent>			<C-s>	:q<CR>

set pastetoggle=<F2>
map! <F3> <C-R>=strftime('%c')<CR>
autocmd FileType cpp map! <F4> std::cout << __func__<< " line:" << __LINE__ << std::endl;
autocmd FileType cpp map! <F5> std::cout << __func__<< " msg:" <<  << std::endl;<Esc>13<Left><insert>""

autocmd FileType c map! <F4> printf( __func__" line:"__LINE__"\n");
autocmd FileType c map! <F5> printf(__func__" \n");<Esc>4<Left><insert>
noremap <C-x>k  :topleft new<CR>:terminal<CR>
noremap <C-x>j  :botbelow new<CR>:terminal<CR>
noremap <C-x>h  :leftabove vnew<CR>:terminal<CR>
noremap <C-x>l  :rightbelow vnew<CR>:terminal<CR>
noremap <C-x><Tab>  :tabnew<CR>:terminal<CR>

if has('nvim')
  autocmd BufEnter, term://* startinsert
  autocmd BufLeave, term://* stopinsert
  tnoremap <Esc> <C-\><C-n>
  tnoremap <C-x>k <C-\><C-n>:topleft new<CR>:terminal<CR>
  tnoremap <C-x>j <C-\><C-n>:botbelow new<CR>:terminal<CR>
  tnoremap <C-x>h <C-\><C-n>:leftabove vnew<CR>:terminal<CR>
  tnoremap <C-x>l <C-\><C-n>:rightbelow vnew<CR>:terminal<CR>
  tnoremap <C-x><Tab>  <C-\><C-n>:tabnew<CR>:terminal<CR>
endif
