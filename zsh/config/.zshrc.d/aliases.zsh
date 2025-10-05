#!/bin/zsh
#
# .aliases - Set whatever shell aliases you want.
#

# single character aliases - be sparing!
alias _=sudo
alias ls='eza --icons --group-directories-first'
alias l=ls
alias g=git
alias lt='ls -T'
# mask built-ins with better defaults
alias vi=vim

# more ways to ls
alias ll='ls -lh'
alias la='ls -lAh'
alias ldot='ls -ld .*'

# fix common typos
alias quit='exit'
alias cd..='cd ..'

# tar
alias tarls="tar -tvf"
alias untar="tar -xf"

# find
alias fd='find . -type d -name'
alias ff='find . -type f -name'

# url encode/decode
alias urldecode='python3 -c "import sys, urllib.parse as ul; \
    print(ul.unquote_plus(sys.argv[1]))"'
alias urlencode='python3 -c "import sys, urllib.parse as ul; \
    print (ul.quote_plus(sys.argv[1]))"'

# misc
alias please=sudo

alias bb='brew bundle --file=$HOME/.config/brew/.Brewfile'

alias lg='lazygit'

alias cddf='cd ~/.dotfiles'
alias python='python3'
alias cd='z'
