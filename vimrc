try
	call plug#begin('~/.vim/plugged')
	Plug 'https://github.com/morhetz/gruvbox'
	Plug 'https://github.com/scrooloose/nerdtree'
	Plug 'https://github.com/mhartington/oceanic-next'
	Plug 'https://github.com/KeitaNakamura/neodark.vim'
	Plug 'https://github.com/bling/vim-airline'
	Plug 'https://github.com/itchyny/vim-cursorword'
	Plug 'https://github.com/octol/vim-cpp-enhanced-highlight'
	Plug 'https://github.com/will133/vim-dirdiff'
	Plug 'https://github.com/vim-scripts/a.vim'
	Plug 'https://github.com/tpope/vim-fugitive'
	Plug 'https://github.com/mbbill/undotree'
	Plug 'https://github.com/godlygeek/tabular'
	Plug 'https://github.com/vim-scripts/mru.vim'
	Plug 'https://github.com/easymotion/vim-easymotion'
	Plug 'https://github.com/matze/vim-move'
	Plug 'https://github.com/kana/vim-textobj-user'
	Plug 'https://github.com/kana/vim-textobj-function'
	Plug 'https://github.com/rhysd/vim-textobj-anyblock'
	Plug 'https://github.com/sgur/vim-textobj-parameter'
	Plug 'https://github.com/AndrewRadev/switch.vim'
	Plug 'https://github.com/terryma/vim-multiple-cursors'
	Plug 'https://github.com/scrooloose/nerdcommenter'
	Plug 'https://github.com/KKPMW/moonshine-vim'
	Plug 'https://github.com/chrisbra/NrrwRgn'
	Plug 'https://github.com/justinmk/vim-syntax-extra'
	Plug 'https://github.com/luochen1990/rainbow'
	Plug 'https://github.com/oblitum/rainbow'
	Plug 'https://github.com/airblade/vim-gitgutteR'
	Plug 'https://github.com/elzr/vim-json'
	Plug 'https://github.com/vim-scripts/OmniCppComplete'
	Plug 'https://github.com/kshenoy/vim-signature'
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
    Plug 'https://github.com/junegunn/goyo.vim'
let g:goyo_width = 1000
let g:goyo_height = 1000
let g:goyo_linenr = 1
nnoremap <silent> <C-d> :Goyo<CR>

	if has('nvim')
		Plug 'https://github.com/benekastah/neomake'
		Plug 'https://github.com/critiqjo/lldb.nvim'
	endif

	call plug#end()
catch
endtry
let g:neomake_error_sign = {
			\ 'text': '⚠',
			\ 'texthl': 'ErrorMsg',
			\ }

let g:airline#extensions#hunks#enabled=1
let g:airline#extensions#branch#enabled=1
let g:airline#extensions#whitespace#enabled=0
let g:airline_powerline_fonts = 0
let g:airline_theme='oceanicnext'
let g:airline_mode_map = {'c': 'C', '^S': 'S-B', 'R': 'R', 's': 'S', 't': 'TERM', 'V': 'V-L', '': 'V-B', 'i': 'I', '__': '------', 'S': 'S-LINE', 'v': 'V', 'n': 'N'}

let g:gitgutter_sign_removed="-"
let g:gitgutter_sign_modified_removed="\u22cd"

let g:switch_mapping = '['
let g:switch_reverse_mapping = ']'
let g:switch_custom_definitions = [
			\   ['--', '++'],
			\   ['yes', 'no']
			\ ]
let g:cpp_class_scope_highlight = 1

let g:NERDTreeDirArrows=0
let mapleader = ","
let g:mapleader = ","

"omni cpp
let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_ShowPrototypeInAbbr = 1 " show function parameters
let OmniCpp_MayCompleteDot = 1 " autocomplete after .
let OmniCpp_MayCompleteArrow = 1 " autocomplete after ->
let OmniCpp_MayCompleteScope = 1 " autocomplete after ::
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]


syntax on
try
	colorscheme neodark
catch
endtry
if has('nvim')
    set nofixeol
