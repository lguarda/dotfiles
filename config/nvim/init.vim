"{{{ Var
let g:mod = []
let mapleader = ","
let g:mapleader = ","
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
let g:vimfiles = fnamemodify(expand("$MYVIMRC"), ":p:h")
let $VIMFILES = g:vimfiles
"}}}
"{{{ Basic Setting
" More information :h '{option}'
syntax on
set noendofline                  " No <EOL> will be written for the last line in the file
set background=dark              " Set background color in dark mode
set nocompatible                 " Vi legacy
set hidden                       " When off a buffer is unloaded when it is abandoned
set showtabline=1                " Enable tabline
set noshowmode                   " Disable --[mode]-- in cmd line
set number                       " Display line number
set numberwidth=1                " Minimum number column size
set t_Co=256                     " Change nubmer of term color
set cursorline                   " Hightlight current line
set tabstop=4                    " Redifine tab display as n space
set softtabstop=4
set shiftwidth=4                 " Number of spaces to use for each step of (auto)indent
set expandtab                    " Use muliple space instead of tab
set autoindent                   " Copy indent from current line when starting a new line
set smartindent                  " Do smart autoindenting when starting a new line
set whichwrap+=<,>,h,l,[,]       " Warp cusrsor when reache end and begin of line
set foldnestmax=1                " Allow 0 nested fold
set foldcolumn=0                 " Hide fold column
set noswapfile                   " Do not use ~swapfile
set autoread                     " Change file when editing from the outside
set hlsearch                     " Highligth search
set ignorecase                   " Case insensitive
set smartcase                    " Override the 'ignorecase' option if the search pattern contains upper case characters
set laststatus=2                 " Alway show status line
set wildmenu                     " Pop menu when autocomplete command
set wildmode=longest:full,full   " Widlmenu option
set autochdir                    " Auto change directories of file
set nowrap                       " Dont warp long line
set linebreak                    " Break at a word boundary
set virtualedit=onemore          " Allow normal mode to go one more charater at the end
set timeoutlen=400               " Delay of key combinations ms
set updatetime=250               " If this many milliseconds nothing is typed the swap file will be written to disk
set matchpairs=(:),[:],{:},<:>   " Hl pairs and jump with %
set lazyredraw                   " Redraw only when we need to.
set incsearch                    " While typing a search command, show where the pattern is
set undofile                     " Use undofile
set undodir=$VIMFILES/undo       " Undofile location
set noswapfile                   " Don't use swapfile for the buffer
set pastetoggle=<F2>             " Toggle paste mode vi legacy
set notagbsearch                 " Disable the error E432 see :h E432
set cmdheight=1                  " Number of screen lines to use for the command-line
set mouse=a                      " Set mouse for all mode
set display+=uhex,lastline       " Change the way text is displayed. uhex: Show unprintable characters hexadecimal as <xx>
set history=10000                " A history of ":" commands, and a history of previous search patterns is remembered
set sidescroll=1                 " The minimal number of columns to scroll horizontally
set ruler                        " Show the line and column number of the cursor position
set backup                       " Make a backup before overwriting a file.
set backupdir=$VIMFILES/backup  " List of directories for the backup file, separated with commas.
set colorcolumn=80               " Add a colored column marker at specified size cc=0 to disable
set list                         " Enable listchars
set listchars=tab:>\ ,nbsp:¬,trail:_,extends:$,precedes:$ ",eol:¶  " highlight tab space en eol
set fillchars=stl:\ ,stlnc:\ ,vert:\ ,fold:\ ,diff:- " Use space for multiple separator
set completeopt=menuone,menu,longest,preview
set wildignore=.svn,CVS,.git,*.o,*.a,*.class,*.mo,*.la,*.so,*.obj,*.swp,*.jpg,*.png,*.xpm,*.gif,*.pdf,*.bak,*.beam,*.wave
"set guifont=Droid\ Sans\ Mono\ Slashed\ for\ Powerline\ 10

if !isdirectory($VIMFILES.'/undo')
    call mkdir($VIMFILES.'/undo', "p")
endif

if !isdirectory($VIMFILES.'/backup')
    call mkdir($VIMFILES.'/backup', "p")
endif

if has('nvim')
    set termguicolors
    set fixendofline                 " <EOL> at the end of file will be not restored if missing
endif

if $SHLVL == 0
    map <c-z> :execute "echohl WarningMsg\|echomsg 'Nope ! cannot suspend in standalone.'\|silent echohl None"<CR>
endif

"}}}
"{{{ Plugin
"{{{ Vim-PLUG
if filereadable(g:vimfiles . "/autoload/plug.vim") == 0 && executable('curl')
    silent execute ":!mkdir -p " . g:vimfiles . "/autoload"
    silent execute ":!curl -fLo " . g:vimfiles . "/autoload/plug.vim --create-dirs " .
    \ "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
    autocmd VimEnter * :PlugInstall
