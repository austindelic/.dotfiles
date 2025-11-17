#!/bin/zsh
#
# .aliases - Set whatever shell aliases you want.
#

alias ls='eza --icons --group-directories-first'
alias g=git
alias lt='ls -T'
alias vi=vim
alias bb='brew bundle --file=$HOME/.config/brew/.Brewfile'
alias lg='lazygit'
alias cddf='cd ~/.dotfiles'
alias python='python3'
alias cd='z'
alias vim="nvim"
alias nvid='neovide --fork'
alias ghostty="/Applications/Ghostty.app/Contents/MacOS/ghostty"
alias grep="rg"
alias cloc="scc"
alias td="taskwarrior-tui"
alias ..='cd ..'
alias ...='cd ../..'
alias c='clear'
alias h='history'
alias cat='bat'
function yazi-wrapper() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}
alias y='yazi-wrapper'
alias curl='xh'
alias zj='zellij'
alias sz='source ~/.config/zsh/.zshrc'
cproj() {
  local dir
  dir=$(fd . ~/Projects -t d -d 1 -x basename {} \
    | fzf --height=40% --reverse --border --prompt='project> ') || return

  cd "$HOME/Projects/$dir"
}
alias p='cproj'