endif
set noeol
set background=dark
set nocompatible
set hidden
set showtabline=1
set noshowmode
set number									" display line number
set numberwidth=1
"set cc=80									" display column layout
set tabstop=4								" redifine tab display as n space
set t_Co=256								" change nubmer of term color
set cursorline								" hightlight current line
set shiftwidth=4
"set expandtab								" use muliple space instead of tab
set autoindent
set smartindent
set whichwrap+=<,>,h,l,[,]					" warp cusrsor when reache end and begin of line
set list listchars=tab:»\ ,trail:· ",eol:¶		" highlight tab space en eol
set foldnestmax=1							" allow 0 nested fold
set noswapfile
set autoread								" change file when editing from the outside
set hlsearch								" highligth search
set ic										" case insensitive
set smartcase								" Override the 'ignorecase' option if the search pattern contains upper case characters
set laststatus=2							" alway show status line
set wildmenu								" pop menu when autocomplete command
set wildmode=longest:full,full				" widlmenu option
set autochdir								" auto change directories of file
set nowrap									" dont warp long line
set virtualedit=onemore
set timeoutlen=400							" delay of key combinations ms
set updatetime=250
set matchpairs=(:),[:],{:},<:>				" hl pairs and jump with %
set lazyredraw								" redraw only when we need to.
set incsearch								" While typing a search command, show where the pattern is
set undodir=/tmp
set undofile
set fillchars=""vert:"│						" use pipe as split character
set pastetoggle=<F2>
set notagbsearch " disable the error E432 see :h E432
set completeopt=menuone,menu,longest,preview

try
	hi! VertSplit ctermfg=darkgrey ctermbg=bg guifg=darkgrey guibg=bg term=NONE
	hi! LineNr ctermfg=darkgrey ctermbg=bg guifg=darkgrey guibg=bg
	hi Folded ctermbg=16
	hi NonText ctermfg=bg
	hi CursorLine ctermbg=233
	hi CursorWord1 ctermbg=bg
	hi CursorLineNr ctermbg=bg
catch
endtry
"==========Pair characters change
inoremap {<CR>	{}<Left><cr><cr><up><tab>
inoremap {}	{}<Left>
inoremap {};	{};<Left><Left><cr><cr><up><tab>
inoremap {}<CR>	{}<Left><cr><cr><up><tab>
inoremap ''	''<Left>
inoremap ""	""<Left>
inoremap ()	()<Left>
inoremap []	[]<Left>
inoremap <>	<><Left>
"==========

inoremap <C-a>	<Esc><S-i>
inoremap <C-e>	<Esc><S-a>
inoremap <M-left>	20z<left>
inoremap <C-e>	<Esc><S-a>
inoremap hh <C-o>:stopinsert<CR>:echo<CR>
inoremap <C-k>	<Up>
inoremap <C-j>	<Down>
inoremap <C-h>	<Left>
inoremap <C-l>	<Right>

nnoremap <silent> x "_x
nnoremap <silent> <S-x> "_<S-x>
nnoremap <silent> <C-t> :let @3=@"<CR>xp:let@"=@3<CR>
nnoremap t <C-]>
nnoremap <S-t> <C-t>
noremap ;     :
noremap <M-left>	20z<left>
noremap <M-right>	20z<right>
noremap <leader>k  :m--<CR>
noremap <leader>j  :m+<CR>

noremap <C-a>			0
noremap <C-e>			g$

noremap <M-r>               :RainbowToggle<CR>
noremap <C-g>				:NERDTreeToggle<CR>
noremap <Space><Space>		:tabedit ~/.vimrc<CR>
nnoremap <S-Tab>			:tabprevious<CR>
nnoremap <Tab>				:tabnext<CR>
noremap <S-z>				:set fdm=syntax<CR>zR
nnoremap <space>			:nohlsearch<CR>
noremap <C-f>               :set noautochdir<CR>:call fzf#run(fzf#wrap({'dir': '$HOME', 'down': '30%', 'options':'--prompt "~/" --preview="pygmentize -g {-1}" --ansi'}))<CR>
"execute ":NERDTreeToggle " . expand("%:p:h")
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

let g:fzf_history_dir = '~/.local/share/fzf-history'

noremap <S-right> :vertical resize +5<CR>
noremap <S-left> :vertical resize -5<CR>
noremap <S-up> 5<C-w>+
noremap <S-down> 5<C-w>-

vnoremap <Tab>				>
vnoremap <S-Tab>			<
vnoremap <Space>            :s/\s\+$//<CR>

