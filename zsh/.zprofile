eval "$(/opt/homebrew/bin/brew shellenv)"

export PYENV_ROOT="$XDG_DATA_HOME/pyenv"
eval "$(pyenv init --path)"

export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
[ -f "$CARGO_HOME/env" ] && . "$CARGO_HOME/env"

export GOPATH=$XDG_DATA_HOME/go/
export JAVA_HOME="/opt/homebrew/opt/openjdk@17/bin"

export KUBECONFIG="$XDG_CONFIG_HOME/kube/config"
export RIPGREP_CONFIG_PATH=$XDG_CONFIG_HOME/ripgrep

[ -f "$ZSH_CONFIG_DIR/.env" ] && source "$ZSH_CONFIG_DIR/.env"

export PATH="$JAVA_HOME:/opt/homebrew/bin:$GOPATH/bin:/Applications/WezTerm.app/Contents/MacOS:$CARGO_HOME/bin:$XDG_BIN_HOME:$PYENV_ROOT/bin:$NPM_PACKAGES/bin:/opt/apache-maven/bin:$XDG_CODE_HOME/neovim/build/bin:/opt/homebrew/opt/postgresql@12/bin:$PATH"
