call plug#begin('~/.vim/plugged')

Plug 'https://github.com/kien/ctrlp.vim'
Plug 'https://github.com/scrooloose/syntastic'
Plug 'https://github.com/morhetz/gruvbox'
Plug 'https://github.com/scrooloose/nerdtree'
Plug 'https://github.com/bling/vim-airline'

call plug#end()

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

set nu
set cc=80
set ts=4
set t_Co=256
set shiftwidth=4
set cursorline
set ai
set si
set whichwrap+=<,>,h,l,[,]
set list listchars=tab:»·,trail:·

set autoread
"set ruler

"set statusline=%F%m%r%h%w\ [format=%{&ff}]\[type=%Y]\[%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M:%S\")}"
set laststatus=2

let mapleader = ","
let g:mapleader = ","

inoremap {		{}
inoremap {<CR>	{<CR>}<Esc>O<Tab>
inoremap {{		{
inoremap {}		{}
inoremap (		()<Left>
inoremap ((		(

noremap <Space><Space>		:tabedit ~/.nvimrc<CR>
noremap <S-Tab>				:tabprevious<CR>
noremap <Tab>				:tabnext<CR>

vnoremap <Tab>				>
vnoremap <S-Tab>			<

noremap <S-Right>			<C-w><Right>
noremap <S-Left>			<C-w><Left>
noremap <S-Up>				<C-w><Up>
noremap <S-Down>			<C-w><Down>

inoremap <C-u>				<Esc><C-r>i
noremap <C-u>				<C-r>

noremap <silent>			<C-s>	:w!<CR>
noremap <silent>			<C-s>	:q<CR>

noremap <C-g>				:NERDTreeToggle<CR>

noremap <S-z>				:set foldmethod=syntax<CR>

set autochdir
