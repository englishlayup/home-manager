set nocompatible                " disable compatibility to old-time vi
set tabstop=4                   " number of columns occupied by a tab 
set softtabstop=4               " see multiple spaces as tabstops so <BS> does the right thing
set noerrorbells                " don't deafen me
set expandtab                   " converts tabs to white space
set shiftwidth=4                " width for autoindents
set autoindent                  " indent a new line the same amount as the line just typed
set relativenumber              " add relative line numbers
set number                      " show line number of current line
set wildmode=list:longest       " get bash-like tab completions
set colorcolumn=81              " set an 80 column border for good coding style
set signcolumn=yes              " add an extra column to the left
filetype plugin indent on       " allow auto-indenting depending on file type
syntax on                       " syntax highlighting
filetype plugin on
set mouse=                      " disable mouse click
set cursorline                  " highlight current cursorline
set ttyfast                     " Speed up scrolling in Vim
set scrolloff=10                " Keep cursor more centered while scrolling
set ignorecase                  " case insensitive 
set smartcase                   " Override the ignorecase option if searching for capital letters. This will allow you to search specifically for capital letters.
set showmatch                   " show matching 
set nohlsearch                  " no highlight search 
set incsearch                   " incremental search
set showcmd                     " Show partial command you type in the last line of the screen.
set updatetime=50
set nobackup
set noswapfile
set undofile
let mapleader = " "

" FINDING FILES:

" Search down into subfolders
" Provides tab-completion for all file-related tasks
set path+=**

" Display all matching files when we tab complete
set wildmenu
set wildignore+=**/node_modules/**
set wildignore+=.hg,.git,.svn                       " Version control 
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg      " binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest    " compiled object files
set wildignore+=*.pyc                               " Python byte code
" NOW WE CAN:
" - Hit tab to :find by partial match
" - Use * to make it fuzzy

" THINGS TO CONSIDER:
" - :b lets you autocomplete any open buffer

" FILE BROWSING:

" Tweaks for browsing
let g:netrw_banner=0        " disable annoying banner
let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'

" NOW WE CAN:
" - :edit a folder to open a file browser
" - <CR>/v/t to open in an h-split/v-split/tab
" - check |netrw-browse-maps| for more mappings

" Hard Mode
nnoremap <Left> :echo "Arrow keys are disabled"<CR>
vnoremap <left> :<C-u>echo "Arrow keys are disabled"<CR>
inoremap <Left> <C-o>:echo "Arrow keys are disabled"<CR>
nnoremap <Right> :echo "Arrow keys are disabled"<CR>
vnoremap <Right> :<C-u>echo "Arrow keys are disabled"<CR>
inoremap <Right> <C-o>:echo "Arrow keys are disabled"<CR>
nnoremap <Up> :echo "Arrow keys are disabled"<CR>
vnoremap <Up> :<C-u>echo "Arrow keys are disabled"<CR>
inoremap <Up> <C-o>:echo "Arrow keys are disabled"<CR>
nnoremap <Down> :echo "Arrow keys are disabled"<CR>
vnoremap <Down> :<C-u>echo "Arrow keys are disabled"<CR>
inoremap <Down> <C-o>:echo "Arrow keys are disabled"<CR>

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
