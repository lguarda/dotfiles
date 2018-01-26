"{{{ Var
let g:mod = []
let mapleader = "\<Space>"
let g:mapleader = "\<Space>"
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
"}}}

"{{{ Plugin
let g:plug_window = "rightbelow new"
try
	if has("win32")
	call plug#begin('~/vimfiles/bundle')
	else
	call plug#begin('~/.vim/plugged')
	endif

	"{{{ Color Scheme
	Plug 'https://github.com/morhetz/gruvbox'
	Plug 'https://github.com/mhartington/oceanic-next'
	Plug 'https://github.com/KeitaNakamura/neodark.vim'
	Plug 'https://github.com/KKPMW/moonshine-vim'
	Plug 'https://github.com/dracula/vim'
	"}}}

	"Plug 'https://github.com/itchyny/vim-cursorword'
	Plug 'https://github.com/will133/vim-dirdiff'
	Plug 'https://github.com/tpope/vim-fugitive'
	Plug 'https://github.com/godlygeek/tabular'
	Plug 'https://github.com/kana/vim-textobj-user'
	Plug 'https://github.com/kana/vim-textobj-function'
	Plug 'https://github.com/rhysd/vim-textobj-anyblock'
	Plug 'https://github.com/sgur/vim-textobj-parameter'
	Plug 'https://github.com/terryma/vim-multiple-cursors'
	Plug 'https://github.com/justinmk/vim-syntax-extra'
	Plug 'https://github.com/elzr/vim-json'
	Plug 'https://github.com/kshenoy/vim-signature'
	"Plug 'https://github.com/lilydjwg/colorizer'
	Plug 'https://github.com/google/vim-searchindex'
	Plug 'https://github.com/mhinz/vim-signify'
	Plug 'https://github.com/vim-scripts/vis'
	"Plug 'https://github.com/w0rp/ale'
	Plug 'https://github.com/vim-scripts/a.vim'
	"{{{
		let g:alternateSearchPath = 'sfr:../source,sfr:../src,sfr:../Src,sfr:../include,sfr:../inc,sfr:../Inc'
	"}}}

	Plug 'https://github.com/majutsushi/tagbar'
	"{{{
		nnoremap <leader>t :TagbarToggle<CR>
	"}}}

	Plug 'https://github.com/yegappan/mru'
	"{{{
		nnoremap <leader>m :MRU<CR>
	"}}}

	Plug 'https://github.com/vimwiki/vimwiki'
	"{{{
	autocmd BufWrite *.wiki :execute "normal \<Plug>Vimwiki2HTML"
	autocmd BufEnter *.wiki :nmap <Leader>wh <Plug>Vimwiki2HTMLBrowse
	let g:vimwiki_list_ignore_newline=0
	let wiki = {}
	let wiki.path = '~/vimwiki/'
	let wiki.nested_syntaxes = {'python': 'python', 'c++': 'cpp', 'js' : 'javascript'}
	let g:vimwiki_list = [wiki]
	"}}}

	Plug 'https://github.com/chrisbra/NrrwRgn'
	"{{{
	let g:nrrw_rgn_vert = 1
	let g:nrrw_rgn_resize_window = 'column'
	vnoremap n     :NR<CR>
	"}}}

	Plug 'https://github.com/mbbill/undotree'
	"{{{
	noremap <C-b>               :UndotreeToggle<CR>
	let g:undotree_SetFocusWhenToggle=1
	let g:undotree_WindowLayout=4
	"}}}

	Plug 'https://github.com/easymotion/vim-easymotion'
	"{{{
	let g:EasyMotion_do_mapping = 0 " Disable default mappings
	nmap f <Plug>(easymotion-sl)
	nmap F <Plug>(easymotion-overwin-f2)
	let g:EasyMotion_keys = 'alskjdhfwiuegnv'
	let g:EasyMotion_do_shade = 0
	nmap W <Plug>(easymotion-bd-w)
	vmap W <Plug>(easymotion-bd-w)
	vmap f <Plug>(easymotion-sl)
	let g:EasyMotion_smartcase = 1
	"}}}

	Plug 'https://github.com/luochen1990/rainbow'
	"{{{
	nnoremap <M-r>              :RainbowToggle<CR>
	"}}}

	Plug 'https://github.com/junegunn/goyo.vim'
	"{{{
	let g:goyo_width = 1000
	let g:goyo_height = 1000
	let g:goyo_linenr = 1
	nnoremap <silent> <C-d> :Goyo<CR>
	"}}}

	Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
	Plug 'junegunn/fzf.vim'
	"{{{
	nnoremap <silent> <C-f> :set noautochdir<CR>:call fzf#run(fzf#wrap({'dir': '$HOME', 'down': '30%', 'options':'--prompt "~/" --preview="pygmentize -g {-1}" --ansi'}))<CR>
	let g:fzf_action = {
				\ 'ctrl-t': 'tab split',
				\ 'ctrl-x': 'split',
				\ 'ctrl-v': 'vsplit' }

	let g:fzf_colors =
				\ { 'fg':      ['fg', 'Normal'],
				\ 'bg':      ['bg', 'Normal'],
				\ 'hl':      ['fg', 'Comment'],
				\ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
				\ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
				\ 'hl+':     ['fg', 'Statement'],
				\ 'info':    ['fg', 'PreProc'],
				\ 'prompt':  ['fg', 'Conditional'],
				\ 'pointer': ['fg', 'Exception'],
				\ 'marker':  ['fg', 'Keyword'],
				\ 'spinner': ['fg', 'Label'],
				\ 'header':  ['fg', 'Comment'] }

	let g:fzf_history_dir = '~/.local/share/vim-fzf-history'
	"}}}


	Plug 'https://github.com/benekastah/neomake'
	"{{{
	let g:neomake_error_sign = {
				\ 'text': '⚠',
				\ 'texthl': 'ErrorMsg',
				\ }
	autocmd! BufWritePost * silent! Neomake!
	"}}}

	Plug 'https://github.com/bling/vim-airline'
	"{{{
	let g:airline#extensions#hunks#enabled=1
	let g:airline#extensions#branch#enabled=1
	let g:airline#extensions#whitespace#enabled=0
	let g:airline_powerline_fonts = 0
	let g:airline_theme='oceanicnext'
	let g:airline_mode_map = {'c': 'C', '^S': 'S-B', 'R': 'R', 's': 'S', 't': 'TERM', 'V': 'V-L', '': 'V-B', 'i': 'I', '__': '------', 'S': 'S-LINE', 'v': 'V', 'n': 'N'}
	"}}}

	Plug 'https://github.com/mhinz/vim-signify'
	"Plug 'https://github.com/airblade/vim-gitgutteR'
	"{{{
	"call add(g:mod, 'gutterMod')
	let g:gitgutter_sign_removed="-"
	let g:gitgutter_sign_modified_removed="\u22c"
	let g:gitgutter_realtime = 0
	let g:gitgutter_eager = 0
	let g:signify_sign_add					= '+'
	let g:signify_sign_delete				= '-'
	let g:signify_sign_delete_first_line	= '-'
	let g:signify_sign_change				= '~'
	let g:signify_sign_changedelete			= g:signify_sign_change
	noremap <C-c> :call ToggleGutterMode()<CR>
	autocmd BufEnter * if !exists('b:gutterMod') | let b:gutterMod = 0 | endif
	try
		hi GitGutterAdd ctermbg=NONE guifg=green
		hi GitGutterDelete ctermbg=NONE guifg=red
		hi GitGutterChange ctermbg=NONE guifg=yellow
		hi GitGutterChangeDelete ctermbg=NONE guifg=red
	catch
	endtry
	function! ToggleGutterMode()
		if b:gutterMod == 0
			noremap <buffer> <S-j> :GitGutterNextHunk<CR>zz
			noremap <buffer> <S-k> :GitGutterPrevHunk<CR>zz
			noremap <buffer> <S-h> :GitGutterUndoHunk<CR>
			noremap <buffer> <S-l> :GitGutterPreviewHunk<CR>
			let b:gutterMod = 1
		else
			noremap <buffer> <S-k> <C-w><Up>
			noremap <buffer> <S-j> <C-w><Down>
			noremap <buffer> <S-h> <C-w><left>
			noremap <buffer> <S-l> <C-w><right>
			let b:gutterMod = 0
		endif
		call CallForMode()
	endfunction
	"}}}

	Plug 'https://github.com/scrooloose/nerdtree'
	"{{{
	"execute ":NERDTreeToggle " . expand("%:p:h")
	let NERDTreeShowBookmarks=1
	let g:NERDTreeDirArrows=0

	noremap <C-g>               :NERDTreeToggle<CR>
	"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
	autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
	nnoremap <leader>n :NERDTreeFind<CR>
	"}}}

	Plug 'https://github.com/AndrewRadev/switch.vim'
	"{{{
	let g:switch_mapping = '['
	let g:switch_reverse_mapping = ']'
	let g:switch_custom_definitions = [
				\   ['--', '++'],
				\   ['yes', 'no'],
				\   ['.', '->'],
				\   ['true', 'false'],
				\   ['TRUE', 'FALSE'],
				\   ['break', 'continue'],
				\   ['<=', '==', '>=']
				\ ]
	"}}}

	Plug 'https://github.com/vim-scripts/OmniCppComplete'
	"{{{
	let OmniCpp_NamespaceSearch = 1
	let OmniCpp_GlobalScopeSearch = 1
	let OmniCpp_ShowAccess = 1
	let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
	let OmniCpp_MayCompleteDot = 1 " autocomplete after .
	let OmniCpp_MayCompleteArrow = 1 " autocomplete after ->
	let OmniCpp_MayCompleteScope = 1 " autocomplete after ::
	let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]

	au BufNewFile,BufRead,BufEnter *.cpp,*.hpp set omnifunc=omni#cpp#complete#Main
	au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif

	"}}}

	Plug 'https://github.com/scrooloose/nerdcommenter'
	"{{{
	map cc <plug>NERDCommenterToggle
	"}}}

	Plug 'https://github.com/octol/vim-cpp-enhanced-highlight'
	"{{{
	let g:cpp_class_scope_highlight = 1
	"}}}

	call plug#end()
