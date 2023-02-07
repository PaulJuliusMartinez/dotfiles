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
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

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
Plug 'peitalin/vim-jsx-typescript'
Plug 'w0rp/ale'

" YouCompleteMe for Postgres
" Plug 'ycm-core/YouCompleteMe'

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

let g:ale_fix_on_save = 1
let g:ale_completion_enabled = 1
nnoremap gd :ALEGoToDefinition<CR>
" Matching Jane Stree OCaml
nnoremap [[ :ALEHover<CR>
nnoremap <leader>fu :ALEFindReferences<CR>

let g:ale_rust_cargo_use_clippy = executable('cargo-clippy')

let g:ale_rust_analyzer_config = {
  \ 'cargo': { 'loadOutDirsFromCheck': v:true },
  \ 'procMacro': { 'enable': v:true }}

let g:ale_linters = {
  \ 'javascript': ['eslint'],
  \ 'typescript': ['tslint', 'tsserver'],
  \ 'typescriptreact': ['tslint', 'tsserver'],
  \ 'ruby': ['rubocop'],
  \ 'rust': ['analyzer']}
let g:ale_fixers = {
  \ '*': ['trim_whitespace', 'remove_trailing_lines'],
  \ 'javascript': [],
  \ 'typescript': ['prettier', 'eslint'],
  \ 'typescriptreact': ['prettier', 'eslint'],
  \ 'ruby': ['prettier'],
  \ 'rust': ['rustfmt'],
  \ 'ocaml': ['ocamlformat']}

" Project dependent ALE fixers
let g:ale_pattern_options = {
  \ 'plaintextsports': {
    \ 'ale_fixers': {
      \ 'ruby': []}},
  \ 'jless': {
    \ 'ale_linters': {
      \ 'ruby': []}}}

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

""""""""
" Ruby "
""""""""

" Convert a one line if statement to a three line if statement.
nnoremap <Leader>tli 0/ if <CR>r<CR>ddkPjoend<ESC>k==
" Convert a three line if statement to a one line if statement.
nnoremap <Leader>oli /^ *end$<CR>ddkkddpk==J

"""""
" C "
"""""

function! ProjectDependentWhitespace()
  if stridx(expand('%:p'), "postgres") >= 0
    set tabstop=4 softtabstop=4 shiftwidth=4 smarttab noexpandtab
  endif
endfunc

augroup c_formatting
  autocmd!
  autocmd FileType c,cpp :call ProjectDependentWhitespace()
  autocmd FileType c,cpp nnoremap <buffer> gd :YcmCompleter GoTo<CR>
augroup END

"""""""""
" OCaml "
"""""""""

" let g:opamshare = substitute(system('opam var share'),'\n$','','''')
" execute "set rtp+=" . g:opamshare . "/merlin/vim"

function! OCamlSwitchBetweenMLandMLI()
  let file_path = expand("%")
  let file_name = expand("%<")
  let extension = split(file_path, '\.')[-1]
  let err_msg = "There is no file "

  let ml = join([file_name, ".ml"], "")
  let intf = join([file_name, "_intf.ml"], "")
  let mli = join([file_name, ".mli"], "")

  if file_name[-5:] == "_intf"
    let impl_root = file_name[:-6]
    let impl_file = join([impl_root, ".ml"], "")
    if filereadable(impl_file)
      execute "edit " . impl_file
    else
      echo join([err_msg, impl_file], "")
    endif
  elseif extension == "ml"
    if filereadable(intf)
      :e %<_intf.ml
    elseif filereadable(mli)
      :e %<.mli
    else
      echo join([err_msg, mli], "")
    endif
  elseif extension == "mli"
    if filereadable(ml)
      :e %<.ml
    else
      echo join([err_msg, ml], "")
    endif
  endif
endfunc

autocmd FileType ocaml nnoremap <buffer> gm :call OCamlSwitchBetweenMLandMLI()<CR>

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

" Don't show intro screen
set shm+=I

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
" How many spaces are used to display actual tab characters
set tabstop=8
" How many spaces are inserted when typing "Tab" or hitting backspace.
set softtabstop=2
" Number of spaces used for auto-indent
set shiftwidth=2
" Use shiftwidth when hitting tab at start of a line, and backspace
" removes a shiftwidth worth of space when at start of a line.
" In other places softtabstop is used.
set smarttab
" Insert spaces instead of tabs in insert mode.
" Use CTRL-V<Tab> to insert an actual tab.
set expandtab

" Basic indentation support
set autoindent

" Don't insert two spaces after '.' when using gq or J.
set nojoinspaces

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
nnoremap <Leader>sc :setlocal buftype=nofile bufhidden=hide noswapfile<CR>

" Yank the filename of the current buffer to the clipboard
nnoremap <Leader>yfp :let @+ = expand("%")<CR>

" Create a (vertical) scratch buffer
" -bar allows using | after (:help command-bar)
command! -bar Scratch new +setlocal\ buftype=nofile\ bufhidden=hide\ noswapfile
command! -bar Vscratch vnew +setlocal\ buftype=nofile\ bufhidden=hide\ noswapfile

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
" nnoremap <C-d> <Esc>:sh<CR>

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

" Open the results of ag -l <term> in a vertical split
nnoremap <Leader>agl :Vscratch \| 0read ! ag -l
" Open file under cursor right/left/above/below
nnoremap <Leader>ofr :rightbelow<CR><C-w>f
nnoremap <Leader>ofl :leftabove<CR><C-w>f
nnoremap <Leader>ofa :leftabove<CR><C-w>f
nnoremap <Leader>ofb :rightbelow<CR><C-w>f

" From Jane Street
function! s:erase_path_part()
  if getcmdtype() != ':'
    return "\<C-_>"
  endif
  let cursor = getcmdpos()
  let before_cursor = getcmdline()[:cursor-2]
  let last_slash_idx = strridx(before_cursor, '/', cursor - 3)
  if last_slash_idx < 0
    return ''
  endif
  return repeat("\<BS>", cursor - 2 - last_slash_idx)
endfunction

cnoremap <expr> <C-_> <SID>erase_path_part()

" For plaintextsports ASCII art lol
nnoremap <Leader>uni i–·´‘’‾∧∨<ESC>

" }}}

" Set up vim in a mode to write freeform text.
command! Freeform :call SetupFreeform()
map <Leader>ff :call SetupFreeform() <CR>

func! SetupFreeform()
  " Enable line wrapping.
  setlocal wrap
  " Only break at words.
  setlocal linebreak
  " Turn on spellchecking
  setlocal spell

  " Make jk and 0$ work on visual lines.
  nnoremap <buffer> j gj
  nnoremap <buffer> k gk
  nnoremap <buffer> 0 g0
  nnoremap <buffer> $ g$

  " Disable colorcolumn
  setlocal colorcolumn=
  " Disable cursorcolumn because it doesn't show on all the wrapped
  " lines, and cursorline because it highlights the whole line.
  setlocal nocursorline
  setlocal nocursorcolumn
endfunc

command! -nargs=? Draft :call SetupDraftMode(<args>)
func! SetupDraftMode()
  set columns=84
  setlocal colorcolumn=
  autocmd VimResized * if (&columns > 84) | set columns=84 | endif

  :Freeform
endfunc
