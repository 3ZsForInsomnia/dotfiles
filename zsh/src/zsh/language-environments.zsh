##
## Language-specific environment configurations
##

######################
# Java               #
######################

export JAVA_HOME="/opt/homebrew/opt/openjdk@17/bin"
export JARS="$XDG_CODE_HOME/java_jars"
export SCHEMASPY_LOCATION="$JARS/schemaspy/schemaspy.jar"
export POSTGRES_JDBC_LOCATION="$JARS/postgres/postgres.jar"
export CMAKE_INSTALL_PREFIX=/usr/local/bin

######################
# Node/NPM           #
######################

export NPM_PACKAGES="$XDG_DATA_HOME/npm"
export NPM_CONFIG_PREFIX="$NPM_PACKAGES"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"
# Likely do not need this set since node + npm should handle it automatically given the npm prefix is set
export NODE_PATH="$NPM_PACKAGES/lib/node_modules"

######################
# Python             #
######################

export PYENV_ROOT="$XDG_DATA_HOME/pyenv"

######################
# Go                 #
######################

export GOPATH=$XDG_DATA_HOME/go/

######################
# Rust/Cargo         #
######################

export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"

######################
# Lua                #
######################

# Leaving this where it is since it is currently in use
export LUA_PATH="$HOME/.luarocks/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?.lua;$XDG_CONFIG_HOME/luarocks/?.lua;"
export LUAROCKS_CONFIG="$XDG_CONFIG_HOME/luarocks/config.lua"