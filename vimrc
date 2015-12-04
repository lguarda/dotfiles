
if has('vim')
set encoding=utf-8
endif
set fileencoding=utf-8

try
call plug#begin('~/.vim/plugged')

Plug 'https://github.com/kien/ctrlp.vim'
Plug 'https://github.com/scrooloose/syntastic'
Plug 'https://github.com/morhetz/gruvbox'
Plug 'https://github.com/scrooloose/nerdtree'
Plug 'https://github.com/bling/vim-airline'
Plug 'https://github.com/luochen1990/rainbow'

if has('nvim')
Plug 'https://github.com/critiqjo/lldb.nvim'
endif

call plug#end()
catch
endtry

let g:syntastic_cpp_compiler = 'c++'
let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++ -Wall -Werror -Wextra'
let g:syntastic_cpp_include_dirs = ['../../../include', '../../include','../include','./include']

let g:syntastic_c_compiler = 'gcc'
let g:syntastic_c_compiler_options = ' -Wall -Werror -Wextra'
let g:syntastic_c_include_dirs = ['../../../include', '../../include','../include','./include']

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
set wildmode=longest:full,full
set autochdir
set nowrap									" dont warp long line
set virtualedit=onemore
hi Folded ctermbg=16

let mapleader = ","
let g:mapleader = ","

nmap <leader>t :term<cr>
inoremap {<CR>	{}<Left><cr><cr><up><tab>
inoremap {}     {}<Left>
inoremap ''     ''<Left>
inoremap ""     ""<Left>
inoremap ()     ()<Left>
inoremap <C-a>	<Esc><S-i>
inoremap <C-e>	<Esc><S-a>
	
noremap <C-a>			0
noremap <C-e>			g$
noremap <Space><Space>		:tabedit ~/.vimrc<CR>

noremap <S-e>				b
noremap <Space><Space>		:tabedit ~/.vimrc<CR>
noremap <S-Tab>				:tabprevious<CR>
noremap <Tab>				:tabnext<CR>

noremap <C-g>				:NERDTreeToggle<CR>
noremap <S-z>				:set fdm=syntax<CR>zR
nnoremap <space>			:nohlsearch<CR>

vnoremap <Tab>				>
vnoremap <S-Tab>			<

noremap <S-Right>			<C-w><Right>
noremap <S-Left>			<C-w><Left>
noremap <S-Up>				<C-w><Up>
noremap <S-Down>			<C-w><Down>

inoremap <C-u>				<Esc><C-r>
noremap <C-u>				<C-r>

noremap <silent>			<C-s>	:w!<CR>
noremap <silent>			<C-s>	:q<CR>

if has('nvim')
	tnoremap <S-Up> <C-\><C-n><S-w>Up
	tnoremap <S-Down> <C-\><C-n><S-w>Down
	tnoremap <S-Left> <C-\><C-n><S-w>Left
	tnoremap <S-Right> <C-\><C-n><S-w>Right
endif