noremap <S-k>				<C-w><Up>
noremap <S-j>				<C-w><Down>
noremap <S-h>				<C-w><Left>
noremap <S-l>				<C-w><Right>

cnoremap <C-h>	<Left>
cnoremap <C-l>	<Right>
cnoremap <C-j>	<Down>
cnoremap <C-k>	<Up>
cnoremap hh <Esc>

inoremap <C-u>				<Esc><C-r>
noremap <C-u>				<C-r>

inoremap <C-s>        <Esc>:w<CR><insert><Right>
nnoremap <silent>			<C-s>	:w<CR>
nnoremap <silent>			<C-q>	:q<CR>

nnoremap <C-x><S-s>  :w !sudo tee %<CR>L<CR>
nnoremap <C-j>       <S-j>
nnoremap <C-l>       <S-l>
nnoremap <C-h>       <S-h>

"==========system ClipBoard acces
vnoremap <M-c> "+2yy
vnoremap <M-x> "+dd 
noremap <M-v> "+P
inoremap <M-v> <C-o>"+P
"==========

nnoremap <C-x><C-d>       :w !diff % -<CR>
noremap <C-x><C-w>        :execute ToggleLineWrap()<CR>''
noremap <C-x><C-r>        :so $MYVIMRC<CR>:nohlsearch<CR>
noremap <C-x>k  :topleft new<CR>:terminal<CR>
noremap <C-x>j  :botright new<CR>:terminal<CR>
noremap <C-x>h  :leftabove vnew<CR>:terminal<CR>
noremap <C-x>l  :rightbelow vnew<CR>:terminal<CR>
noremap <C-x><Tab>  :tabnew<CR>:terminal<CR>
noremap <C-x><C-b> :call ToggleBinaryMode()<CR>
noremap <C-c> :call ToggleGutterMode()<CR>
noremap <C-x><C-q> :%s/cb2a/cup/gc
noremap + <C-a>
noremap - <C-x>
nnoremap <up> <C-y>
nnoremap <down> <C-e>
map! <F3> <C-R>=strftime('%c')<CR>

if has('nvim')
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

autocmd BufEnter * set autochdir
if has('nvim')
    autocmd VimEnter * GetTagsList
endif
autocmd! BufWritePost * silent! Neomake!
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
autocmd ColorScheme * hi! VertSplit ctermfg=darkgrey ctermbg=bg term=NONE
autocmd ColorScheme * hi! LineNr ctermfg=darkgrey ctermbg=bg
autocmd ColorScheme * hi Folded ctermbg=16
autocmd BufEnter, term://* startinsert
autocmd BufLeave, term://* stopinsert
autocmd BufEnter * if !exists('b:isAnchor') | let b:isAnchor = 1 | endif
autocmd BufEnter * if !exists('b:isBinary') | let b:isBinary = 0 | endif
autocmd BufEnter * if !exists('b:gutterMod') | let b:gutterMod = 0 | endif
autocmd BufEnter * if !exists('b:isWrap') | let b:isWrap = 1 | endif
autocmd CursorMoved * call Anchor()
autocmd FileType cpp map! <F4> std::cout << __func__<< " line:" << __LINE__ << std::endl;
autocmd FileType cpp map! <F5> std::cout << __func__<< " msg:" <<  << std::endl;<Esc>13<Left><insert>""
autocmd FileType c map! <F4> printf( __func__" line:"__LINE__"\n");
autocmd FileType c map! <F5> printf(__func__" \n");<Esc>4<Left><insert>
autocmd FileType php map! <F4> print_r("file: ".__FILE__."line: ".__LINE__);
autocmd FileType php map! <F5> print_r("file: ".__FILE__."line: ".__LINE__.''<Right>);<Esc>2<Left><insert>

" omnicpp
au BufNewFile,BufRead,BufEnter *.cpp,*.hpp set omnifunc=omni#cpp#complete#Main
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif

"==========undotree
noremap <C-b>				:UndotreeToggle<CR>
let g:undotree_SetFocusWhenToggle=1
let g:undotree_WindowLayout=4
"==========
"
"==========easy Motion config
let g:EasyMotion_do_mapping = 0 " Disable default mappings
nmap f <Plug>(easymotion-sl)
nmap F <Plug>(easymotion-overwin-f2)
let g:EasyMotion_keys = 'alskjdhfwiuegnv'
let g:EasyMotion_do_shade = 0
nmap W <Plug>(easymotion-bd-w)
vmap W <Plug>(easymotion-bd-w)
vmap f <Plug>(easymotion-sl)
let g:EasyMotion_smartcase = 1
"==========

