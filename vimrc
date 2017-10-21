" Set <leader> at the very beginning.
let mapleader=" "
let maplocalleader=" "

" Make this file readable.
augroup filetype_vim
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
augroup END

set textwidth=90
let &colorcolumn = join(range(91, 300), ",")

""""""""""""""""""""""
" Installing Plugins "
""""""""""""""""""""""

" {{{

" Required by Vundle
set nocompatible
filetype off

" To install Vundle run:
" git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" Colorschemes
Plugin 'morhetz/gruvbox'
" Plugin 'altercation/vim-colors-solarized'

" CtrlP
Plugin 'ctrlpvim/ctrlp.vim'

" Tmux!
Plugin 'christoomey/vim-tmux-navigator'

" Swapping windows
Plugin 'wesQ3/vim-windowswap'
" Usage {{{
"   <leader>ww to select a split, then <leader>ww again in a different split
"   to swap them.
" }}}

" Rename files!
Plugin 'danro/rename.vim'

" Tim Pope things "
Plugin 'tpope/vim-surround'
" Usage {{{
"   cs"' to replace double quotes with single quotes
"   yss) to add ) around entire line
"   { instead of } to add spaces inside
"   use t for HTML tags
" }}}

Plugin 'tpope/tpope-vim-abolish'
" Usage {{{
"   cr{s,c,m,u,k,t} to switch to snake_case, lowerCamelCase, upperCamelCase,
"   UPPER_CASE, kebab-case, and Title Case
" }}}

" Makes . work with above commands.
Plugin 'tpope/vim-repeat'

" YouCompleteMe
Plugin 'Valloric/YouCompleteMe'

" TypeScript auto-completion and syntax-highlighting support
Plugin 'Quramy/tsuquyomi'
Plugin 'leafgarland/typescript-vim'
Plugin 'ianks/vim-tsx'

call vundle#end()

" Now we turn this on!
filetype plugin indent on

" }}}

"""""""""""""""""""
" Plugin Settings "
"""""""""""""""""""

" YouCompleteMe {{{
if !exists("g:ycm_semantic_triggers")
   let g:ycm_semantic_triggers = {}
endif
let g:ycm_semantic_triggers['typescript'] = ['.']

" Turn off for Ruby since it's laggy and doesn't help.
let g:ycm_filetype_blacklist = { 'ruby': 1 }

function! DisableYouCompleteForRubyFiles()
  if exists("g:ycm_filetype_blacklist")
    g:ycm_filetype_blacklist.ruby = 1
  endif
endfunc

augroup disable_ycm_for_ruby
  autocmd!
  autocmd VimEnter * :call DisableYouCompleteForRubyFiles()
augroup end
" }}}

" Tsuquyomi (Typescript) {{{
let g:tsuquyomi_completion_detail = 1
" }}}

" CtrlP {{{
if executable('ag')
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
end
" }}}

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

" Nice tree-style file navigation
let g:netrw_liststyle=3

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

" Shortcuts for opening files relative the the current one,
" splitright as default
set splitright
nnoremap <Leader>or :set splitright<CR>:vs
nnoremap <Leader>ol :set nosplitright<CR>:vs
nnoremap <Leader>oa :set nosplitbelow<CR>:sp
nnoremap <Leader>ob :set splitbelow<CR>:sp

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
set clipboard=unnamed

" jk instead of ESC
inoremap jk <ESC>

" Map Y to yank to end of line.
nnoremap Y y$

" Detect file changes.
set autoread

" Case insensitive search, unless it starts with a capital letter.
set ignorecase
set smartcase

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
" }}}

"""""""""""""""""""
" Useful Commands "
"""""""""""""""""""

" {{{

" Trim whitespace
nnoremap <leader>ts mx :%s/\s\+$//g <CR> 'x

" Easy editing of .vimrc: ve to edit; vs to source, vv to source vertically.
nnoremap <Leader>ve :split ~/.vimrc<CR>
nnoremap <Leader>vv :vsplit ~/.vimrc<CR>
nnoremap <Leader>vs :source ~/.vimrc<CR>

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

" Insert mode:
set pastetoggle=<F7>

" }}}
