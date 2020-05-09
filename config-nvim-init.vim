" Set <leader> at the very beginning.
let mapleader=" "
let maplocalreader=" "

" Make this file more readable by enabling code folding.
augroup filetype_vim
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
augroup END

set textwidth=100
let &colorcolumn = join(range(101, 300), ",")

""""""""""""""""""""""
" Installing Plugins "
""""""""""""""""""""""

" Using vim-plug
" Neovim installation is here: https://github.com/junegunn/vim-plug#unix-1

call plug#begin()

" Colorschemes
Plug 'morhetz/gruvbox'

" fzf for <C-p> searching
Plug '/usr/local/opt/fzf'

" Seamless navigation between vim and tmux
Plug 'christoomey/vim-tmux-navigator'


" Swapping windows
Plug 'wesQ3/vim-windowswap'
" Usage {{{
"   <leader>ww to select a split, then <leader>ww again in a different split
"   to swap them.
" }}}

" Rename files!
Plug 'danro/rename.vim'
" Usage: :rename new-file-name.rs

" Tim Pope things "
Plug 'tpope/vim-surround'
" Usage {{{
"   cs"' to replace double quotes with single quotes
"   yss) to add ) around entire line
"   { instead of } to add spaces inside
"   use t for HTML tags
" }}}

Plug 'tpope/tpope-vim-abolish'
" Usage {{{
"   crs -> snake_case
"   crc -> camelCase (lowerCamelCase)
"   crm -> UpperCamelCase
"   cru -> SCREAMING_SNAKE_CASE
"   crk -> kebab-case
"   crt -> Title Case
" }}}

" Makes . work with above commands.
Plug 'tpope/vim-repeat'

" Pretty much just for :GBlame
Plug 'tpope/vim-fugitive'

" TypeScript syntax highlighting
Plug 'leafgarland/typescript-vim'
Plug 'w0rp/ale'

call plug#end()

"""""""""""""""""""
" Plugin Settings "
"""""""""""""""""""

" Map FZF to C-p
nnoremap <C-p> :FZF<CR>

let g:fzf_action = {
  \ 'ctrl-s': 'rightbelow split',
  \ 'ctrl-v': 'rightbelow vsplit',
  \ 'ctrl-h': 'leftabove vsplit',
  \ 'ctrl-u': 'leftabove split' }

" TypeScript support {{{
let g:ale_fix_on_save = 1
let g:ale_completion_enabled = 1
nnoremap <leader>gd :ALEGoToDefinition<CR>

let g:ale_linters = {
  \ 'javascript': ['eslint'],
  \ 'typescript': ['tslint', 'tsserver'],
  \ 'rust': ['rls']}
let g:ale_fixers = {
  \ 'javascript': [],
  \ 'typescript': ['prettier', 'tslint'],
  \ 'rust': ['rustfmt']}
" }}}

" Fugitive {{{
nnoremap <leader>gb :Gblame<CR>
" }}}

""""""""
" Rust "
""""""""

augroup rust_line_length
    autocmd FileType rust let &colorcolumn = join(range(101, 300), ",")
augroup END

""""""
" C# "
""""""

augroup csharp_formatting
    autocmd FileType cs let &colorcolumn = join(range(101, 300), ",")
    autocmd FileType cs set tabstop=8 softtabstop=4 shiftwidth=4 smarttab expandtab
augroup END

""""""""""""""
" Appearance "
""""""""""""""

" {{{

" Turn syntax highlighting on.
syntax enable

" Relative line numbers!
set relativenumber
set number

" And switch between them in insert and normal mode.
augroup nice_numbers
  autocmd!
  autocmd FocusLost * :set norelativenumber
  autocmd FocusGained * :set relativenumber

  autocmd InsertEnter * :set norelativenumber
  autocmd InsertLeave * :set relativenumber
augroup END

" Make cursor more noticeable
set cursorline
set cursorcolumn
" Default CursorLine is an underline, which I really don't like.
" Make it use same highlighting as CursorColumn in default colorscheme.
highlight! link CursorLine CursorColumn

" Set colorscheme silently so there's no error message when it isn't installed.
:silent! colorscheme gruvbox

" Status line

" ALWAYS display the status line!
set laststatus=2

set statusline=%f         " Path to file
set statusline+=%3m       " Modified
set statusline+=\ -\      " Separator
set statusline+=%y        " Filetype

set statusline+=%=        " Right side
set statusline+=%4l       " Current line
set statusline+=/         " Separator
set statusline+=%L        " Total lines
set statusline+=[%2c]     " Column number
set statusline+=\ %P      " Percent

" Disable the bell
set vb t_vb=""

" Leave a little space at the top and bottom.
set scrolloff=3

" Highlight trailing whitespace, but not when I'm in insert mode.
highlight trailingWhitespace ctermbg=red guibg=red
augroup trailing_whitespace
  autocmd!
  autocmd InsertEnter * match trailingWhitespace /\s\+\%#\@<!$/
  autocmd InsertLeave * match trailingWhitespace /\s\+$/
augroup END

" Always use a block cursor, even in insert mode (neovim only).
set guicursor=

" }}}

