#!/bin/zsh
#
# .zshrc - Zsh file loaded on interactive shell sessions.
#

[[ -o interactive ]] || return 0

# If not in tmux, start tmux.
# if [[ -z ${TMUX+X}${ZSH_SCRIPT+X}${ZSH_EXECUTION_STRING+X} ]]; then
#   tmux
# fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of .zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Lazy-load (autoload) Zsh function files from a directory.

ZFUNCDIR=${ZDOTDIR:-$HOME}/.zfunctions
fpath=($ZFUNCDIR $fpath)
autoload -Uz "$ZFUNCDIR"/*(N:t)


ANTIDOTE_PATH="$(antidote_path 2>/dev/null || true)"
# Set any zstyles you might use for configuration.
[[ ! -f ${ZDOTDIR:-$HOME}/.zstyles ]] || source ${ZDOTDIR:-$HOME}/.zstyles

# If antidote is missing, install it once
if [[ ! -f "$ANTIDOTE_PATH" ]]; then
  brew install antidote
fi

# Source antidote instantly if it exists
if [[ -f "$ANTIDOTE_PATH" ]]; then
  source "$ANTIDOTE_PATH"
fi

# Create an amazing Zsh config using antidote plugins.
antidote load

# Source anything in .zshrc.d.
for _rc in ${ZDOTDIR:-$HOME}/.zshrc.d/*.zsh; do
  # Ignore tilde files.
  if [[ $_rc:t != '~'* ]]; then
    source "$_rc"
  fi
done
unset _rc

# To customize prompt, run `p10k configure` or edit .p10k.zsh.

source $POWERLEVEL9K_CONFIG_FILE
source "$HOME/.cargo/env"