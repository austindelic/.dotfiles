export PATH="/opt/homebrew/bin:$PATH"
export PATH="/Users/AustinDe/.cache/.bun/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.rustup/toolchains/stable-aarch64-apple-darwin/bin:$PATH"
eval "$(mise activate zsh)"
eval "$(zoxide init zsh)"
source <(fzf --zsh)
enable-fzf-tab
export EDITOR=nvim
export STU_ROOT_DIR="~/.config/stu"
export GPG_TTY=\$(tty)
