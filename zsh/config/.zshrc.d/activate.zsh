export PATH="/opt/homebrew/bin:$PATH"
export PATH="/Users/AustinDe/.cache/.bun/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.rustup/toolchains/stable-aarch64-apple-darwin/bin:$PATH"
eval "$(mise activate bash)"
eval "$(zoxide init zsh)"
source <(fzf --zsh)
enable-fzf-tab
export EDITOR=nvim
