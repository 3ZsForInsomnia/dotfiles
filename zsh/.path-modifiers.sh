PATH="$PATH:/Applications/WezTerm.app/Contents/MacOS"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PATH="/opt/homebrew/opt/postgresql@13/bin:$PATH"

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

. "$HOME/.cargo/env"

export PATH=/usr/local/bin:$PATH
export JAVA_HOME=$(/usr/libexec/java_home)

source "$HOME/.profile"

export PATH=$PATH:/opt/apache-maven/bin
export GOPATH=~/go/

export LUA_PATH="$HOME/lua/;;"

### Navigator items
export BASH_SILENCE_DEPRECATION_WARNING=1
export RCI_ENV=LOCALHOST
export LOOKER_EMBED_GROUPS=''
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

# export LDFLAGS="-L$(brew --prefix openssl)/lib"
# export CFLAGS="-I$(brew --prefix openssl)/include"
# export SWIG_FEATURES="-cpperraswarn -includeall -I$(brew --prefix openssl)/include"
