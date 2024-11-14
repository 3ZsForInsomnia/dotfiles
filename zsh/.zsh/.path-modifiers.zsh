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
export NPM_PACKAGES="$HOME/.npm-global"
export XDG_CODE_HOME=$HOME/code
export PYENV_ROOT="$HOME/.pyenv"

ubin="/usr/bin"
uloc="/usr/local"
ulobin="/usr/local/bin"
hloc="$HOME/.local"
hlobin="$hloc/bin"
hbin="$hloc/bin"

######################
# Path modifiers     #
######################

py3=$ubin/python3
pybin=$PYENV_ROOT/bin
nbin=$NPM_PACKAGES/bin
maven=/opt/apache-maven/bin

export PATH="$ubin:$ulobin:$hlobin:$hbin:$py3:$pybin:$nbin:$maven:$PATH"

######################
# Global variables   #
######################

export NODE_PATH="$NODE_PATH:$NPM_PACKAGES/lib/node_modules"

export CMAKE_INSTALL_PREFIX=$ulobin

export LUA_PATH="$HOME/.luarocks/share/lua/5.1/?.lua;$uloc/share/lua/5.1/?.lua;"

# Dasht config
export DASHT_DOCSETS_DIR=$hloc/share/Zeal/Zeal/docsets/

export GOPATH=$XDG_CODE_HOME/go/

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

export RIPGREP_CONFIG_PATH=$XDG_CONFIG_HOME/ripgrep
