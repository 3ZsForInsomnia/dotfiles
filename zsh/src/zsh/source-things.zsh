source $ZSH_CONFIG_DIR/tools/zsh-defer/zsh-defer.plugin.zsh
source "$HOME/src/powerlevel10k/powerlevel10k.zsh-theme"
source "$ZSH_CONFIG_DIR/.p10k.zsh"
source "$ZSH_CONFIG_DIR/path-modifiers.zsh"
source "$ZSH_CONFIG_DIR/.env"

source "$ZSH_CONFIG_DIR/tools/reveal-alias.zsh"
source "$ZSH_CONFIG_DIR/tools/lazy-loading.zsh"
source "$ZSH_CONFIG_DIR/tools/compile-large-files.zsh"

zsh-defer setup_deferred_env
zsh-defer source "$ZSH_CONFIG_DIR/tools/zsh-autosuggestions/zsh-autosuggestions.zsh"
zsh-defer source "$ZSH_CONFIG_DIR/tools/fast-syntax-highlight/fast-syntax-highlighting.plugin.zsh"
zsh-defer source "$ZSH_CONFIG_DIR/tools/zsh-you-should-use/you-should-use.plugin.zsh"
zsh-defer source "$ZSH_CONFIG_DIR/tools/zshmarks/zshmarks.plugin.zsh"
zsh-defer source "$ZSH_CONFIG_DIR/tools/help/zh.zsh"
zsh-defer compile_large_zsh_files

source "$ZSH_CONFIG_DIR/aliases/index.zsh"