catch
endtry
"}}}

"{{{ Basic Setting
syntax on
try
	colorscheme neodark
	let g:neodark#background = '#111111'
catch
endtry

if has('nvim')
	set nofixeol                            " dont add automaticaly a newline in file
	set termguicolors
endif
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
"set expandtab                              " use muliple space instead of tab
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
"set guifont=Droid\ Sans\ Mono\ Slashed\ for\ Powerline\ 10
"}}}

"{{{ Color Fix
try
	hi! VertSplit ctermfg=darkgrey ctermbg=NONE guifg=NONE guibg=NONE term=NONE
	hi! LineNr ctermfg=darkgrey ctermbg=NONE guifg=darkgrey guibg=NONE
	hi Folded ctermbg=16 guibg=#2d1a35 guifg=#aaaaaa gui=bold
	hi NonText ctermfg=234 guifg=#545454
	hi CursorLine ctermbg=233 guibg=#2d1a35
	hi EndOfBuffer ctermfg=NONE guifg=#282a36
	hi CursorWord1 ctermbg=NONE guibg=NONE
	hi CursorWord0 ctermbg=NONE guibg=NONE
	hi CursorLineNr ctermbg=NONE guibg=NONE
	hi Search guibg=#0f550f guifg=peru gui=underline,bold
	hi FoldColumn ctermbg=NONE guibg=NONE
	hi Normal guifg=#eeeeee
	hi Comment guifg=#878787
