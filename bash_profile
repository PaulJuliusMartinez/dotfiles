# Hide "The default interactive shell is now zsh." warning:
export BASH_SILENCE_DEPRECATION_WARNING=1

alias ls="ls -GFlsh"

# Add colors
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
export HISTIGNORE="&"

PATH=/usr/local/bin:$PATH

# Git tab completion
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# Python persistent history
export PYTHONSTARTUP=~/.pystartup

# Clear clear-screen
stty -ixon
bind -r \C-s
bind \C-s:clear-screen

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# Ruby
eval "$(rbenv init - -bash)"

# nvim
alias vim=nvim

# ag -> vim
function vimag {
  vim $(ag -l "$@")
}

# Set iTerm tab title
function tab_title {
  if [ -n "$TMUX" ]; then
    printf "\ePtmux;\e\e]0;"$*"\007\e\\"
  else
    printf "\e]0;"$*"\007"
  fi
}

# For FZF
export FZF_DEFAULT_COMMAND='rg --files --follow'

# opam configuration
test -r /Users/paul/.opam/opam-init/init.sh && . /Users/paul/.opam/opam-init/init.sh > /dev/null 2> /dev/null || true
