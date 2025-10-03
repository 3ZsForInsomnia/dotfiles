export XDG_CACHE_HOME=$HOME/.cache
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state
export XDG_BIN_HOME=$HOME/.local/bin
export XDG_RUNTIME_DIR="/tmp"
export XDG_CODE_HOME=$HOME/src
export XDG_DATA_DIRS="$HOME/.local/data:$XDG_DATA_DIRS"
export XDG_CODE_HOME=$HOME/src
export ZSH_CONFIG_DIR="$XDG_CODE_HOME/zsh"

export POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true

# Essential environment variables
export EDITOR=nvim
export VISUAL=nvim
export PAGER="delta"
export TZ='America/New_York'
export TIMEZONE="America/New_York"


# Basic PATH (minimal version needed by all shells)
export PATH="/usr/bin:/usr/local:/usr/local/bin:$HOME/.local:$HOME/.local/bin:$HOME/.local/bin:$PATH"
