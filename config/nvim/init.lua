-- number settings
vim.o.scrolloff = 10                 -- scroll terminal when cursor is N line from the top or botom
vim.o.showtabline = 1                -- Enable tabline
vim.o.numberwidth = 1                -- Minimum number column size
vim.o.tabstop = 4                    -- Redefine tab display as n space
vim.o.softtabstop = 4
vim.o.shiftwidth = 4                 -- Number of spaces to use for each step of (auto)indent
vim.o.laststatus = 2                 -- Always show status line
vim.o.cmdheight = 1                  -- Number of screen lines to use for the command-line
vim.o.history = 10000                -- A history of ":" commands, and a history of previous search patterns is remembered
vim.o.sidescroll = 1                 -- The minimal number of columns to scroll horizontally
vim.o.sidescrolloff = 10             -- scroll terminal when cursor is N line from the left or right
vim.o.scrolloff = 10                 -- scroll terminal when cursor is N line from the top or botom
vim.o.timeoutlen = 300               -- scroll terminal when cursor is N line from the top or botom

-- boolean settings
vim.o.endofline = false                  -- No <EOL> will be written for the last line in the file
vim.o.number = true                      -- Display line number
vim.o.relativenumber = true              -- Display line number
vim.o.cursorline = true                  -- Highlight current line
vim.o.expandtab = true                   -- Use muliple space instead of tab
vim.o.autoindent = true                  -- Copy indent from current line when starting a new line
vim.o.smartindent = true                 -- Do smart autoindenting when starting a new line
vim.o.autoread = true                    -- Change file when editing from the outside
vim.o.hlsearch = true                    -- Highligth search
vim.o.ignorecase = true                  -- Case insensitive
vim.o.smartcase = true                   -- Override the 'ignorecase' option if the search pattern contains upper case characters
vim.o.wildmenu = true                    -- Pop menu when autocomplete command
vim.o.wildignorecase = true              -- Ignore case for command completion
vim.o.infercase = true                   -- IDK just testing this option
vim.o.autochdir = true                   -- Auto change directories of file
vim.o.wrap = false                       -- Don't warp long line
vim.o.linebreak = true                   -- Break at a word boundary
vim.o.lazyredraw = true                  -- Redraw only when we need to.
vim.o.incsearch = true                   -- While typing a search command, show where the pattern is
vim.o.swapfile = false                   -- Don't use swapfile for the buffer
vim.bo.swapfile = false                  -- Don't use swapfile for the buffer
vim.o.ruler = true                       -- Show the line and column number of the cursor position
vim.o.undofile = true                    -- Use undofile
vim.o.backup = false                     -- Make a backup before overwriting a file.
vim.o.list = true                        -- Enable listchars
vim.o.conceallevel = 2

vim.o.syntax='on'
vim.opt.whichwrap:append('<,>,h,l,[,]')       -- Move cursor to next/previous line when reach end and begin of line
--vim.o.wildmode=longest:full,full   -- Widlmenu option
vim.o.virtualedit='onemore'          -- Allow normal mode to go one more charater at the end
--vim.o.mouse=a                      -- Set mouse for all mode
vim.opt.display:append('uhex,lastline')       -- Change the way text is displayed. uhex: Show unprintable characters hexadecimal as <xx>
--vim.o.undodir=vim.env['HOME']/.vim/undo      -- Undofile location
--vim.o.backupdir=vim.env['HOME']/.vim/backup  -- List of directories for the backup file, separated with commas.
--vim.o.completeopt=menuone,menu,longest,preview -- Change <ctrl+n> behavior see :h completeopt

vim.api.nvim_create_autocmd(
"VimEnter",
{ callback = function()
    if vim.fn.expand('%') == 'init.lua' then
        vim.opt.foldmethod = "marker"
    end
end}
)
-- {{{ Auto command
-- {{{ Wrong whitespace
vim.cmd(
[[
" red highlight color for every whitechar issue
highlight ExtraCarriageReturn ctermbg=red
highlight ExtraWhitespace ctermbg=red
highlight ExtraSpaceDwich ctermbg=red
highlight NonBreakSpace ctermbg=yellow
highlight EmptyChar ctermfg=red ctermbg=red
highlight currawong ctermbg=darkred guibg=darkred
]])

local wrongwhitespace = vim.api.nvim_create_augroup('wrongwhitespace', {clear = true})
local ac = vim.api.nvim_create_autocmd 
-- Highlight white space at end of line
ac("BufWinEnter", {group=wrongwhitespace, command="exec matchadd('ExtraWhitespace', '\\s\\+$')"})
-- Highlight mixed tab and space
ac("BufWinEnter", {group=wrongwhitespace, command="exec matchadd('ExtraSpaceDwich', ' \\t\\|\\t ')"})
-- Highlight windows \r
ac("BufWinEnter", {group=wrongwhitespace, command="exec matchadd('ExtraCarriageReturn', '\\r')"})
-- Highlight non breaking space
ac("BufWinEnter", {group=wrongwhitespace, command="exec matchadd('NonBreakSpace', ' ')"})
ac("BufWinEnter", {group=wrongwhitespace, command="exec matchadd('EmptyChar', ' ')"})
ac("BufWinEnter", {group=wrongwhitespace, command="exec matchadd('EmptyChar', ' ')"})
ac("BufWinEnter", {group=wrongwhitespace, command="exec matchadd('EmptyChar', ' ')"})
ac("BufWinEnter", {group=wrongwhitespace, command="exec matchadd('EmptyChar', ' ')"})
ac("BufWinEnter", {group=wrongwhitespace, command="exec matchadd('EmptyChar', ' ')"})
ac("BufWinEnter", {group=wrongwhitespace, command="exec matchadd('EmptyChar', ' ')"})
ac("BufWinEnter", {group=wrongwhitespace, command="exec matchadd('EmptyChar', ' ')"})
ac("BufWinEnter", {group=wrongwhitespace, command="exec matchadd('EmptyChar', '　')"})
--}}}
--}}}

