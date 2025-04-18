# Helpers
ubin="/usr/bin"
uloc="/usr/local"
ulobin="/usr/local/bin"
hloc="$HOME/.local"
hlobin="$hloc/bin"
hbin="$hloc/bin"

######################
# Global variables   #
######################

# export TERM="wezterm"
export VISUAL=nvim
export EDITOR="$VISUAL"
export TZ='America/New_York'
export TIMEZONE="America/New_York"
export CRON_LOG="$HOME/.local/state/cron/cron.log"

export XDG_CACHE_HOME=$HOME/.cache
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state
export XDG_BIN_HOME=$HOME/.local/bin
export XDG_DATA_DIRS="$HOME/.local/data:$XDG_DATA_DIRS"
export XDG_RUNTIME_DIR="/tmp"

export ZSH_COMPDUMP="$XDG_CACHE_HOME/zsh/zcompdump"
export ZSH_CACHE_DIR="$XDG_CACHE_HOME/zsh/zcompcache"
export HISTFILE="$XDG_STATE_HOME/zsh/history"
export LESSHISTFILE="$XDG_STATE_HOME/less/history"
export PYTHON_HISTORY="$XDG_STATE_HOME/python/history"
export PSQL_HISTORY="$XDG_STATE_HOME/psql/history"
export PGPASSFILE="$XDG_DATA_HOME/psql/.pgpass"
export BOOKMARKS_FILE="$XDG_DATA_HOME/bookmarks/.bookmarks"
export GIT_CONFIG_GLOBAL="$XDG_CONFIG_HOME/git/.gitconfig"
export LPASS_HOME="$XDG_DATA_HOME/lpass"

export AZURE_CONFIG_DIR="$XDG_CONFIG_HOME/azure"
export KUBECONFIG="$XDG_CONFIG_HOME/kube/config"
export KUBECACHEDIR="$XDG_CACHE_HOME/kube"

export JARS="$XDG_CODE_HOME/java_jars"
export SCHEMASPY_LOCATION="$JARS/schemaspy/schemaspy.jar"
export POSTGRES_JDBC_LOCATION="$JARS/postgres/postgres.jar"

export FZF_DEFAULT_COMMAND='fd -H --type f'
export FZF_DEFAULT_OPTS='--height 80% --layout=reverse --border --bind "ctrl-d:preview-down" --bind "ctrl-u:preview-up"'

export FX_THEME=6

export WORK_PATH="$XDG_CODE_HOME/work"

export JAVA_HOME="/opt/homebrew/opt/openjdk@17/bin"

export NPM_PACKAGES="$XDG_DATA_HOME/npm"
export NPM_CONFIG_PREFIX="$NPM_PACKAGES"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
# Likely do not need this set since node + npm should handle it automatically given the npm prefix is set
export NODE_PATH="$NODE_PATH:$NPM_PACKAGES/lib/node_modules"

export PYENV_ROOT="$XDG_DATA_HOME/pyenv"

export CMAKE_INSTALL_PREFIX=$ulobin

# Leaving this where it is since it is currently in use
export LUA_PATH="$HOME/.luarocks/share/lua/5.1/?.lua;$uloc/share/lua/5.1/?.lua;$XDG_CONFIG_HOME/luarocks/?.lua;"
export LUAROCKS_CONFIG="$XDG_CONFIG_HOME/luarocks/config.lua"

# Dasht config
export DASHT_DOCSETS_DIR=$hloc/share/Zeal/Zeal/docsets/

export GOPATH=$XDG_DATA_HOME/go/

export RIPGREP_CONFIG_PATH=$XDG_CONFIG_HOME/ripgrep

export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"

export PGUSER="postgres"

export JIRA_BROWSER="google-chrome"

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
wez=/Applications/WezTerm.app/Contents/MacOS
go=$GOPATH/bin

# Note that this assumes postgres is installed via homebrew! This must be updated for linux
psql=/opt/homebrew/opt/postgresql@12/bin

export PATH="$JAVA_HOME:$go:$wez:$cargo:$xdgbin:$ubin:$ulobin:$hlobin:$hbin:$py3:$pybin:$nbin:$maven:$nvim:$psql:$PATH"

# Must happen after PATH is set
eval "$(pyenv init --path)"

######################
# OS specific items  #
######################

if [[ $(uname) == "Darwin" ]]; then
  export MY_SYSTEM="mac"
  export BROWSER="google-chrome"
elif [[ "$(expr substr $(uname -s) 1 5)" == "Linux" ]]; then
  export MY_SYSTEM="linux"
  export BROWSER="google-chrome"
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