catch
endtry
"}}}

"{{{ ReMap

"{{{ WORK
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
"nnoremap <C-[> <C-t>
nnoremap <M-t> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
nnoremap <S-t> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
noremap + <C-a>
noremap - <C-x>
nnoremap <up> <C-y>
nnoremap <down> <C-e>
nnoremap <S-k> <PageUp>
"3<C-y>3k
nnoremap <S-j> <PageDown>
"3<C-e>3j
"}}}

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
inoremap hh <C-o>:stopinsert<CR>:echo<CR>
inoremap jk <C-o>:stopinsert<CR>:echo<CR>
inoremap qq <C-o>:stopinsert<CR>:echo<CR>
cnoremap <C-h> <Left>
cnoremap <C-l> <Right>
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>
cnoremap jk <Esc>
cnoremap qq <Esc>
cnoremap hh <Esc>
vnoremap qq <Esc>

nnoremap <S-h> <C-w><Left>
nnoremap <S-l> <C-w><Right>
nnoremap <M-h> b
nnoremap <M-l> w

nnoremap n nzz
nnoremap N Nzz
"}}}

"{{{ Move line
if has('nvim')
   nnoremap <M-k> :m--<CR>
   nnoremap <M-j> :m+<CR>
   vnoremap <M-k> :m '<-2<CR>gv=gv
   vnoremap <M-j> :m '>+1<CR>gv=gv
   vnoremap <S-k> <PageUp>
   vnoremap <S-j> <PageDown>
