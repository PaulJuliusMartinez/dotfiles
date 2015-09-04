alias ls="ls -GFlsh"

export EDITOR='vim'

# Titling tabs
function title {
  echo -ne "\033]0;"$*"\007"
}

# Git tab completion
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# Clear clear screen
stty -ixon
bind -r \C-s
bind \C-s:clear-screen
