" Colors
syntax on           " enable syntax processing
set background=dark
set t_Co=256
" Tabs
set tabstop=2       " number of visual spaces per TAB
set softtabstop=2   " number of spaces in tab when editing
set expandtab       " tabs are spaces
set ai              " Auto indent
set si              " Smart indent
set wrap            " Word wrap
" UI
set cursorline      " highlight current line
filetype plugin indent on  " load filetype-specific indent files
set showmatch       " highlight matching [{()}]
:hi MatchParen cterm=bold ctermbg=black ctermfg=red " highlight matching parens differently
set wildmenu        " autocomplete menu
set cmdheight=2     " height of command bar
set ruler           " show current position
set lazyredraw      " redraw only when needed
set laststatus=2    " Show status line
"Search
set hlsearch        " highlight matches
set incsearch       " search as characters are entered
set history=700     " lines of history to keep
set ignorecase      " ignore case when searching
set smartcase       " smart case searching
"General
set autoread        " Set to autoread when file is changed from the outside
set encoding=utf8   " Set defualt encoding
set ffs=unix,dos,mac  " Set default file type
set backspace=indent,eol,start  "Allow backspace in insert mode
set noswapfile      " Turn off backups etc
set nobackup        "
set nowb            "
set paste
set number

" Return to last edit position when opening files
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
" Remember info about open buffers on close
set viminfo^=%

" Status line
set statusline=\ %F                                   " Full path & file
set statusline+=\ %r%y[%{&ff}]                        " RO flag, filetype & file format (dos,unix etc)
set statusline+=[%{strlen(&fenc)?&fenc:'none'}]       " Encoding
set statusline+=%=                                    " right align
set statusline+=Line[%l/%L]                           " Line of lines
set statusline+=\ Col[%v]                             " Column
set statusline+=\ \|\ %{strftime(\"%Y%m%d\-%H:%M\")}  " Date & time
