" Many settings taken from github.com/chiphogg/dotfiles

" Vundle setup!
set nocompatible
filetype off

" Make sure this goes at the top!
" ' ' is easy to type, so use it for <Leader> to make compound commands easier:
let mapleader=","
let maplocalleader=","
" Unfortunately, this introduces a delay for the ',' command.  Let's
" compensate by introducing a speedy alternative...
noremap ,. ,

set rtp+=~/.vim/bundle/vundle
call vundle#rc()

" Vundle and Bundles! ----------------------------------------------------- {{{
" Let Vundle manage Vundle, required!
Bundle 'gmarik/vundle'

" Bundles! Mostly copied from the Vundle README.

" Syntastic
Bundle 'scrooloose/syntastic'

" You Complete Me
Bundle 'Valloric/YouCompleteMe'

" Omnisharp, separate from You Complete Me
" Bundle 'nosami/Omnisharp'
" Bundle 'tpope/vim-dispatch'

" Tim Pope
" Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-repeat'

" Colorschemes
Bundle 'altercation/vim-colors-solarized'

" Snippets
" Bundle 'SirVer/ultisnips'

" Ag, code searching
Bundle 'rking/ag.vim'

" LaTeX
Bundle 'LaTeX-Box-Team/LaTeX-Box'
" ------------------------------------------------------------------------- }}}

" Now we turn this on!
filetype plugin indent on

" Detect file changes.
set autoread

" TeX file settings ------------------------------------------------------- {{{
augroup filetype_tex
  autocmd!
  autocmd FileType tex noremap <Leader>ct :Latexmk<CR>
  autocmd FileType tex nnoremap j gj
  autocmd FileType tex nnoremap k gk
augroup END
" ------------------------------------------------------------------------- }}}

" Some basic settings for simple formatting, mainly tabs ------------------ {{{

" Get backspace to behave sanely
set backspace=indent,eol,start

" Use the mouse. Usually people do 'set mouse=a', but then this makes clicking
" and dragging enter visual mode, which I don't like. This prevents that.
set mouse=nicr

" Experience shows: tabs *occasionally* cause problems; spaces *never* do.
" Besides, vim is smart enough to make it "feel like" real tabs.
" tabstop is 8 so it's REALLY obvious when there are tabs.
set tabstop=4 softtabstop=4 shiftwidth=4 smarttab " expandtab 

" Soft-wrapping is more readable than scrolling...
set wrap
" ...but don't break in the middle of a word!
set linebreak

" Almost every filetype is better with autoindent.
" (Let filetype-specific settings handle the rest.)
set autoindent

" Format options (full list at ":help fo-table"; see also ":help 'fo'")
" Change between += and -= to toggle an option
set formatoptions-=t  " Don't auto-wrap text, I'll do that.
set formatoptions+=c  " ... but do handle comments for me.
set formatoptions+=q  " Let me format comments manually.
set formatoptions+=r  " Auto-continue comments if I'm still in insert mode,
set formatoptions-=o  " but not if I'm coming from normal mode

" Set columns max at 80.
set textwidth=80

" ------------------------------------------------------------------------- }}}

" Git and Fugitive -------------------------------------------------------- {{{
" ,gs for git status
" nnoremap <Leader>gs :Gstatus<CR>
" ------------------------------------------------------------------------- }}}

" Opening files, editing files, etc. -------------------------------------- {{{
" Show navigable menu for tab completion.
set wildmenu
" Default is longest,full. List prints all the files in the directory to help.
set wildmode=longest,full
" Quick save, ,ww
nnoremap <Leader>ww :w<CR>
" ------------------------------------------------------------------------- }}}

" Vimscript file settings ------------------------------------------------- {{{
augroup filetype_vim
  autocmd!
  autocmd FileType vim setlocal foldmethod=marker
augroup END
" ------------------------------------------------------------------------- }}}

" TeX file settings ------------------------------------------------------- {{{
augroup filetype_tex
  autocmd!
  autocmd FileType tex noremap <Leader>ct :Latexmk<CR>
  autocmd FileType tex nnoremap j gj
  autocmd FileType tex nnoremap k gk
augroup END
" ------------------------------------------------------------------------- }}}

" Unity/C# File settings -------------------------------------------------- {{{
augroup filetype_csharp
  autocmd!
  autocmd BufRead *.cs set tabstop=4
  autocmd BufRead *.cs set shiftwidth=4
  autocmd BufRead *.cs set noexpandtab
  autocmd BufRead *.cs nnoremap <leader>gd :YcmCompleter GoToDeclaration<CR>
augroup END

nnoremap <leader>br <C-O><CR>:set splitright<CR>:vert sb 
nnoremap <leader>bl <C-O><CR>:set nosplitright<CR>:vert sb 
nnoremap <leader>ba <C-O><CR>:set nosplitbelow<CR>:sb 
nnoremap <leader>bb <C-O><CR>:set splitbelow<CR>:sb 
" ------------------------------------------------------------------------- }}}

" Window management! ------------------------------------------------------ {{{
" Control + h/j/k/l to move windows in split screen
noremap <C-h> <Esc><C-w>h
noremap <C-j> <Esc><C-w>j
noremap <C-k> <Esc><C-w>k
noremap <C-l> <Esc><C-w>l