else " Vim does not support Meta
   vnoremap <S-k> :m '<-2<CR>gv=gv
   vnoremap <S-j> :m '>+1<CR>gv=gv
endif
"}}}

"{{{ system ClipBoard
 vnoremap <M-c> "+2yy
 vnoremap <M-x> "+dd
 nnoremap <M-v> "+P
 nnoremap <C-x><C-v> "+P
 inoremap <M-v> <C-o>"+P
 cnoremap <M-v> <c-r>+
 " Copy fileName to clipboard
 nnoremap <silent> <M-y> :let @" = expand("%:p")<CR>: let @+ = @"<CR>
 nnoremap <silent> <C-x><C-y> :let @" = expand("%:p")<CR>: let @+ = @"<CR>
 nnoremap <silent> <M-y><M-y> :let @" = expand("%:p") . ":" . line(".")<CR>: let @+ = @"<CR>
"}}}

"{{{ open terminal neovim only
noremap <leader>k :topleft new<CR>:terminal<CR>
noremap <leader>j :botright new<CR>:terminal<CR>
noremap <leader>h :leftabove vnew<CR>:terminal<CR>
noremap <leader>l :rightbelow vnew<CR>:terminal<CR>
"noremap <leader><Tab> :tabnew<CR>:terminal<CR>
noremap <leader>o :call OpenExplorer()<CR>
"}}}

noremap <S-z> :set fdm=syntax<CR>zR

"{{{ Resize Pane
noremap <S-right> :vertical resize +5<CR>
noremap <S-left> :vertical resize -5<CR>
noremap <S-up> 5<C-w>+
noremap <S-down> 5<C-w>-
"}}}

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

"{{{ Leader Command
nnoremap <leader>s :w !sudo tee %<CR>l<CR>
nnoremap <leader><Tab> :let @a = expand("%:p")<CR>:q<CR>:execute "tabedit " . @a<CR>
nnoremap <leader>d :w !diff % -<CR>
nnoremap <leader>w :set wrap!<CR>
nnoremap <leader>r :so $MYVIMRC<CR>:nohlsearch<CR>
nnoremap <leader>b :call ToggleBinaryMode()<CR>
"}}}

" instantly select the first autocomplet choice
inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
			\ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

map! <F3> <C-R>=strftime('%c')<CR>

"{{{ Embeded terminal remap
if has('nvim')
	tnoremap <Esc> <C-\><C-n>
	tnoremap <M-v> <Esc>"+p<insert>
	tnoremap '' ''<Left>
	tnoremap "" ""<Left>
	tnoremap () ()<Left>
	tnoremap [] []<Left>
	tnoremap <> <><Left>
	tnoremap jk <Esc>
endif
"}}}

"{{{ C function argument switcher
nnoremap <leader>1 :call Switch_arg(1)<CR>@a
nnoremap <leader>2  :call Switch_arg(2)<CR>@a
nnoremap <leader>3  :call Switch_arg(3)<CR>@a
nnoremap <leader>4  :call Switch_arg(4)<CR>@a
nnoremap <leader>5  :call Switch_arg(5)<CR>@a
nnoremap <leader>6  :call Switch_arg(6)<CR>@a
nnoremap <leader>7  :call Switch_arg(7)<CR>@a
"cnoremap <C-r>  <CR>:call SearchToReplace()<CR>@a<LEFT><LEFT><LEFT>
cnoremap <C-r><C-r> <CR>:%s/<C-R>/
vnoremap /  "ay:let @a = "/" . @a<CR>@a<CR>
"}}}

"}}}

