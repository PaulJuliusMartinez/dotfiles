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
eval "$(rbenv init -)"

# nvim
alias vim=nvim
