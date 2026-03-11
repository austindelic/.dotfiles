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
function wproj() {
  local dir
  dir=$(fd . ~/work -t d -d 1 -x basename {} \
    | fzf --height=40% --reverse --border --prompt='work> ') || return

  cd "$HOME/work/$dir"
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

function vox_pipeline() {
  local input="$1"
  local res="${2:-128}"

  if [[ -z "$input" ]]; then
    echo "Usage: vox_pipeline <input_model> [resolution]"
    return 1
  fi

  if [[ ! -f "$input" ]]; then
    echo "Error: file not found: $input"
    return 1
  fi

  if ! [[ "$res" =~ '^[0-9]+$' ]]; then
    echo "Error: resolution must be a number"
    return 1
  fi

  local input_abs base_name out_dir output_fbx tmp_vox tmp_voxx rc
  input_abs="${input:A}"
  base_name="${input_abs:t:r}"
  out_dir="${input_abs:h}"
  output_fbx="${out_dir}/${base_name}x${res}.fbx"

  tmp_vox="$(mktemp -t voxquant).vox" || return 1
  tmp_voxx="$(mktemp -t voxconvert).vox" || {
    rm -f -- "$tmp_vox"
    return 1
  }

  echo "1/3 voxquant -> $res"
  voxquant -i "$input_abs" -o "$tmp_vox" -r "$res" || {
    rc=$?
    rm -f -- "$tmp_vox" "$tmp_voxx"
    return $rc
  }

  echo "2/3 voxconvert"
  /Applications/vengi-voxconvert.app/Contents/MacOS/vengi-voxconvert -i "$tmp_vox" -o "$tmp_voxx" || {
    rc=$?
    rm -f -- "$tmp_vox" "$tmp_voxx"
    return $rc
  }

  echo "3/3 blender optimise + rescale"
  blender --background --python-exit-code 1 --python ~/.dotfiles/scripts/convert_to_voxel.py -- \
    "$tmp_voxx" "$output_fbx" "$input_abs" "$res" || {
    rc=$?
    rm -f -- "$tmp_vox" "$tmp_voxx"
    return $rc
  }

  rm -f -- "$tmp_vox" "$tmp_voxx"

  if [[ ! -f "$output_fbx" ]]; then
    echo "Error: Blender finished but no output file was created: $output_fbx"
    return 1
  fi

  echo "Done: $output_fbx"
}
function vox_pipeline_range() {
  local input="$1"
  local start="${2:-2}"
  local end="${3:-512}"

  if [[ -z "$input" ]]; then
    echo "Usage: vox_pipeline_range <input_model> [start_res] [end_res]"
    return 1
  fi

  if [[ ! -f "$input" ]]; then
    echo "Error: file not found: $input"
    return 1
  fi

  if ! [[ "$start" =~ '^[0-9]+$' ]] || ! [[ "$end" =~ '^[0-9]+$' ]]; then
    echo "Error: start_res and end_res must be numbers"
    return 1
  fi

  if (( start > end )); then
    echo "Error: start_res must be <= end_res"
    return 1
  fi

  local r
  for (( r = start; r <= end; r *= 2 )); do
    echo
    echo "=== Generating x${r} ==="
    vox_pipeline "$input" "$r" || return $?
  done
}

# menus
alias tools='tools_menu'
alias help='tools'
alias p='cproj'
alias wo='wproj'
#modern unix:
alias cd='z'
alias du='dust'
alias df='duf'
alias dig='doggo'
alias grep='rg'
alias top='btop'
# alias cat='bat'
alias ls='eza --icons --group-directories-first'

#tools
alias pingg='gping'
alias bench='hyperfine'
alias fk='fkill'
alias g=git
alias vi=vim
alias bb='brew bundle --file=$HOME/.config/brew/.Brewfile'
alias b="brew"
alias lg='lazygit'
alias gg='lazygit'
alias cddf='cd ~/.dotfiles'
alias python='python3'
alias lua='luajit'
alias vim='nvim'
alias nvid='neovide'
alias ghostty='/Applications/Ghostty.app/Contents/MacOS/ghostty'
alias cloc='tokei'
alias td='taskwarrior-tui'
alias y='yazi-wrapper'
alias zj='zellij'
alias ghmd='gh markdown-preview'
alias calc='kalker'
alias lssh='lazyssh'
alias whisper='whisper-cli -m ~/models/whisper/ggml-large-v3-turbo-q5_0.bin'
# productivity
alias ou="ollama serve >/dev/null 2>&1 &" #ollama up
alias od='pkill ollama' #ollama down
alias c='clear'
alias h='history'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'            # go back
alias cdf='cd "$(fd --type d | fzf)"'
alias mkcd='mkdir -p "$1" && cd "$1"'
alias ll='eza -lha --icons --group-directories-first'
alias lt='eza --tree --level=2 --icons'
alias ltt='eza --tree --level=4 --icons'
alias la='eza -a --icons'
alias ai='cursor'
alias nproc="sysctl -n hw.physicalcpu"
alias mr="mise run"
alias voxconvert="/Applications/vengi-voxconvert.app/Contents/MacOS/vengi-voxconvert"
alias vox2fbx='blender --background --python convert.py -- out128x.vox model.fbx'
# misc