endif
let g:plug_window = "rightbelow new"
"}}}
try
    if has("win32")
        let g:vimfiles='~/vimfiles/'
        call plug#begin('~/vimfiles/bundle')
    else
        call plug#begin($VIMFILES.'/plugged')
    endif
    "{{{ Color Scheme
    Plug 'https://github.com/morhetz/gruvbox'
    Plug 'https://github.com/mhartington/oceanic-next'
    Plug 'https://github.com/KeitaNakamura/neodark.vim'
    Plug 'https://github.com/KKPMW/moonshine-vim'
    Plug 'https://github.com/dracula/vim'
    "}}}
    "{{{ Syntax plugin
    Plug 'https://github.com/tpope/vim-markdown'
    let g:markdown_folding = 1
    let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'javascript', 'lua', 'c', 'cpp', 'perl', 'nix', 'yaml']
    Plug 'https://github.com/elzr/vim-json'
    Plug 'https://github.com/PotatoesMaster/i3-vim-syntax'
    Plug 'https://github.com/tbastos/vim-lua'
    Plug 'https://github.com/dag/vim-fish'
    Plug 'https://github.com/octol/vim-cpp-enhanced-highlight'
    let g:cpp_class_scope_highlight = 1
    Plug 'https://github.com/vim-scripts/gnuplot.vim/'
    Plug 'https://github.com/sirtaj/vim-openscad'
    Plug 'https://github.com/LnL7/vim-nix'
    Plug 'https://github.com/vim-scripts/groovy.vim'
    Plug 'https://github.com/justinmk/vim-syntax-extra'
    "}}}
    "{{{ Text object
    Plug 'https://github.com/kana/vim-textobj-user'
    Plug 'https://github.com/kana/vim-textobj-function'
    Plug 'https://github.com/rhysd/vim-textobj-anyblock'
    Plug 'https://github.com/sgur/vim-textobj-parameter'
    "}}}
    Plug 'https://github.com/will133/vim-dirdiff'
    Plug 'https://github.com/tpope/vim-fugitive'
    Plug 'https://github.com/godlygeek/tabular'
    Plug 'https://github.com/terryma/vim-multiple-cursors'
    "Plug 'https://github.com/kshenoy/vim-signature' " SLOW
    "Plug 'https://github.com/google/vim-searchindex'  " mess with undo
    Plug 'https://github.com/dpelle/vim-LanguageTool'
    Plug 'https://github.com/google/vim-maktaba'
    Plug 'https://github.com/google/vim-syncopate'
    Plug 'https://github.com/iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
    Plug 'https://github.com/johngrib/vim-game-snake'
    Plug 'https://github.com/Shougo/unite.vim'
    Plug 'https://github.com/vim-scripts/vis'
    Plug 'https://github.com/mhinz/vim-startify'
    Plug 'https://github.com/johngrib/vim-game-snake'
    Plug 'https://github.com/johngrib/vim-game-code-break'
    Plug 'https://github.com/honza/vim-snippets'
    Plug 'https://github.com/tpope/vim-surround'
    Plug 'https://github.com/lambdalisue/suda.vim'
    "Plug 'https://github.com/neoclide/coc.nvim', {'branch': 'release'}
    "Plug 'https://github.com/vim-scripts/LargeFile'
    Plug 'https://github.com/raghur/vim-ghost', {'do': ':GhostInstall'}
    Plug 'https://github.com/neoclide/coc-snippets'
    Plug 'https://github.com/glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
    Plug 'https://github.com/ternjs/tern_for_vim', { 'do': 'npm install -g tern' }
    Plug 'https://github.com/w0rp/ale'
    "Plug 'https://github.com/SirVer/ultisnips' "{{{
    let g:UltiSnipsExpandTrigger="<c-x><c-n>"
    "}}}
    Plug 'https://github.com/pbogut/fzf-mru.vim' "{{{
    let fzf_mru_max=1000
    nnoremap <space>m :FZFMru<CR>
    "}}}
    Plug 'https://github.com/yuttie/comfortable-motion.vim'"{{{
    let g:comfortable_motion_no_default_key_mappings = 1
    noremap <silent> <ScrollWheelDown> :call comfortable_motion#flick(80)<CR>
    noremap <silent> <ScrollWheelUp>   :call comfortable_motion#flick(-80)<CR>
    "}}}
    Plug 'https://github.com/vim-scripts/a.vim' "{{{
    let g:alternateSearchPath = 'sfr:../source,sfr:../src,sfr:../Src,sfr:../include,sfr:../inc,sfr:../Inc'
    "}}}
    Plug 'https://github.com/majutsushi/tagbar' "{{{
    nnoremap <space>t :TagbarToggle<CR>
    "}}}
    Plug 'https://github.com/vimwiki/vimwiki' "{{{
    autocmd BufWrite *.wiki :execute "normal \<Plug>Vimwiki2HTML"
    autocmd BufEnter *.wiki :nmap <space>wh <Plug>Vimwiki2HTMLBrowse
    let g:vimwiki_list_ignore_newline=0
    let wiki = {}
    let wiki.path = '~/vimwiki/'
    let wiki.nested_syntaxes = {'python': 'python', 'c++': 'cpp', 'js' : 'javascript'}
    "let wiki.template_path = '~/vimwiki/'
    "let wiki.template_default = 'baseTemplate'
    "let wiki.template_ext = '.tpl'
    "let wiki.html_template = '~/vimwiki/baseTemplate.tpl'
    let g:vimwiki_list = [wiki]
    "}}}
    Plug 'https://github.com/chrisbra/NrrwRgn' "{{{
    let g:nrrw_rgn_vert = 1
    let g:nrrw_rgn_resize_window = 'column'
    vnoremap n :NR<CR>
    "}}}
    Plug 'https://github.com/mbbill/undotree' "{{{
    noremap <C-b> :UndotreeToggle<CR>
    let g:undotree_SetFocusWhenToggle=1
    let g:undotree_WindowLayout=4
    "}}}
    Plug 'https://github.com/easymotion/vim-easymotion' "{{{
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
    Plug 'https://github.com/luochen1990/rainbow' "{{{
    nnoremap <M-r> :RainbowToggle<CR>
    "}}}
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } "{{{
    Plug 'junegunn/fzf.vim'

    nnoremap <silent> <C-f> :set noautochdir<CR>:call fzf#run(fzf#wrap({'dir': $HOME, 'down': '30%', 'options':'--prompt "~/" --preview="cat {-1}" --ansi'}))<CR>
    let g:fzf_action = {
                \ 'ctrl-t': 'tab split',
                \ 'ctrl-x': 'split',
                \ 'ctrl-v': 'vsplit' }

    "let g:fzf_colors =
    "\ { 'fg':    ['fg', 'Normal'],
    "\ 'bg':      ['bg', 'Normal'],
    "\ 'hl':      ['fg', 'Comment'],
    "\ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
    "\ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
    "\ 'hl+':     ['fg', 'Statement'],
    "\ 'info':    ['fg', 'PreProc'],
    "\ 'prompt':  ['fg', 'Conditional'],
    "\ 'pointer': ['fg', 'Exception'],
    "\ 'marker':  ['fg', 'Keyword'],
    "\ 'spinner': ['fg', 'Label'],
    "\ 'header':  ['fg', 'Comment'] }

    let g:fzf_history_dir = '~/.local/share/vim-fzf-history'
    "}}}
    "DISABLED Plug 'https://github.com/benekastah/neomake' "{{{
    "let g:neomake_error_sign = {
    "\ 'text': '>>',
    "\ 'texthl': 'ErrorMsg',
    "\ }
    "autocmd! BufWritePost * silent! Neomake!
    "}}}
    Plug 'https://github.com/bling/vim-airline' "{{{
    let g:airline#extensions#hunks#enabled=1
    let g:airline#extensions#branch#enabled=1
    let g:airline#extensions#whitespace#enabled=0
    let g:airline_powerline_fonts = 0
    let g:airline_theme='oceanicnext'
    let g:airline_mode_map = {'c': 'C', '^S': 'S-B', 'R': 'R', 's': 'S', 't': 'TERM', 'V': 'V-L', '': 'V-B', 'i': 'I', '__': '------', 'S': 'S-LINE', 'v': 'V', 'n': 'N'}
    "}}}
    Plug 'https://github.com/mhinz/vim-signify' "{{{
    call add(g:mod, 'git_mode')
    let g:signify_sign_add               = '+'
    let g:signify_sign_delete            = '-'
    let g:signify_sign_delete_first_line = '¯'
    let g:signify_sign_change            = '~'
    let g:signify_sign_changedelete      = "\u22c"
    noremap <C-c> :call ToggleGitMode()<CR>
    autocmd BufEnter * if !exists('b:git_mode') | let b:git_mode = -1 | endif
    autocmd BufEnter * if !exists('b:visualMove') | let b:visualMove = -1 | endif

    let g:vcs_diff_whitespace = 1

    function! ToggleGitDiffWhiteSpace()
        let g:vcs_diff_whitespace *= -1
        if g:vcs_diff_whitespace == 1
            let g:signify_vcs_cmds['git'] = 'git diff --no-color --no-ext-diff -U0 -- %f'
        else
            let g:signify_vcs_cmds['git'] = 'git diff -w --no-color --no-ext-diff -U0 -- %f'
        endif
    endfunction

    function! ToggleGitMode()
        let b:git_mode *= -1
        if b:git_mode == 1
            echo "LOL2"
            nmap <buffer> <S-j> <plug>(signify-next-hunk)
            nmap <buffer> <S-k> <plug>(signify-prev-hunk)
            nmap <buffer> <S-h> :SignifyHunkUndo<CR>:SignifyRefresh<CR>
            nmap <buffer> <S-l> :SignifyHunkDiff<CR>
            noremap <buffer> <c-l> :call CheckoutPreviousCommitLine()<CR>:Gblame<CR><c-w><right>
            noremap <buffer> <c-h> :call CheckoutPreviousCommitLineRevert()<CR>:Gblame<CR><c-w><right>
            nnoremap w :call ToggleGitDiffWhiteSpace()<CR>:SignifyRefresh<CR>
        else
            nmap <buffer> <S-k> <C-w><Up>
            nmap <buffer> <S-j> <C-w><Down>
            nmap <buffer> <S-h> <C-w><left>
            nmap <buffer> <S-l> <C-w><right>
            nnoremap w w
        endif
        call CallForMode()
    endfunction
    "}}}
    Plug 'https://github.com/scrooloose/nerdtree' "{{{
    "Plug 'https://github.com/ryanoasis/vim-devicons' SLOW
    "execute ":NERDTreeToggle " . expand("%:p:h")
    let NERDTreeShowBookmarks=1
    let g:NERDTreeDirArrows=0
    let NERDTreeIgnore = ['\~$','\.pyc$','\*NTUSER*','\*ntuser*','\NTUSER.DAT','\ntuser.ini']
    nnoremap <C-g>      :NERDTreeToggle<CR>
    nnoremap <C-x><C-G> :NERDTreeFind<CR>
    "autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
    "autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
    "}}}
    Plug 'https://github.com/AndrewRadev/switch.vim' "{{{
    let g:switch_mapping = '['
    let g:switch_reverse_mapping = ']'
    let g:switch_custom_definitions = [
                \   ['.', '->'],
                \   ['--', '++'],
                \   ['==', '!='],
                \   ['<=', '>='],
                \   ['yes', 'no'],
                \   ['YES', 'NO'],
                \   ['Yes', 'No'],
                \   ['true', 'false'],
                \   ['TRUE', 'FALSE'],
                \   ['True', 'False'],
                \   ['or', 'and'],
                \   ['break', 'continue'],
                \   ['package', 'import'],
                \   ['private', 'public'],
                \   {
                \     '\<[a-z0-9]\+_\k\+\>': {
                \       '_\(.\)': '\U\1'
                \     },
                \     '\<[a-z0-9]\+[A-Z]\k\+\>': {
                \       '\([A-Z]\)': '_\l\1'
                \     },
                \   }
                \ ]
    "}}}
    Plug 'https://github.com/vim-scripts/OmniCppComplete' "{{{
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
    Plug 'https://github.com/scrooloose/nerdcommenter' "{{{
    map cc <plug>NERDCommenterToggle
    map ci <plug>NERDComInvertComment
    nnoremap cs :call ComSearch()<CR>@a
    function! ComSearch()
        let @a = ":g//exe \"norm \\<plug>NERDCommenterToggle\"". repeat("kl", 38)
    endfunction
    "}}}
    call plug#end()
catch
    echoerr "This script just failed!"
endtry
"}}}
"{{{ Color scheme
try
    let g:neodark#background = '#111111'
    colorscheme neodark
catch
endtry

try
    "hi! VertSplit ctermfg=darkgrey ctermbg=NONE guifg=bg guibg=NONE term=NONE
    hi! LineNr ctermfg=darkgrey ctermbg=NONE guifg=darkgrey guibg=NONE
    hi Folded ctermbg=234 guibg=#2d1a35 guifg=#aaaaaa gui=bold
    hi NonText ctermfg=234 guifg=#545454
    hi CursorLine ctermbg=235 guibg=#2d1a35
    hi EndOfBuffer ctermfg=NONE guifg=bg
    hi CursorWord1 ctermbg=NONE guibg=NONE
    hi CursorWord0 ctermbg=NONE guibg=NONE
    hi CursorLineNr ctermbg=NONE guibg=NONE
    hi Search guibg=#0f550f guifg=peru gui=underline,bold
    hi FoldColumn ctermbg=NONE guibg=NONE
    hi Normal guifg=#bfbfbf
    hi Comment guifg=#878787
catch
endtry
"}}}
"{{{ ReMap
"{{{ WORK
nnoremap <space>n :execute ":tabedit " . $HOME . "/NOTE"<CR>
nnoremap <space>c :tabedit C:\Program Files\Ingenico\C3Driver\bin\c3config<CR>
nnoremap <space>C :tabedit C:\Program Files\Ingenico\C3Driver - Copie\bin\c3config<CR>
"}}}
"{{{ Comfort remap
nnoremap ss z=1<cr><cr>
nnoremap Q q
nnoremap <silent> x "_x
nnoremap <M-BS> db
inoremap <M-BS> <ESC>lcb
nnoremap <M-Del> de
inoremap <M-Del> <ESC>lce
nnoremap <S-BS> db
nnoremap <S-Del> de
nnoremap <M-x> de
nnoremap <M-S-x> db
nnoremap <silent> <S-x> "_<S-x>
"nnoremap <silent> <C-t> :let @3=@"<CR>xlP:let@"=@3<CR>
"nnoremap ; :
nnoremap <space><space> :tabedit $MYVIMRC<CR>
nnoremap <S-Tab> :tabprevious<CR>
nnoremap <Tab> :tabnext<CR>
" Incremente or decrement indentation
vnoremap <Tab> >gv| "Indent
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
nnoremap gp `[v`]
nnoremap <c-x><c-s> :w !sudo tee %<CR>
nnoremap ; :
nnoremap -<S-o> :vertical sbuffer 2<CR>
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
"inoremap <silent> hh <C-o>:stopinsert<CR>:s/\s\+$//e<CR>
inoremap <silent> qq <C-o>:stopinsert<CR>:s/\s\+$//e<CR>
cnoremap <C-a> <C-b>
cnoremap <C-h> <Left>
cnoremap <C-l> <Right>
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>
cnoremap qq <C-e><C-u><Esc>
cnoremap hh <C-e><C-u><Esc>
vnoremap <silent> qq <Esc>
nnoremap <silent> qq <Esc>
nnoremap <S-h> <C-w><Left>
nnoremap <S-l> <C-w><Right>
nnoremap <M-h> b
nnoremap <M-l> w
nnoremap * *N
"nnoremap n nzz
"nnoremap N Nzz
"}}}
"{{{ Move line
if has('nvim')
    nnoremap <M-k> :m--<CR>
    nnoremap <M-j> :m+<CR>
    vnoremap <M-k> :m '<-2<CR>gv=gv
    vnoremap <M-j> :m '>+1<CR>gv=gv
    vnoremap <M-h> d<left>Pgv<left>o<left>o
    vnoremap <M-l> dpgv<right>o<right>o
    vnoremap <S-k> <PageUp>
    vnoremap <S-j> <PageDown>
else " Vim does not support Meta
    vnoremap <S-k> :m '<-2<CR>gv=gv
    vnoremap <S-j> :m '>+1<CR>gv=gv
    vnoremap <S-h> <gv
    vnoremap <S-l> >gv
endif
"}}}
"{{{ system ClipBoard
if empty($DISPLAY)
    "TODO
    "vnoremap <C-x><C-c> y: call system("> /tmp/theClipboardWithoutX", getreg("\""))<CR>
    "nnoremap <C-x><C-v> :call setreg("\"", system("< /tmp/theClipboardWithoutX"))<CR>p
else
    if has('nvim')
        vnoremap <M-c> "+2yy
        vnoremap <M-x> "+dd
        nnoremap <M-v> "+P
        vnoremap <C-x><C-c> "+2yy
        nnoremap <C-x><C-v> "+P
        inoremap <M-v> <C-o>"+P
        cnoremap <M-v> <c-r>+
        vnoremap <M-v> d"+P | "Replace selection by last yank and keep previous yank
        " Copy fileName to clipboard
        nnoremap <silent> <M-y> :let @" = expand("%:p")<CR>: let @+ = @"<CR>
        nnoremap <silent> <C-x><C-y> :let @" = expand("%:p")<CR>: let @+ = @"<CR>
        nnoremap <silent> <M-y><M-y> :let @" = expand("%:p") . ":" . line(".")<CR>: let @+ = @"<CR>
    else
        "TODO: THIS DONT WORK and '<,'> is shitty on '<,'>:xclip....
        vnoremap <C-x><C-c> y: call system("xclip -i -selection clipboard", getreg("\""))<CR>
        nnoremap <C-x><C-v> :call setreg("\"",system("xclip -o -selection clipboard"))<CR>p
    endif
endif

nnoremap YY y$
nnoremap Yy y^
"}}}
"{{{ open terminal neovim only
nnoremap <space>k :topleft new<CR>:terminal<CR>
nnoremap <space>j :botright new<CR>:terminal<CR>
nnoremap <space>h :leftabove vnew<CR>:terminal<CR>
nnoremap <space>l :rightbelow vnew<CR>:terminal<CR>
"noremap <space><Tab> :tabnew<CR>:terminal<CR>
nnoremap <silent> <space>o :call OpenExplorer()<CR><CR>
nnoremap <space>n :execute "vsp $VIMFILES/note/" .expand("%") . ".note"<CR>
"}}}
noremap <S-z> :set fdm=syntax<CR>zR
"{{{ Resize Pane
noremap <S-right> :vertical resize +5<CR>
noremap <S-left> :vertical resize -5<CR>
noremap <S-up> 5<C-w>+
noremap <S-down> 5<C-w>-
"}}}
"{{{ Search and Replace
vnoremap <Space> :s/\s\+$//e<CR>|                               "Delete Extra white sapce from selection
vnoremap P <esc>:let @a = @"<cr>gvd"aP|                         "Yank selection and replace it by previous yank
vnoremap p "_dP|                                                "Replace selection by last yank and keep previous yank
vnoremap <C-r> "hy<ESC>:%s/<C-r>h/<C-r>h/gc<left><left><left>|  "Replace all selection
vnoremap <S-r> "hy<ESC>:%s/<C-r>h/<C-r>0/gc<left><left><left>|  "Replace all selection by last yank
nnoremap <space> :nohlsearch<CR>|                               "Stop hightliting search
nnoremap <c-r> yiw:%s/\<<C-R>"\>/<C-R>"/gc<left><left><left>|   "Replace word on cursor
cnoremap <C-r><C-r> <CR>:%s/<C-R>"/g<left><left>|               "Relplace word in yank buffer on all file
vnoremap <C-r><C-r> :s/<C-R>"/<C-R>"/g<left><left>|             "Relplace word in yank buffer on selected zone
vnoremap / "ay:let @a = "/" . escape(@a, '/')<CR>@a<CR>|        "Search selected Text
"}}}
"{{{ Leader Command
nnoremap <space>s :b#<CR>|                                            "Switch with previous buffer
nnoremap <space>d :w !diff -u % -<CR>|                                "Show current unsaved modification diff
nnoremap <space>D :DiffSaved<CR>|                                     "NOT WORKING AND IDK WTF IT IS
nnoremap <space>w :set wrap! wrap?<CR>|                               "Toggle long line wraping
nnoremap <space>e :set expandtab! expandtab?<CR>|                     "Toggle expandtab
nnoremap <space>b :call ToggleBinaryMode()<CR>|                       "Toggle hexa editing mode
nnoremap <space>r :so $MYVIMRC<CR>:nohlsearch<CR>|                    "Source $MYVIMRC
nnoremap <space>1 :call SwitchNargs(function('Switch_arg'))<CR>@a|    "Function argument switcher
nnoremap <space>2 :call SwitchNargs(function('Switch_argBack'))<CR>@a|"Revers Function argument switcher
nnoremap <space><S-r> VG:normal @r<CR>|                               "Repalce selection with yanked buffer
vnoremap <space>r :g/^/m0<CR>|                                        "Reverse the order of the selected line
"Open the current buffer in a new tab
nnoremap <space><Tab> :let @a = expand("%:p")<CR>:q<CR>:execute "tabedit " . @a<CR>
" Fix number of space between operand
vnoremap <silent><space>e :s/\s*\(\([+]\\|[=]\\|[-]\\|[&]\\|[\*]\\|[!]\)\+\)\s*/ \1 /ge<CR>:noh<CR>
"}}}
"{{{ Calcuation
    inoremap <C-q> <C-O>yiW<End><Esc>S<C-R>=<C-R>0<CR>|" delete line and replace it with arithmetic result
    nnoremap gbc <C-O>yiW<End><Esc>S<C-R>=<C-R>0<CR>|" delete line and replace it with arithmetic result
    nnoremap gbs <C-O>yiW<End>=<C-R>=<C-R>0<CR>|" Add arithmetic result of the line at the end with an = sign
"}}}
"{{{ colemak
let g:colemak_remap = [
\['n', 'h'],
\['e', 'j'],
\['i', 'k'],
\['o', 'l']
\]
function! EnableColemak()
    call SwapKeys(g:colemak_remap)
    let g:NERDTreeMapOpenSplit = "<S-s>"
    let g:NERDTreeMapOpenExpl = "<S-e>"
    let gNERDTreeMapActivateNode = "<S-y>"
    noremap <S-n> <C-w><Up>
    noremap <S-e> <C-w><Down>
    noremap <S-i> <C-w><left>
    noremap <S-o> <C-w><right>
endfunction
function! DisableColemak()
    call SwapBackKeys(g:colemak_remap)
    let g:NERDTreeMapOpenSplit = "s"
    let g:NERDTreeMapOpenExpl = "e"
    let gNERDTreeMapActivateNode = "o"
    noremap <S-n> <S-n>
    noremap <S-e> <S-e>
    noremap <S-i> <S-i>
    noremap <S-o> <S-o>
endfunction

function! SwapKeys(mappings)
    for mapping in a:mappings
        execute "nnoremap ".mapping[0] ." ".mapping[1]
        execute "nnoremap ".mapping[1] ." ".mapping[0]
        execute "vnoremap ".mapping[0] ." ".mapping[1]
        execute "vnoremap ".mapping[1] ." ".mapping[0]

        execute "nnoremap <S-".mapping[0] ."> <S-".mapping[1].">"
        execute "nnoremap <S-".mapping[1] ."> <S-".mapping[0].">"
        execute "vnoremap <S-".mapping[0] ."> <S-".mapping[1].">"
        execute "vnoremap <S-".mapping[1] ."> <S-".mapping[0].">"
    endfor
endfunction

function! SwapBackKeys(mappings)
    for mapping in a:mappings
        execute "nnoremap ".mapping[1] ." ".mapping[1]
        execute "nnoremap ".mapping[0] ." ".mapping[0]
        execute "vnoremap ".mapping[1] ." ".mapping[1]
        execute "vnoremap ".mapping[0] ." ".mapping[0]

        execute "nnoremap <S-".mapping[0] ."> <S-".mapping[1].">"
        execute "nnoremap <S-".mapping[1] ."> <S-".mapping[1].">"
        execute "vnoremap <S-".mapping[0] ."> <S-".mapping[0].">"
        execute "vnoremap <S-".mapping[1] ."> <S-".mapping[1].">"
    endfor
endfunction

"}}}
nnoremap <silent> <space>p :call CopyPasteMode()<CR>
function! CopyPasteMode()
    if !exists('b:paste_mode') | let b:paste_mode = 0 | endif
    if b:paste_mode == 0
        :setlocal mouse=i
        :setlocal nonumber
        :setlocal nolist
        :setlocal paste
        let b:paste_mode = 1
    else
        :setlocal mouse=a
        :setlocal number
        :setlocal list
        :setlocal nopaste
        let b:paste_mode = 0
    endif
endfunction
"vmap <C-Right> xpgvlolo
"vmap <C-left> xhPgvhoho
"vmap <C-Down> xjPgvjojo
"vmap <C-Up> xkPgvkoko

" Scrollwheel
nnoremap <S-ScrollWheelUp> <ScrollWheelLeft>
nnoremap <S-ScrollWheelDown> <ScrollWheelRight>
nnoremap <S-2-ScrollWheelDown> <2-ScrollWheelRight>
nnoremap <S-3-ScrollWheelDown> <3-ScrollWheelRight>
nnoremap <S-4-ScrollWheelDown> <4-ScrollWheelRight>

nnoremap <c-k> p^f"l<c-a>yy==
" instantly select the first autocomplet choice
inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
            \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

map! <F3> <C-R>=strftime('%c')<CR>
nnoremap <F5> :checktime<CR>
augroup Refresh
    autocmd FocusGained * checktime
    autocmd BufEnter * checktime
augroup END
"{{{ GUI
nnoremap <silent> <space>- :call GuiZoom(-1)<CR>
nnoremap <silent> <space>= :call GuiZoom(1)<CR>
nnoremap <silent> <C--> :call GuiZoom(-1)<CR>
nnoremap <silent> <C-=> :call GuiZoom(1)<CR>
nnoremap <silent> <C-+> :call GuiZoom(1)<CR>
nnoremap <silent> <C-ScrollWheelDown> :call GuiZoom(-1)<CR>
nnoremap <silent> <C-ScrollWheelUp> :call GuiZoom(1)<CR>
"}}}
"{{{ Embeded terminal remap
if has('nvim')
    tmap <Esc> <Plug>EditCommand
    tnoremap <M-v> <Esc>"+p<insert>
    tnoremap '' ''<Left>
    tnoremap "" ""<Left>
    tnoremap () ()<Left>
    tnoremap [] []<Left>
    tnoremap <> <><Left>
    tnoremap qq <C-\><C-n>
    augroup TermGroup
       au TermOpen * setlocal nonumber
    augroup END
endif
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
autocmd BufEnter * silent! execute "normal! :setlocal sidescrolloff=" . winwidth(0) / 8 . "\r"
autocmd bufreadpre *.md setlocal textwidth=80
autocmd FileType cpp map! <F4> std::cout << __func__<< " line:" << __LINE__ << std::endl;
autocmd FileType cpp map! <F5> std::cout << __func__<< " msg:" <<  << std::endl;<Esc>13<Left><insert>""
autocmd FileType cpp inoremap <buffer> \n  <space><< std::endl;
autocmd FileType c map! <F4> printf( __func__" line:"__LINE__"\n");
autocmd FileType c map! <F5> printf(__func__" \n");<Esc>4<Left><insert>
autocmd FileType php map! <F4> print_r("file: ".__FILE__."line: ".__LINE__);
autocmd FileType php map! <F5> print_r("file: ".__FILE__."line: ".__LINE__.''<Right>);<Esc>2<Left><insert>
autocmd FileType lua nnoremap <F4> "="print('Line at '..debug.getinfo(2, 'l').currentline..', FILE at '..debug.getinfo(2, 'S').source..', in func: '..debug.getinfo(2, 'n').name)"<CR>p
autocmd FileType vim set fdm=marker
autocmd! BufRead,BufNewFile *.markdown set filetype=markdown
autocmd! BufRead,BufNewFile *.md       set filetype=markdown
"autocmd FileType cpp set fdm=indent
"autocmd FileType c set fdm=indent
autocmd BufRead,BufNewFile *.conf setfiletype dosini

highlight ExtraCarriageReturn ctermbg=red gui=bold,undercurl guifg=#ababcc "guibg=#000000
highlight ExtraWhitespace ctermbg=red gui=bold,undercurl guifg=#ab4444 "guibg=#000000
highlight ExtraSpaceDwich ctermbg=red gui=bold,undercurl guifg=#997744 "guibg=#000000
highlight NonBreakSpace gui=bold,undercurl guifg=#ff0000 ctermfg=red
highlight EmptyChar gui=bold,undercurl guifg=#ff0055 guibg=#777777 ctermfg=red
highlight currawong ctermbg=darkred guibg=darkred
augroup WhitespaceMatch
    " Remove ALL autocommands for the WhitespaceMatch group.
    autocmd!
    autocmd BufWinEnter * let w:whitespace_match_number =
                \ matchadd('ExtraWhitespace', '\s\+$')
    autocmd BufWinEnter * let w:spacedwich_match_number =
                \ matchadd('ExtraSpaceDwich', ' \t\|\t ')
    autocmd BufWinEnter * let w:CRLF =
                \ matchadd('ExtraCarriageReturn', '\r')
    autocmd BufWinEnter * let w:NonBreakSpace =
                \ matchadd('NonBreakSpace', ' ')
                                                           "digraph section
    autocmd BufWinEnter * exec matchadd('EmptyChar', ' ')| "1N 
    autocmd BufWinEnter * exec matchadd('EmptyChar', ' ')| "1M 
    autocmd BufWinEnter * exec matchadd('EmptyChar', ' ')| "3M 
    autocmd BufWinEnter * exec matchadd('EmptyChar', ' ')| "4M 
    autocmd BufWinEnter * exec matchadd('EmptyChar', ' ')| "6M 
    autocmd BufWinEnter * exec matchadd('EmptyChar', ' ')| "1T 
    autocmd BufWinEnter * exec matchadd('EmptyChar', ' ')| "1H 
    autocmd BufWinEnter * exec matchadd('EmptyChar', '　')|"IS　
augroup END

augroup Backup
    " set backup file prefix with current time at vim startup
    autocmd VimEnter * let &bex = '-' . strftime("%Y%m%d%H%M") . '~'
augroup END

augroup XML
    autocmd!
    "autocmd FileType xml setlocal foldmethod=indent foldnestmax=100
augroup END
"}}}
"{{{ Function
function! ToggleBinaryMode() "{{{ TODO: Tidy up
    if b:isBinary == 0
        :%!xxd
        let b:isBinary = 1
    else
        :%!xxd -r
        let b:isBinary = 0
    endif
endfunction
"}}}
function! CleanEmptyBuffers() "{{{ TODO: Tidy up
    let buffers = filter(range(0, bufnr('$')), 'buflisted(v:val) && empty(bufname(v:val)) && bufwinnr(v:val)<0')
    if !empty(buffers)
        exe 'bw '.join(buffers, ' ')
    endif
endfunction
"}}}
command! Ifndef call Insert_ifndef() "{{{ TODO: Tidy up
function! Insert_ifndef() 
    let l:filename = substitute(toupper(expand("%:t")), "\\.", "_", "g")
    0put = '#ifndef ' . l:filename
    1put = '# define ' . l:filename
    2put = ''
    $put = '#endif /* ' . l:filename . ' */'
endfunction
"}}}
"{{{ Switch function argument
function! Switch_arg(nb)
    let l:c = 1
    let l:str = ":s/(\\s*\\(.*\\)"

    while l:c <= a:nb
        let l:str = join([l:str, ",\\s*\\(.*\\)"], "")
        let l:c += 1
    endwhile
    let l:str = join([l:str, "\\s*)"], "")
    let l:c = 1
    let l:str = join([l:str, "/(\\1"], "")
    while l:c <= a:nb
        let l:str = join([l:str, ", \\", l:c+1], "")
        let l:c += 1
    endwhile
    let l:str = join([l:str, ")/g|:nohlsearch" . repeat("\x80kl", 15)], "")
    let @a = l:str
endfunction

function! Switch_argBack(nb)
    let l:c = 1
    let l:str = ":s/(\\s*\\(.*\\)"

    while l:c <= a:nb
        let l:str = join([l:str, ",\\s*\\(.*\\)"], "")
        let l:c += 1
    endwhile
    let l:str = join([l:str, "\\s*)"], "")
    let l:c = a:nb + 1
    let l:str = join([l:str, "/(\\" . l:c], "")
    while l:c > 1
        let l:str = join([l:str, ", \\", l:c-1], "")
        let l:c -= 1
    endwhile
    let l:str = join([l:str, ")/g|:nohlsearch" . repeat("\x80kl", 15)], "")
    let @a = l:str
endfunction

function! SwitchNargs(fun)
    let l:str = matchstr(getline('.'), '\w\+\s*(.*)')
    if empty(l:str)
        echomsg "No Function found"
    else
        call a:fun(CountChar(l:str, ','))
    endif
endfunction
"}}}
"{{{TODO: Tidy up and clean
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

function! StartBench()
    execute "profile start " . $HOME . "/profile.log"
    :profile func *
    :profile file *
endfunction

function! StopBench()
    :profile pause
    :noautocmd qall!
endfunction
"}}}
command! JsonIndent call JsonIndent() "{{{
function! JsonIndent()
    "execute '%!python -m json.tool'
	execute ':%!jq "."'
endfunction
command! JsonIndentSort call JsonIndentSort() "{{{
function! JsonIndentSort()
    execute ':%!jq --sort-keys "."'
    execute ':%!jq "walk(if type == \"array\" then sort else . end)"'
endfunction
command! JsonIndentMimify call JsonIndentMimify() "{{{
function! JsonIndentMimify()
	execute ':%!jq -c "."'
endfunction

command! YamlIndent call YamlIndent() "{{{
function! YamlIndent()
    "execute '%!python -m json.tool'
	execute ':%!yq -y "."'
endfunction
command! YamlIndentSort call YamlIndentSort() "{{{
function! YamlIndentSort()
	execute ':%!yq -y --sort-keys "."'
endfunction
command! YamlIndentMimify call YamlIndentMimify() "{{{
function! YamlIndentMimify()
	execute ':%!yq -y -c "."'
endfunction

"}}}
function! XmlIndent() " {{{
    if !executable('xmllint')
        echomsg "No xmllint found !"
        return
    endif
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
command! XmlIndent call XmlIndent()
"}}}
function! OpenExplorer() "{{{
    let l:open = GetExplorer()
    if l:open != 'none'
        execute "!". l:open . " ."
    else
        echomsg "/!\\ No Explorer Provided /!\\"
    endif
endfunction

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
        return 'explorer'
    endif
    return 'none'
endfunction
"}}}
function! GuiZoom(indice) "{{{
    let l:split = split(g:GuiFont, ':')
    let l:font = l:split[0]
    let l:size = split(l:split[1], 'h')[0]
    execute "GuiFont! " . l:font . ":h" . (l:size + a:indice)
endfunction
"}}}

function! BreakHabits()
    nnoremap hh <NOP>
    nnoremap jj <NOP>
    nnoremap kk <NOP>
    nnoremap ll <NOP>
    inoremap <ESC> <NOP>
endfunction

function! MgetTime() "{{{ Open Scratch Buffer <space>S
    return strftime("%y%m%d-%H%M%S")
endfunction
nnoremap <space>S :Snippets<CR>
"}}}
function! SaveSess()
    execute 'mksession! ' . $HOME . '/.vim/session.vim'
endfunction

function! RestoreSess()
    execute 'so ' . $HOME . '/.vim/session.vim'
    if bufexists(1)
        for l in range(1, bufnr('$'))
            if bufwinnr(l) == -1
                exec 'sbuffer ' . l
            endif
        endfor
    endif
endfunction

function! SaveSessQuit()
    call SaveSess()
    :qa!
endfunction
command! Leave call SaveSessQuit()
command! Back call RestoreSess()

function! CountChar(string, char)
    let l:i = 0
    let l:count = 0
    while (i < len(a:string))
        if a:string[i] == a:char
            let l:count += 1
        endif
        let l:i += 1
    endwhile
    return l:count
endfunction

function! s:DiffWithSaved()
    let filetype=&ft
    diffthis
    vnew | r # | normal! 1Gdd
    diffthis
    exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

function! s:MoveBlockMapping()
    let b:visualMove *= -1
    if b:visualMove == 1
        vnoremap <buffer> k koko
        vnoremap <buffer> j jojo
        vnoremap <buffer> h hoho
        vnoremap <buffer> l lolo
        vnoremap <buffer> gk gkogko
        vnoremap <buffer> gj gjogjo
    else
        vnoremap <buffer> k k
        vnoremap <buffer> j j
        vnoremap <buffer> h h
        vnoremap <buffer> l l
        vnoremap <buffer> gk gk
        vnoremap <buffer> gj gj
    endif
endfunction
com! -nargs=? ToggleMoveVisual call s:MoveBlockMapping(<f-args>)
nnoremap <silent> v :let b:visualMove = 1<CR>:ToggleMoveVisual<CR>v
nnoremap <silent> gv :let b:visualMove = 1<CR>:ToggleMoveVisual<CR>gv
nnoremap <silent> gn :let b:visualMove = 1<CR>:ToggleMoveVisual<CR>gn
vnoremap <silent> v <ESC>:ToggleMoveVisual<CR>gv
let g:useFullRegex = { 'Make upper case letter after get and set':'/\(\(g\|s\)et\)\(\w\)/\1\u\3/gc',
            \ 'New line on coma':'/,/,\r/gc',
            \ 'Remove space':'/ //gc'
            \ }
function! GetRegex(key)
    let @a=get(g:useFullRegex, a:key, 'NOPE')
    echo "use @a or ^ra to spawn the regex"
endfunction
com! Regex call GetRegex()
function! SelectRegex()
    :call fzf#run({'down': '30%', 'source': keys(g:useFullRegex), 'sink': function('GetRegex')})
endfunction
com! SelectRegex call SelectRegex()
nnoremap <space>f :SelectRegex<CR>

function! MoveToPrevTab()
    "there is only one window
    if tabpagenr('$') == 1 && winnr('$') == 1
        return
    endif
    "preparing new window
    let l:tab_nr = tabpagenr('$')
    let l:cur_buf = bufnr('%')
    if tabpagenr() != 1
        close!
        if l:tab_nr == tabpagenr('$')
            tabprev
        endif
        sp
    else
        close!
        exe "0tabnew"
    endif
    "opening current buffer in new window
    exe "b".l:cur_buf
endfunc

function! MoveToNextTab()
    "there is only one window
    if tabpagenr('$') == 1 && winnr('$') == 1
        return
    endif
    "preparing new window
    let l:tab_nr = tabpagenr('$')
    let l:cur_buf = bufnr('%')
    if tabpagenr() < tab_nr
        close!
        if l:tab_nr == tabpagenr('$')
            tabnext
        endif
        sp
    else
        close!
        tabnew
    endif
    "opening current buffer in new window
    exe "b".l:cur_buf
endfunc

nnoremap <A-.> :call MoveToNextTab()<CR>
nnoremap <A-,> :call MoveToPrevTab()<CR>

nnoremap <F3> :call ChangeSpell()<CR>
function! ChangeSpell(...)
    if !exists('b:spell') | let b:spell = 0 | endif
    if b:spell == 0
        setlocal spell spelllang=en
        echomsg "spell en"
    elseif b:spell == 1
        setlocal spell spelllang=fr
        echomsg "spell fr"
    else
        setlocal nospell
        echomsg "nospell"
    endif
    let b:spell +=1
    let b:spell = b:spell % 3
endfunction

"}}}
"}}}
"{{{ Checkout previous line's commit
function! GetCurrentLineCommit()
    let @a = system('git --no-pager blame -L ' . line(".") . ',+1 -- ' . expand('%:p'))
    return matchstr(@a, '\w\+')
endfunction

function! GetCurrentCommit()
    return system('git rev-parse --short HEAD')
endfunction

function! CheckoutPreviousCommitLine()
    let l:commit = GetCurrentLineCommit() . "^"
    let l:current_commit = GetCurrentCommit()
    if !exists('g:commit_list') | let g:commit_list = [] | endif
    call add(g:commit_list, l:current_commit)
    call system('git checkout ' . l:commit)
    checktime
endfunction

function! CheckoutPreviousCommitLineRevert()
    if len(g:commit_list) > 0
        let l:commit = g:commit_list[-1:-1][0]
        let g:commit_list = g:commit_list[0:-2]
        call system('git checkout ' . l:commit)
        checktime
    endif
endfunction
"}}}

"}}}