-- {{{ lua conversion needed
vim.api.nvim_exec(
[[
" ZZ is the default keybinding for :wq
" Here i add ZS key bind to save current file as root
" I find this on slack, here more info on how it's work
" silent! will disable the command output and therefore no prompt will be displayed
" write is juste like :w
" !sudo tee % > /dev/null is use to write the file as root
" <bar> is to split this command to next execute edit in order to reread the
" file from vim nnoremap <S-z><S-s> :execute 'silent! write !sudo tee % >/dev/null' <bar> edit!<CR>
"git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

if filereadable('~/.local/share/nvim/site/pack/packer/start/packer.nvim') == 0 && executable('git')
    silent execute ":!mkdir -p " . '~/.local/share/nvim/site/pack/packer/start/'
    silent execute ":!git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim"
endif

]],
true)
local remap = vim.api.nvim_set_keymap
-- }}}
vim.cmd [[packadd packer.nvim]]
require('packer').startup(function()
use {
    --"ThePrimeagen/refactoring.nvim",
    "lguarda/refactoring.nvim",
    requires = {
        {"nvim-lua/plenary.nvim"},
        {"nvim-treesitter/nvim-treesitter"},
        {"nvim-treesitter/playground"},
    }
}
use {
  'nvim-telescope/telescope.nvim',
  requires = { {'nvim-lua/plenary.nvim'} }
}
use {
  'phaazon/hop.nvim',
  branch = 'v2', -- optional but strongly recommended
  config = function()
    local hop = require('hop')
    hop.setup { keys = 'etovxqpdygfblzhckisuran' }
    local directions = require('hop.hint').HintDirection
    vim.keymap.set('', 'f', function()
        hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
    end, {remap=true})
    vim.keymap.set('', 'F', function()
        hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
    end, {remap=true})
    end
}
--[[
require('refactoring').setup({
    -- prompt for return type
    prompt_func_return_type = {
        go = true,
        cpp = true,
        c = true,
        java = true,
    },
    -- prompt for function parameters
    prompt_func_param_type = {
        go = true,
        cpp = true,
        c = true,
        java = true,
    },
})
--]]
end)

require "nvim-treesitter.configs".setup {
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = false, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  }
}

--vim.api.nvim_set_keymap("v", "<space>re", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]], {noremap = true, silent = true, expr = false})
--vim.api.nvim_set_keymap("v", "<space>rf", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]], {noremap = true, silent = true, expr = false})
--vim.api.nvim_set_keymap("v", "<space>rv", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]], {noremap = true, silent = true, expr = false})
--vim.api.nvim_set_keymap("v", "<space>ri", [[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]], {noremap = true, silent = true, expr = false})

-- Inline variable can also pick up the identifier currently under the cursor without visual mode
--vim.api.nvim_set_keymap("n", "<space>ri", [[ <Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]], {noremap = true, silent = true, expr = false})

-- load refactoring Telescope extension
require("telescope").load_extension("refactoring")

-- remap to open the Telescope refactoring menu in visual mode
vim.api.nvim_set_keymap(
	"v",
	"<space>rr",
	"<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
	{ noremap = true }
)

vim.api.nvim_set_keymap("n", "<space>m", ":Telescope oldfiles<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<space>r", ":source $MYVIMRC<CR>", { noremap = true, silent = true })
--vim.api.nvim_set_keymap("n", "jj", "<nop>", { noremap = true, silent = true })
--vim.api.nvim_set_keymap("n", "ll", "<nop>", { noremap = true, silent = true })
--vim.api.nvim_set_keymap("n", "kk", "<nop>", { noremap = true, silent = true })
--vim.api.nvim_set_keymap("n", "hh", "<nop>", { noremap = true, silent = true })
