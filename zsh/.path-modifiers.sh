# PATH="$PATH:/Applications/WezTerm.app/Contents/MacOS"

export PATH=/usr/bin:$PATH

export PYENV_ROOT="$HOME/.pyenv"
export PATH="/usr/bin/python3:$PYENV_ROOT/bin:$HOME/.local/bin:$PATH"
# export PATH="/opt/homebrew/opt/postgresql@13/bin:$PATH"

# export NODE_PATH=$NODE_PATH:$HOME/.npm/lib/node_modules
# export NODE_PATH=$NODE_PATH:/usr/local/lib/node_modules
export PATH=$PATH:$HOME/.npm/bin

# export VOLTA_HOME="$HOME/.volta"
# export PATH="$VOLTA_HOME/bin:$PATH"

# . "$HOME/.cargo/cargo"

export PATH=/usr/local/bin:$PATH
# export JAVA_HOME=$(/usr/libexec/java_home)

export PATH=$PATH:/opt/apache-maven/bin
export GOPATH=~/src/go/

export LUA_PATH="$HOME/.luarocks/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?.lua;;"

# Required for opening browser in WSL
export BROWSER=wslview

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
