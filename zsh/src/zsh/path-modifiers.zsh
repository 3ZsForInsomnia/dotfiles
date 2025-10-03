##
## Helpers
##

######################
# Global variables   #
######################

export CRON_LOG="$HOME/.local/state/cron/cron.log"

export LESSHISTFILE="$XDG_STATE_HOME/less/history"
export PYTHON_HISTORY="$XDG_STATE_HOME/python/history"
export PSQL_HISTORY="$XDG_STATE_HOME/psql/history"
export PGPASSFILE="$XDG_DATA_HOME/psql/.pgpass"
export BOOKMARKS_FILE="$XDG_DATA_HOME/bookmarks/.bookmarks"
export GIT_CONFIG_GLOBAL="$XDG_CONFIG_HOME/git/.gitconfig"
export LPASS_HOME="$XDG_DATA_HOME/lpass"
export LPASS_AGENT_TIMEOUT=$((7 * 24 * 60 * 60)) # 7 days in seconds

export AZURE_CONFIG_DIR="$XDG_CONFIG_HOME/azure"
export KUBECONFIG="$XDG_CONFIG_HOME/kube/config"
export KUBECACHEDIR="$XDG_CACHE_HOME/kube"

export JARS="$XDG_CODE_HOME/java_jars"
export SCHEMASPY_LOCATION="$JARS/schemaspy/schemaspy.jar"
export POSTGRES_JDBC_LOCATION="$JARS/postgres/postgres.jar"

export FZF_DEFAULT_COMMAND='fd -H --type f'
export FZF_DEFAULT_OPTS='--height 80% --layout=reverse --border --bind "ctrl-d:preview-down" --bind "ctrl-u:preview-up"'

export FX_THEME=6

export W_PATH="$XDG_CODE_HOME/work"

export JAVA_HOME="/opt/homebrew/opt/openjdk@17/bin"

export NPM_PACKAGES="$XDG_DATA_HOME/npm"
export NPM_CONFIG_PREFIX="$NPM_PACKAGES"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
# Likely do not need this set since node + npm should handle it automatically given the npm prefix is set
export NODE_PATH="$NPM_PACKAGES/lib/node_modules"

export PYENV_ROOT="$XDG_DATA_HOME/pyenv"

export CMAKE_INSTALL_PREFIX=/usr/local/bin

# Leaving this where it is since it is currently in use
export LUA_PATH="$HOME/.luarocks/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?.lua;$XDG_CONFIG_HOME/luarocks/?.lua;"
export LUAROCKS_CONFIG="$XDG_CONFIG_HOME/luarocks/config.lua"

# Dasht config
export DASHT_DOCSETS_DIR=$HOME/.local/share/Zeal/Zeal/docsets/

export GOPATH=$XDG_DATA_HOME/go/

export RIPGREP_CONFIG_PATH=$XDG_CONFIG_HOME/ripgrep

export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"

export PGUSER="postgres"

export JIRA_BROWSER="google-chrome"

######################
# Path modifiers     #
######################


typeset -U path # Ensures unique entries
path=(
  "$JAVA_HOME"
  "$HOME/.cargo/bin"
  "/opt/homebrew/bin"
  "$GOPATH/bin"
  "/Applications/WezTerm.app/Contents/MacOS"
  "$CARGO_HOME/bin"
  "$XDG_BIN_HOME"
  "/usr/bin/python3"
  "$PYENV_ROOT/bin"
  "$NPM_PACKAGES/bin"
  "/opt/apache-maven/bin"
  "$XDG_CODE_HOME/neovim/build/bin"
  "/opt/homebrew/opt/postgresql@12/bin"
  "$kubediff"
  $path
)
export PATH

function setup_deferred_env() {
  # History and cache files
  export LESSHISTFILE="$XDG_STATE_HOME/less/history"
  export PYTHON_HISTORY="$XDG_STATE_HOME/python/history"
  export PSQL_HISTORY="$XDG_STATE_HOME/psql/history"
  export PGPASSFILE="$XDG_DATA_HOME/psql/.pgpass"
  export BOOKMARKS_FILE="$XDG_DATA_HOME/bookmarks/.bookmarks"

  # Config paths
  export AZURE_CONFIG_DIR="$XDG_CONFIG_HOME/azure"
  export KUBECONFIG="$XDG_CONFIG_HOME/kube/config"
  export KUBECACHEDIR="$XDG_CACHE_HOME/kube"
  export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep"

  # Java related
  export JARS="$XDG_CODE_HOME/java_jars"
  export SCHEMASPY_LOCATION="$JARS/schemaspy/schemaspy.jar"
  export POSTGRES_JDBC_LOCATION="$JARS/postgres/postgres.jar"

  # Less commonly used env vars
  export LPASS_HOME="$XDG_DATA_HOME/lpass"
  export LUA_PATH="$HOME/.luarocks/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?.lua;$XDG_CONFIG_HOME/luarocks/?.lua;"
  export LUAROCKS_CONFIG="$XDG_CONFIG_HOME/luarocks/config.lua"
  export DASHT_DOCSETS_DIR="$HOME/.local/share/Zeal/Zeal/docsets/"

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
}