"{{{ Autocmd
autocmd BufEnter * set autochdir
autocmd StdinReadPre * let s:std_in=1
autocmd ColorScheme * hi! VertSplit ctermfg=darkgrey ctermbg=NONE term=NONE
autocmd ColorScheme * hi! LineNr ctermfg=darkgrey ctermbg=NONE
autocmd ColorScheme * hi Folded ctermbg=16
autocmd BufLeave, term://* stopinsert
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

function! CleanEmptyBuffers()
	let buffers = filter(range(0, bufnr('$')), 'buflisted(v:val) && empty(bufname(v:val)) && bufwinnr(v:val)<0')
	if !empty(buffers)
		exe 'bw '.join(buffers, ' ')
	endif
endfunction

command! Ifndef call Insert_ifndef()

function! Insert_ifndef()
	let l:filename = substitute(toupper(expand("%:t")), "\\.", "_", "g")
	execute "normal! gg"
	execute "normal! i#ifndef " . l:filename . "\r"
	execute "normal! i# define " . l:filename . "\r\r"
	execute "normal! Go\r#endif /* " . l:filename . " */"
	normal! kk
endfunction

"s/(\(.*\),\s*\(.*\))/(\2, \1)
"s/(\(.*\),\s*\(.*/))/(\1, \2)/gc

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
	"�kl -> left key obtained from pasted macro
	let l:str = join([l:str, ")/g|:nohlsearch" . repeat("�kl", 16)], "")
	let @a = l:str
endfunction
highlight currawong ctermbg=darkred guibg=darkred

function! SearchToReplace()
    let @a = ":%s/". @/ . "//gc"
endfunction

function! SelectToSearch()
    let @a = "\\". @a
endfunction

if has('nvim')
	let g:mtags = []

	command! SetTags call SetTags()
	function! SetTags()
		let l:str = ":set tags="
		:for i in g:mtags
		:  let l:str = l:str . i . ','
		:endfor
		:execute l:str
		":echomsg l:str
	endfunction

	command! Test3 call Test3()
	function! Test3()
		let l:str = ":match currawong /"
		:for i in g:mtags
		:  let l:str = l:str . '\%' . string(i) . 'l\|'
		:endfor
		if len(g:mtags) > 0
			:let l:str = strpart(l:str, 0, len(l:str) - 2)
		endif
		let l:str = l:str . '/'
		:execute l:str
		":echomsg l:str
	endfunction

	command! Test2 call Test2()
	function! Test2()
		:set modifiable
		"let b:line = winline()
		let b:line = strpart(getline('.'), 3, len(getline('.')))

		let b:num = index(g:mtags, b:line)
		if b:num == -1
			:call add(g:mtags, b:line)
			execute "normal! ^R[*]"
		else
			:call remove(g:mtags, b:num)
			execute "normal! ^R[ ]"
		endif
		:call writefile(msgpackdump(g:mtags), $HOME . '/fname.mpack', 'b')
		:call uniq(sort(g:mtags))
		:set nomodifiable
		:SetTags
		":Test3
	endfunction

	command! GetTagsList call GetTagsList()
	function! GetTagsList()
		let fname = expand($HOME . '/fname.mpack')
		let mpack = readfile(fname, 'b')
		let g:mtags = msgpackparse(mpack)
		let g:tlist = expand($HOME . '/.vim/tags/tlist')
		:SetTags
	endfunction

	command! Test call Test()
	function! Test()
		let fname = expand($HOME . '/fname.mpack')
		let mpack = readfile(fname, 'b')
		let g:mtags = msgpackparse(mpack)
		let g:tlist = expand($HOME . '/.vim/tags/tlist')
		:execute 'vne' g:tlist
		:vertical resize 35
		:set modifiable
		:setlocal nobuflisted buftype=nofile bufhidden=wipe noswapfile
		:set noundofile
		:nnoremap <buffer> <space> :Test2<CR>
		:nnoremap <buffer> <CR> :Test2<CR>

		let g:allt = getline(0, '$')
		:for i in g:mtags
		if index(g:allt, i) == -1
			:call remove(g:mtags, index(g:mtags, i))
		endif
		:endfor

		execute "normal! gg"
		let b:c = 0
		while b:c < line('$')
			let b:c += 1
			if index(g:mtags, getline('.')) == -1
				execute "normal! ^I[ ]"
			else
				execute "normal! ^I[*]"
			endif
			normal! j
		endwhile
		:set nomodifiable
		":Test3
	endfunction

	let g:DAYFUNC = []
	let g:WEEKFUNC = [":PlugUpdate"]
	let g:MONTHFUNC = []
	let g:YEARFUNC = []

	command! TimeCheck call TimeCheck()
	function! TimeCheck()
		let l:year = strftime('%y')
		let l:month = strftime('%m')
		let l:day = strftime('%d')

		if !exists("g:TODAYYEAR")
			let g:TODAYYEAR = l:year
		endif
		if !exists("g:TODAYMONTH")
			let g:TODAYMONTH = l:month
		endif
		if !exists("g:TODAYDAY")
			let g:TODAYDAY = l:day
		endif
		if g:TODAYYEAR != l:year
			let g:TODAYYEAR = l:year
			for i in g:YEARFUNC
				execute i
			endfor
		endif
		if g:TODAYMONTH != l:month
			let g:TODAYMONTH = l:month
			for i in g:MONTHFUNC
				execute i
			endfor
		endif
		if ((l:day) % 7 == 1) && (g:TODAYDAY != l:day)
			let g:TODAYDAY = l:day
			for i in g:WEEKFUNC
				execute i
			endfor
		endif
		if g:TODAYDAY != l:day
			let g:TODAYDAY = l:day
			for i in g:DAYFUNC
				execute i
			endfor
		endif
		wshada
	endfunction
