export FZF_DEFAULT_COMMAND='fd -H --type f'
export FZF_DEFAULT_OPTS='--height 80% --layout=reverse --border --bind "ctrl-d:preview-down" --bind "ctrl-u:preview-up"'
export VISUAL=nvim
export EDITOR="$VISUAL"
export TZ='America/New_York'
export CRON_LOG="$HOME/.local/state/cron/cron.log"

export XDG_CACHE_HOME=$HOME/.cache
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state
export XDG_DATA_DIRS="$HOME/.local/data:$XDG_DATA_DIRS"
export XDG_CODE_HOME=$HOME/src
export XDG_BIN_HOME=$HOME/.local/bin

export ZSH_COMPDUMP="$XDG_CACHE_HOME/zsh/zcompcache"
export HISTFILE="$XDG_STATE_HOME/zsh/history"
export PYTHON_HISTORY="$XDG_STATE_HOME/python/history"
export PSQL_HISTORY="$XDG_STATE_HOME/psql/history"
export PGPASSFILE="$XDG_DATA_HOME/psql/pgpass"
export LESSHISTFILE="$XDG_STATE_HOME/less/history"

ubin="/usr/bin"
uloc="/usr/local"
ulobin="/usr/local/bin"
hloc="$HOME/.local"
hlobin="$hloc/bin"
hbin="$hloc/bin"

######################
# Global variables   #
######################

export NPM_PACKAGES="$XDG_DATA_HOME/npm"
npm config set prefix "$NPM_PACKAGES"
# Likely do not need this set since node + npm should handle it automatically given the npm prefix is set
# export NODE_PATH="$NODE_PATH:$NPM_PACKAGES/lib/node_modules"

export PYENV_ROOT="$XDG_DATA_HOME/pyenv"

export CMAKE_INSTALL_PREFIX=$ulobin

# Leaving this where it is since it is currently in use
export LUA_PATH="$HOME/.luarocks/share/lua/5.1/?.lua;$uloc/share/lua/5.1/?.lua;"
# export LUAROCKS_CONFIG="$XDG_CONFIG_HOME/luarocks/config.lua"

# Dasht config
export DASHT_DOCSETS_DIR=$hloc/share/Zeal/Zeal/docsets/

export GOPATH=$XDG_DATA_HOME/go/

export RIPGREP_CONFIG_PATH=$XDG_CONFIG_HOME/ripgrep

export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"

######################
# Path modifiers     #
######################

py3=$ubin/python3
pybin=$PYENV_ROOT/bin
nbin=$NPM_PACKAGES/bin
maven=/opt/apache-maven/bin
nvim=$XDG_CODE_HOME/neovim/build/bin
xdgbin=$XDG_BIN_HOME
cargo=$CARGO_HOME/bin

# Note that this assumes postgres is installed via homebrew! This must be updated for linux
psql=/opt/homebrew/opt/postgresql@12/bin

export PATH="$cargo:$xdgbin:$ubin:$ulobin:$hlobin:$hbin:$py3:$pybin:$nbin:$maven:$nvim:$psql:$PATH"

# Must happen after PATH is set
# eval "$(pyenv init --path)"

######################
# OS specific items  #
######################

if [[ $(uname) == "Darwin" ]]; then
  export MY_SYSTEM="mac"
  PATH="$PATH:/Applications/WezTerm.app/Contents/MacOS"
elif [[ "$(expr substr $(uname -s) 1 5)" == "Linux" ]]; then
  export MY_SYSTEM="linux"
else
  export MY_SYSTEM="windows"
  # Required for opening browser in WSL
  export BROWSER=wslview
fi

# This appears unused - site this is from:
#   https://github.com/sindresorhus/guides/blob/main/npm-global-without-sudo.md
# Originally needed this on WSL/MacOS, but on Arch it appears irrelevant?
# Preserve MANPATH if you already defined it somewhere in your config.
# Otherwise, fall back to `manpath` so we can inherit from `/etc/manpath`.
# export MANPATH="${MANPATH-$(manpath)}:$NPM_PACKAGES/share/man"