"==========nerd Commenter
map cc <plug>NERDCommenterToggle
"==========

"==========Narrowd Region
let g:nrrw_rgn_vert = 1
let g:nrrw_rgn_resize_window = 'column'
vnoremap n     :NR<CR>
"==========

"=========GitGutter
try
	hi GitGutterAdd ctermbg=bg
	hi GitGutterDelete ctermbg=bg
	hi GitGutterChange ctermbg=bg
	hi GitGutterChangeDelete ctermbg=bg
catch
endtry
"==========

function! ToggleLineWrap()
	if b:isWrap == 0
		setlocal nowrap
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

function! ToggleBinaryMode()
	if b:isBinary == 0
		:%!xxd
		let b:isBinary = 1
	else
		:%!xxd -r
		let b:isBinary = 0
	endif
endfunction

function! ToggleGutterMode()
	if b:gutterMod == 0
        noremap <buffer> <S-j>				:GitGutterNextHunk<CR>
        noremap <buffer> <S-k>				:GitGutterPrevHunk<CR>
		let b:gutterMod = 1
	else
        noremap <buffer> <S-k>				<C-w><Up>
        noremap <buffer> <S-j>				<C-w><Down>
		let b:gutterMod = 0
	endif
endfunction

command! AnchorToggle call AnchorToggle()
function! AnchorToggle()
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
			exec "noremap <buffer> k gk<C-y>"
		else
			exec "noremap <buffer> k gk"
		endif
		if winline() > (winheight(0) - winheight(0) / 8)
			exec "noremap <buffer> j gj<C-e>"
		else
			exec "noremap <buffer> j gj"
		endif
	endif
endfunction

"" NERDTress File highlighting
function! NERDTreeHighlightFile(extension, fg, bg)
	exec 'autocmd filetype nerdtree syn match ' . 'nerd' . a:extension .' #^\s\+.*\.'. a:extension .'$#'
	exec 'autocmd filetype nerdtree highlight ' . 'nerd' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:bg .' guifg='. a:fg
endfunction

call NERDTreeHighlightFile('cpp', 'green', 'none')
call NERDTreeHighlightFile('hpp', 'green', 'none')
call NERDTreeHighlightFile('c', 'lightgreen', 'none')
call NERDTreeHighlightFile('h', 'lightgreen', 'none')
call NERDTreeHighlightFile('py', 'cyan', 'none')
call NERDTreeHighlightFile('py\*', 'cyan', 'none')
call NERDTreeHighlightFile('sh', 'yellow', 'none')
call NERDTreeHighlightFile('sh\*', 'yellow', 'none')
call NERDTreeHighlightFile('ini', 'darkyellow', 'none')
call NERDTreeHighlightFile('php', 'lightyellow', 'none')
call NERDTreeHighlightFile('lua', 'lightblue', 'none')
call NERDTreeHighlightFile('moon', 'blue', 'none')

function! CleanEmptyBuffers()
  let buffers = filter(range(0, bufnr('$')), 'buflisted(v:val) && empty(bufname(v:val)) && bufwinnr(v:val)<0')
  if !empty(buffers)
    exe 'bw '.join(buffers, ' ')
  endif
endfunction

let g:marks = []
function! Test()
    let l:m = 'l'
    let l:l = 355
    let l:c = 7
    let l:asd = {'mark':l:m,'line':l:l,'col':l:c}
    call add(g:marks, l:asd)
endfunction

let s:all_marks = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.'`^<>[]{}()\""

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
	let l:str = "s/(\\(.*\\)"

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
	let l:str = join([l:str, ")/gc"], "")
	let @a = l:str
endfunction
highlight currawong ctermbg=darkred guibg=darkred

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
  let l:lol = GetOffset(line('.'), col('.'))
  echo l:lol
endfunction

"global feature thread safe
"
"coreFile 0.0.0   : open file, read access, write access
"screen 0.0.0     : grid x/x display, float display
"scheduler 0.0.0  : link input/output
"coreEditor 0..0.0: edit memory
