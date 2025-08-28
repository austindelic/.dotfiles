#!/bin/zsh
#
# .aliases - Set whatever shell aliases you want.
#

# single character aliases - be sparing!
alias _=sudo
alias l=ls
alias g=git

# mask built-ins with better defaults
alias vi=vim

# more ways to ls
# Use eza instead of ls with preferred options
alias ls='eza -h --icons --group-directories-first --git --header'


# find
alias fd='find . -type d -name'
alias ff='find . -type f -name'

# misc
alias zshrc='${EDITOR:-vim} "${ZDOTDIR:-$HOME}"/.zshrc'
alias zdot='cd ${ZDOTDIR:-~}'
alias bb="brew bundle -v --file='$HOME/.config/brew/.Brewfile'"

code() {
  flatpak run com.vscodium.codium "$@" > /dev/null 2>&1
}




