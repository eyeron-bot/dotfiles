# oh-my-zsh configuration
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# GPG TTY for signing
export GPG_TTY=$(tty)

alias cls="claude --dangerously-skip-permissions"
alias lg=lazygit

# mise - runtime version manager
eval "$(mise activate zsh)"
