source "$ZSH_CONFIG_DIR/.path-modifiers.zsh"
if [[ -f "$ZSH_CONFIG_DIR/.env" ]]; then
  source "$ZSH_CONFIG_DIR/.env"
fi

source "$HOME/src/powerlevel10k/powerlevel10k.zsh-theme"
source "$ZSH_CONFIG_DIR/.p10k.zsh"

source "$ZSH_CONFIG_DIR/tools/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$ZSH_CONFIG_DIR/tools/zshmarks/zshmarks.plugin.zsh"
source "$ZSH_CONFIG_DIR/tools/fast-syntax-highlight/fast-syntax-highlighting.plugin.zsh"
source "$ZSH_CONFIG_DIR/tools/zsh-you-should-use/you-should-use.plugin.zsh"
source "$ZSH_CONFIG_DIR/tools/.omz-git-completions.zsh"
source "$ZSH_CONFIG_DIR/tools/.reveal-alias.zsh"

source "$ZSH_CONFIG_DIR/aliases/index.zsh"

. "$XDG_DATA_HOME/cargo/env"
