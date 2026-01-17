export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/still/bin:$PATH"
export PATH="/Users/AustinDe/.cache/.bun/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.rustup/toolchains/stable-aarch64-apple-darwin/bin:$PATH"
export PATH="/opt/homebrew/opt/ccache/libexec:$PATH"
eval "$(mise activate zsh)"
eval "$(zoxide init zsh)"
source <(fzf --zsh)
enable-fzf-tab
export EDITOR="zed --wait"
export STU_ROOT_DIR="~/.config/stu"
export GPG_TTY=\$(tty)
export TERM=xterm-256color