" Set the size of a window quickly for 80 columns or 100 columns.
nnoremap <Leader>rs :vertical resize 84<CR>
nnoremap <Leader>rS :vertical resize 104<CR>

" Shortcuts for opening files relative the the current one,
" splitright as default
set splitright
nnoremap <Leader>or :set splitright<CR>:84vs
nnoremap <Leader>oo :set splitright<CR>:84vs
nnoremap <Leader>ol :set nosplitright<CR>:84vs
nnoremap <Leader>oa :set nosplitbelow<CR>:sp
nnoremap <Leader>ob :set splitbelow<CR>:sp

" Don't let vim change the setup when closing windows
set noequalalways

" Sessions
map <Leader>ss :mksession! ~/.vim/vim_session <cr> " Quick write session with F2
map <Leader>ls :source ~/.vim/vim_session <cr>     " And load session with F3
" ------------------------------------------------------------------------- }}}

" Tabs! :O --------------------------------------------------------------- {{{
" ,nt for new tab
nnoremap <Leader>nt :tabnew<CR>
" ------------------------------------------------------------------------- }}}

" Shell access ----------------------------------------------------------- {{{
" <CTRL-d> for quick shell
nnoremap <C-d> <Esc>:sh<CR>
" ------------------------------------------------------------------------- }}}

" My status line! --------------------------------------------------------- {{{
set laststatus=2          " ALWAYS display the status line!

" Status line from fugitive help.
set statusline=%<%f\ %h%m%r\ %n%=%-14.(%l,%c%V%)\ %P
" I could do set ruler, but I think having the filetype is a nice touch.
" set ruler

set statusline=%f         " Path to file
set statusline+=%3m       " Modified
set statusline+=\ -\      " Separator
" set statusline+=Filetype: " Label
set statusline+=%y        " Filetype

set statusline+=%=        " Right side
set statusline+=%4l       " Current line
set statusline+=/         " Separator
set statusline+=%L        " Total lines
set statusline+=[%2c]     " Column number
set statusline+=\ %P      " Percent
" ------------------------------------------------------------------------- }}}

" Relative line numbers and toggling them --------------------------------- {{{
" Set relative number as the default
set relativenumber
set number

 "Settings for line numbers
"function! NumberToggle()
  "if(&relativenumber == 1)
    "set number
  "else
    "set relativenumber
  "endif
"endfunc

"nnoremap <C-n> :call NumberToggle()<cr>

augroup nice_numbers
  autocmd!
  autocmd FocusLost * :set number
  autocmd FocusGained * :set relativenumber

  autocmd InsertEnter * :set number
  autocmd InsertLeave * :set relativenumber
augroup END
" ------------------------------------------------------------------------- }}}

" Easy editing of .vimrc: ,ve to edit; ,vs to source ---------------------- {{{
nnoremap <Leader>ve :split ~/.vimrc<CR>
nnoremap <Leader>vv :vsplit ~/.vimrc<CR>
nnoremap <Leader>vs :source ~/.vimrc<CR>
" ------------------------------------------------------------------------- }}}

" Easy paste mode toggling with <F7> -------------------------------------- {{{

" Normal mode:
nnoremap <silent> <F7> :call Paste_toggle()<CR>
func! Paste_toggle()
  set paste!
  echo "Paste mode: ".(&paste ? "ON" : "OFF")
endfunc

" Insert mode:
set pastetoggle=<F7>
" ------------------------------------------------------------------------- }}}

" Colorscheme, 80 columns and trailing whitespace ------------------------- {{{
syntax enable
set background=light
colorscheme solarized
" let &colorcolumn = join(range(81, 300), ",")
set cursorline
set cursorcolumn
map <leader>bg :let &background = ( &background == "dark"? "light" : "dark" )<CR>

" Highlight trailing whitespace, but not when I'm in insert mode.
highlight trailingWhitespace ctermbg=red guibg=red
augroup trailing_whitespace
  autocmd!
  autocmd InsertEnter * match trailingWhitespace /\s\+\%#\@<!$/
  autocmd InsertLeave * match trailingWhitespace /\s\+$/
augroup END
" ------------------------------------------------------------------------- }}}

" Miscellaneous ----------------------------------------------------------- {{{

" Easier folding because "za" is hard as balls to type
" ff is fold this one, fa is fold all, fo is open folds.
nnoremap <Leader>ff za
nnoremap <Leader>fa zm
nnoremap <Leader>fo zR

" jk instead of ESC
inoremap jk <ESC>
" Also uu, because I usually type u when I hit the wrong 'o' or 'O'
inoremap uu <ESC>

" Map Y to yank to end of line.
nnoremap Y y$

" Easier navigation in command mode
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>

" Jumping to marks: You usually always want to jump to the cursor position
" (`), not the beginning of the line (').  But, the apostrophe is much more
" conveniently located.  So, save your fingers and swap 'em!
nnoremap ' `
nnoremap ` '

" Disable the bell
set vb t_vb=""

" Leave a little space at the top and bottom.
set scrolloff=3
" ------------------------------------------------------------------------- }}}
nnoremap <C-d> :sh<CR>
