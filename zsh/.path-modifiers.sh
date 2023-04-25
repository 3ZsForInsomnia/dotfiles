export BROWSER=wslview

# PATH="$PATH:/Applications/WezTerm.app/Contents/MacOS"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="/usr/bin/python3:$PATH"
# export PATH="/opt/homebrew/opt/postgresql@13/bin:$PATH"

export NODE_PATH=$NODE_PATH:$HOME/.npm/lib/node_modules
export PATH=$PATH:$HOME/.npm/bin

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# . "$HOME/.cargo/cargo"

export PATH=/usr/local/bin:$PATH
# export JAVA_HOME=$(/usr/libexec/java_home)

export PATH=$PATH:/opt/apache-maven/bin
export GOPATH=~/src/go/

export LUA_PATH="$HOME/.luarocks/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?.lua;;"

# Required for opening browser in WSL
export BROWSER=wslview
