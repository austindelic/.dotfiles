#!/bin/zsh
#
# .aliases - Set whatever shell aliases you want.
#
function yazi-wrapper() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

function cproj() {
  local dir
  dir=$(fd . ~/Projects -t d -d 1 -x basename {} \
    | fzf --height=40% --reverse --border --prompt='project> ') || return

  cd "$HOME/Projects/$dir"
}

function fkill() {
    ps aux | fzf --height 40% --reverse | awk '{print $2}' | xargs kill -9
}

function tools_menu() {
  local selection cmd action

  selection=$(
    cat <<'EOF' | fzf --height=40% --reverse --border --prompt='tool> '
fd         | fd – better find
rg         | ripgrep – fast grep
btop       | top – resource monitor
yazi       | yazi – TUI file manager
eza        | ls – modern ls
bat        | bat – cat with syntax highlighting
dust       | dust – disk usage
duf        | duf – disk free viewer
procs      | procs – modern ps
xh         | xh – HTTP client
doggo     | doggo – dig replacement
scc        | scc – code counter (cloc)
taskwarrior-tui | td – task manager TUI
lazygit    | lg – git TUI
zellij     | zj – terminal multiplexer
y          | y – yazi wrapper (file manager + cd)
p          | p – project switcher (cproj)
fk         | fk – pick a process and kill
bb         | bb – brew bundle sync
ghostty    | ghostty – launch Ghostty terminal
hyperfine  | bench - modern benchmarking tool
gping      | pingg - ping with a graph gui
EOF
  ) || return

  cmd=${selection%% *}

  echo "Selected: $selection"
  echo -n "[r]un, [t]ldr, [q]uit: "
  read -k1 action
  echo

  case "$action" in
    r|$'\n') eval "$cmd" ;;
    t)       tldr "$cmd" 2>/dev/null || echo "No tldr for $cmd" ;;
    *)       ;;  # quit/do nothing
  esac
}


function toggle_fps() {
  # Read current value (empty string if not set)
  local current
  current=$(/bin/launchctl getenv MTL_HUD_ENABLED 2>/dev/null)

  if [[ "$current" == "1" ]]; then
    echo "Disabling macOS Metal FPS HUD…"
    /bin/launchctl unsetenv MTL_HUD_ENABLED
    echo "Disabled. (Restart apps to apply)"
  else
    echo "Enabling macOS Metal FPS HUD…"
    /bin/launchctl setenv MTL_HUD_ENABLED 1
    echo "Enabled. (Restart apps to apply)"
  fi
}

function sourcecddf() {
  source ~/.config/zsh/.zshrc
}
# menus
alias tools='tools_menu'
alias help='tools'
alias p='cproj'

#modern unix:
alias cd='z'
alias ps='procs'
alias du='dust'
alias df='duf'
alias dig='doggo'
alias curl='xh'
alias grep='rg'
alias top='btop'
alias cat='bat'
alias ls='eza --icons --group-directories-first'
#tools
alias pingg='gping'
alias bench='hyperfine'
alias fk='fkill'
alias g=git
alias vi=vim
alias bb='brew bundle --file=$HOME/.config/brew/.Brewfile'
alias lg='lazygit'
alias cddf='cd ~/.dotfiles'
alias python='python3'
alias vim='nvim'
alias nvid='neovide'
alias ghostty='/Applications/Ghostty.app/Contents/MacOS/ghostty'
alias cloc='scc'
alias td='taskwarrior-tui'
alias y='yazi-wrapper'
alias zj='zellij'

# productivity
alias c='clear'
alias h='history'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'            # go back
alias vf='fzf --preview "bat --style=numbers --color=always {}" | xargs -r ${EDITOR:-nvim}'
alias cdf='cd "$(fd --type d | fzf)"'
alias mkcd='mkdir -p "$1" && cd "$1"'
alias ll='eza -lha --icons --group-directories-first'
alias lt='eza --tree --level=2 --icons'
alias ltt='eza --tree --level=4 --icons'
alias la='eza -a --icons'

# misc



