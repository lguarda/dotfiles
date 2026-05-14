-- UI / appearance
vim.o.number         = true                     -- Display line number
vim.o.relativenumber = true                     -- Display line number relative to cursor
vim.o.cursorline     = true                     -- Highlight current line
vim.o.numberwidth    = 1                        -- Minimum number column size
vim.o.signcolumn     = "auto"                   -- Only display sign column when there something (gitsign)
vim.o.showtabline    = 1                        -- Enable tabline
vim.o.laststatus     = 3                        -- Always show status line
vim.o.cmdheight      = 0                        -- Hide cmd line when not used
vim.o.showcmd        = true                     -- Show key cmd
vim.o.showcmdloc     = "statusline"             -- In status line (to replace ruler)
vim.o.ruler          = false                    -- Show the line and column number of the cursor position
vim.o.wrap           = false                    -- Don't warp long line
vim.o.linebreak      = true                     -- Break at a word boundary
vim.o.winborder      = "rounded"                -- Floating window border type
vim.g.netrw_banner   = 0                        -- remove netrw banner for cleaner looking
require('vim._core.ui2').enable()

-- Indentation & whitespace
vim.o.expandtab      = true                     -- Use muliple space instead of tab
vim.o.tabstop        = 4                        -- Redefine tab display as n space
vim.o.softtabstop    = 4
vim.o.shiftwidth     = 4                        -- Number of spaces to use for each step of (auto)indent
vim.o.autoindent     = true                     -- Copy indent from current line when starting a new line
vim.o.smartindent    = true                     -- Do smart autoindenting when starting a new line
vim.o.list           = true                     -- Enable listchars
vim.o.endofline      = false                    -- No <EOL> will be written for the last line in the file
vim.o.fixendofline   = false                    -- Don't automaticaly add new line at end of file

-- Search
vim.o.hlsearch       = true                     -- Highligth search
vim.o.incsearch      = true                     -- While typing a search command, show where the pattern is
vim.o.ignorecase     = true                     -- Case insensitive
vim.o.smartcase      = true                     -- Override the 'ignorecase' option if the search pattern contains upper case characters

-- Completion & wildmenu
vim.o.completeopt    = "menu,menuone,popup,fuzzy" -- modern completion menu
vim.o.wildmenu       = true                     -- Pop menu when autocomplete command
vim.o.wildignorecase = true                     -- Ignore case for command completion
vim.o.infercase      = true                     -- IDK just testing this option

-- Folding
vim.o.foldenable     = true                     -- enable fold
vim.o.foldlevel      = 99                       -- start editing with all folds opened
vim.o.foldmethod     = "expr"                   -- use tree-sitter for folding method
vim.o.foldexpr       = "v:lua.vim.treesitter.foldexpr()"

-- Scrolling & cursor movement
vim.o.scrolloff      = 10                       -- scroll terminal when cursor is N line from the top or botom
vim.o.sidescroll     = 1                        -- The minimal number of columns to scroll horizontally
vim.o.sidescrolloff  = 10                       -- scroll terminal when cursor is N line from the left or right
vim.o.virtualedit    = "onemore"                -- Allow normal mode to go one more charater at the end
vim.opt.whichwrap:append("<,>,[,],h,l")         -- Move cursor to next/previous line when reach end and begin of line

-- Files, undo & backup
vim.o.autoread       = true                     -- Change file when editing from the outside
vim.o.autochdir      = true                     -- Auto change directories of file
vim.o.swapfile       = false                    -- Don't use swapfile for the buffer
vim.o.undofile       = true                     -- Use undofile
vim.o.backup         = true                     -- Make a backup before overwriting a file.
vim.o.backupdir      = vim.fn.stdpath('state') .. '/backup//'

-- Misc
vim.o.timeoutlen     = 300                      -- scroll terminal when cursor is N line from the top or botom
vim.o.history        = 10000                    -- A history of ":" commands, and a history of previous search patterns is remembered
vim.o.mouse          = ""                       -- Disable mouse for all mode
vim.o.mousemoveevent = false
vim.o.syntax         = "off"
vim.opt.display:append("uhex,lastline")         -- Change the way text is displayed. uhex: Show unprintable characters hexadecimal as <xx>


-- This is used to have timestamped backup file
vim.api.nvim_create_autocmd("VimEnter", {
    pattern = "*",
    command = "let &bex = '-' . strftime(\"%Y%m%d%H%M\") . '~'",
})
