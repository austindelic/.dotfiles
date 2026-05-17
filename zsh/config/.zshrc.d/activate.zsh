export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/still/bin:$PATH"
export PATH="/Users/AustinDe/.cache/.bun/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.rustup/toolchains/stable-aarch64-apple-darwin/bin:$PATH"
export PATH="/opt/homebrew/opt/ccache/libexec:$PATH"
export HOMEBREW_NO_ENV_HINTS=1
eval "$(mise activate zsh)"
eval "$(zoxide init zsh)"
export EDITOR="zed --wait"
export STU_ROOT_DIR="~/.config/stu"
export GPG_TTY=\$(tty)
export TERM=xterm-256color
export VCPKG_ROOT=~/.vcpkg
export ANDROID_HOME="$HOME/Library/Android/sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export ANTHROPIC_BASE_URL="https://openrouter.ai/api"
export ANTHROPIC_AUTH_TOKEN="$OPENROUTER_API_KEY"
export ANTHROPIC_API_KEY=""
export PATH="$ANDROID_HOME/emulator:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"
export HISTFILE="$HOME/.local/share/zsh/history"
export HISTSIZE=1000
export SAVEHIST=1000
eval "$(atuin init zsh)"
bindkey -M vicmd '^R' atuin-search-vicmd