"""""""""""""""""""""""""""""""""
" Navigation & Split Management "
"""""""""""""""""""""""""""""""""

" {{{

" Set this here so tmux navigator doesn't use it's own mappings if it's
" loaded.
let g:tmux_navigator_no_mappings=1
" Don't navigate to other tmux panes when in full screen (<prefix>-z)
let g:tmux_navigator_disable_when_zoomed = 1

noremap <silent> <C-h> <C-w>h
noremap <silent> <C-j> <C-w>j
noremap <silent> <C-k> <C-w>k
noremap <silent> <C-l> <C-w>l

function! EnableTmuxMappings()
  if exists("g:loaded_tmux_navigator")
    noremap <silent> <C-h> :TmuxNavigateLeft<CR>
    noremap <silent> <C-j> :TmuxNavigateDown<CR>
    noremap <silent> <C-k> :TmuxNavigateUp<CR>
    noremap <silent> <C-l> :TmuxNavigateRight<CR>
  endif
endfunc

augroup enable_tmux
  autocmd!
  autocmd VimEnter * :call EnableTmuxMappings()
augroup end

" Shortcuts for opening files relative the the current one
set splitright
set splitbelow
nnoremap <Leader>or :rightbelow vsplit
nnoremap <Leader>ol :leftabove vsplit
nnoremap <Leader>oa :leftabove split
nnoremap <Leader>ob :rightbelow split

" Don't let vim change the setup when closing windows
set noequalalways

" I barely use tabs, but these are useful.
nnoremap <C-n> :tabnew<CR>
nnoremap L :tabnext<CR>
nnoremap H :tabprevious<CR>

" Easier navigation in command mode
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>

" }}}

"""""""""""""""""""
" Editor behavior "
"""""""""""""""""""

" {{{

" Use system clipboard
set clipboard=unnamedplus

" jk instead of ESC
inoremap jk <ESC>

" Map Y to yank to end of line.
nnoremap Y y$

" Detect file changes.
set autoread

" Case insensitive search, unless it starts with a capital letter.
set ignorecase
set smartcase
set nohlsearch
set noincsearch

" Get backspace to behave sanely
set backspace=indent,eol,start

" Basic tab support
set tabstop=8 softtabstop=2 shiftwidth=2 smarttab expandtab

" Basic indentation support
set autoindent

" Format options (full list at ":help fo-table"; see also ":help 'fo'")
" Change between += and -= to toggle an option
set formatoptions-=t  " Don't auto-wrap text, I'll do that.
set formatoptions+=c  " ... but do handle comments for me.
set formatoptions+=q  " Let me format comments manually.
set formatoptions+=r  " Auto-continue comments if I'm still in insert mode,
set formatoptions-=o  " but not if I'm coming from normal mode.
set formatoptions+=j  " Delete comment characters when joining lines.
set formatoptions+=n  " Recognize numbered lists and indent them properly.

" Show navigable menu for tab completion when opening files.
set wildmenu
set wildmode=longest,full

" Store .swp files in a single directory.
set directory=~/.vim/swapfiles
" }}}


"""""""""""""""""""
" Useful Commands "
"""""""""""""""""""

" {{{

" Trim whitespace
nnoremap <leader>ts mx :%s/\s\+$//g <CR> 'x

" Easy editing of .vimrc: ve to edit; vs to source, vv to source vertically.
nnoremap <Leader>ve :split ~/.config/nvim/init.vim<CR>
nnoremap <Leader>vv :vsplit ~/.config/nvim/init.vim<CR>
nnoremap <Leader>vs :source ~/.config/nvim/init.vim<CR>

" Make a window into a scratch buffer
nnoremap <Leader>sc :setlocal buftype=nofile<CR>:setlocal bufhidden=hide<CR>:setlocal noswapfile<CR>

" Nice support for native vim sessions
" Delete hidden buffers (for before saving session)
function! DeleteHiddenBuffers()
  let tpbl=[]
  call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
  for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
    silent execute 'bwipeout' buf
  endfor
endfunction

map <Leader>dhb :call DeleteHiddenBuffers() <CR>
map <Leader>ss :mksession! ~/.vim/vim_session <CR>
map <Leader>ls :source ~/.vim/vim_session <CR>

" <C-d> for quick shell
nnoremap <C-d> <Esc>:sh<CR>

" Easy enabling of pasted mode.
" Normal mode:
nnoremap <silent> <F7> :call TogglePasteMode()<CR>
func! TogglePasteMode()
  set paste!
  echo "Paste mode: ".(&paste ? "ON" : "OFF")
endfunc

" [f]ast [m]acros: Toggle lazy redraw for quickly executing macros.
map <Leader>fm :set lazyredraw!<CR>

" Move lines up and down
" (If this doesn't work in iTerm, go to Profiles > Keys and have Left Option key send Esc+
nmap <M-j> :m+<CR>==
nmap <M-k> :m-2<CR>==
imap <M-j> <Esc>:m+<CR>==gi
imap <M-k> <Esc>:m-2<CR>==gi
vmap <M-j> :m'>+<CR>gv=gv
vmap <M-k> :m-2<CR>gv=gv
" }}}