endif

function! LineEnding() abort
	if &fileformat == 'dos'
		return "\r\n"
	elseif &fileformat == 'mac'
		return "\r"
	endif

	return "\n"
endfunction

function! GetOffset(line, col) abort
	if &encoding != 'utf-8'
		let sep = LineEnding()
		let buf = a:line == 1 ? '' : (join(getline(1, a:line-1), sep) . sep)
		let buf .= a:col == 1 ? '' : getline('.')[:a:col-2]
		return len(iconv(buf, &encoding, 'utf-8'))
	endif
	return line2byte(a:line) + (a:col-2)
endfunction

function! OffsetCursor() abort
	let l:lol = GetOffswet(line('.'), col('.'))
	echo l:lol
endfunction

function! OffsetMatch()

	call matchadd('Search', "\\%>'a.*\\%<'q", 12324)
endfunction

function! CallForMode()
	if !exists('g:mod')
		let g:mod = []
	endif
	let g:airline_mode_map['n'] = 'N'
	for i in g:mod
		execute("if b:" . i . " == 1\n let g:airline_mode_map['n'] = 'N-" . i . "'\nendif")
	endfor
endfunction

command! JsonIndent call JsonIndent()
function! JsonIndent()
	execute '%!python -m json.tool'
endfunction

function! DoPrettyXML()
	" save the filetype so we can restore it later
	let l:origft = &ft
	set ft=
	" delete the xml header if it exists. This will
	" permit us to surround the document with fake tags
	" without creating invalid xml.
	1s/<?xml .*?>//e
	" insert fake tags around the entire document.
	" This will permit us to pretty-format excerpts of
	" XML that may contain multiple top-level elements.
	0put ='<PrettyXML>'
	$put ='</PrettyXML>'
	silent %!xmllint --format -
	" xmllint will insert an <?xml?> header. it's easy enough to delete
	" if you don't want it.
	" delete the fake tags
	2d
	$d
	" restore the 'normal' indentation, which is one extra level
	" too deep due to the extra tags we wrapped around the document.
	silent %<
	" back to home
	1
	" restore the filetype
	exe "set ft=" . l:origft
endfunction
command! PrettyXML call DoPrettyXML()

function! StartBench()
	execute "profile start " . $HOME . "/profile.log"
	:profile func *
	:profile file *
endfunction

function! StopBench()
	:profile pause
	:noautocmd qall!
endfunction

function! GetExplorer()
   if executable('nautilus')
      return 'nautilus'
   elseif executable('dolfin')
      return 'dolfin'
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
      echomsg "No Explorer Provided"
   endif
endfunction
"}}}
